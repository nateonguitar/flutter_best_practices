import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/exceptions.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/services/connectivity_service.dart';
import 'package:flutter_best_practices/utils/logging.dart';

abstract mixin class ApiService {
  static late Dio dio;

  @protected
  void checkNetworkConnectivity() {
    final connectivityService = Provider.get<ConnectivityService>();
    if (!connectivityService.isConnected) {
      throw NoNetworkConnectionException();
    }
  }

  /// Checks the build config to see if a mockSlowNetworkDuration is already set.
  /// If so, and if it is greater than the min wait time, the mockSlowNetworkDuration
  /// will be used instead of the min wait time.
  @protected
  Future<void> mockNetworkLatency() async {
    final duration = BuildConfig.instance.mockNetworkLatencyDuration;
    if (duration == null) {
      return;
    }
    devLog(
      'Waiting ${duration.inMilliseconds}ms',
      name: runtimeType.toString(),
    );
    await Future.delayed(duration);
  }

  @protected
  Future<Options> buildOptions({
    required bool attachAuthToken,
    Map<String, dynamic>? headers,
  }) async {
    headers ??= {};
    if (attachAuthToken) {
      final authService = Provider.get<AuthService>();
      final token = authService.authToken.value;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    final options = Options(headers: headers);
    return options;
  }

  // A method that wraps around all requests and if the request fails with 401 due to token expiration,
  // it will refresh the token and retry the request.
  // Request must be built with headers inside the requestBuilder so it uses the updated token.
  Future<Response<dynamic>> _attemptRequest(
    Future<Response<dynamic>> Function() requestBuilder,
  ) async {
    try {
      return await requestBuilder();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Use AuthManager for token refresh
        // final authManager = Provider.get<AuthManager>();
        // await authManager.refreshAuthToken();
        return requestBuilder();
      }
      rethrow;
    }
  }

  @protected
  Future<Response> baseGet({
    required String path,
    bool withAuthToken = true,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    void Function(int progress, int outof)? onReceiveProgress,
  }) async {
    _logApiCall('GET', path, queryParameters);
    checkNetworkConnectivity();
    await mockNetworkLatency();

    return _attemptRequest(() async {
      final options = await buildOptions(
        attachAuthToken: withAuthToken,
        headers: headers,
      );
      return dio.get(
        path,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  @protected
  Future<Response> baseDelete({
    required String path,
    bool withAuthToken = true,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) async {
    _logApiCall('DELETE', path, queryParameters);
    checkNetworkConnectivity();
    await mockNetworkLatency();

    return _attemptRequest(() async {
      final options = await buildOptions(
        attachAuthToken: withAuthToken,
        headers: headers,
      );
      return dio.delete(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    });
  }

  @protected
  Future<Response> basePost({
    required String path,
    bool withAuthToken = true,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    void Function(int progress, int outof)? onSendProgress,
    void Function(int progress, int outof)? onReceiveProgress,
  }) async {
    _logApiCall('POST', path, queryParameters);
    checkNetworkConnectivity();
    await mockNetworkLatency();

    return _attemptRequest(() async {
      final options = await buildOptions(
        attachAuthToken: withAuthToken,
        headers: headers,
      );
      return dio.post(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  @protected
  Future<Response> basePut({
    required String path,
    bool withAuthToken = true,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
    Map<String, dynamic>? headers,
    void Function(int progress, int outof)? onSendProgress,
    void Function(int progress, int outof)? onReceiveProgress,
  }) async {
    _logApiCall('PUT', path, queryParameters);
    checkNetworkConnectivity();
    await mockNetworkLatency();

    return _attemptRequest(() async {
      final options = await buildOptions(
        attachAuthToken: withAuthToken,
        headers: headers,
      );
      return dio.put(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  @protected
  Future<Response> basePatch({
    required String path,
    bool withAuthToken = true,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
    Map<String, dynamic>? headers,
    void Function(int progress, int outof)? onSendProgress,
    void Function(int progress, int outof)? onReceiveProgress,
  }) async {
    _logApiCall('PATCH', path, queryParameters);
    checkNetworkConnectivity();
    await mockNetworkLatency();

    return _attemptRequest(() async {
      final options = await buildOptions(
        attachAuthToken: withAuthToken,
        headers: headers,
      );
      return dio.patch(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  @protected
  Future<bool> pushDeletesForProject<T>({
    required String projectId,
    required String apiBulkDeletePath,
    required Future<List<T>> Function(String projectId) getProjectItems,
    required String Function(T item) itemIdGetter,
    required Future<void> Function(List<String> ids) deleteIn,
    required Future<void> Function(Map<String, dynamic> errors) updateErrors,
    required CancelToken cancelToken,
  }) async {
    final List<T> items = await getProjectItems(projectId);
    if (items.isEmpty) {
      return false;
    }
    final ids = [for (final item in items) itemIdGetter(item)];
    final data = {'recordsToDelete': ids};
    final response = await baseDelete(
      path: apiBulkDeletePath,
      data: data,
      cancelToken: cancelToken,
    );
    final Map<String, dynamic> errors = response.data['errors'];
    final List<String> errorIds = [
      for (final entry in errors.entries) entry.key,
    ];
    final idsToDelete = [
      for (final id in ids)
        if (!errorIds.contains(id)) id,
    ];
    await deleteIn(idsToDelete);
    await updateErrors(errors);
    return true;
  }

  void _logApiCall(String verb, String path, Map? queryParameters) {
    String queryLogString = BuildConfig.instance.apiUrl + path;
    if (queryParameters != null) {
      final buffer = StringBuffer();
      for (final qp in queryParameters.entries.toList()) {
        if (buffer.isEmpty) {
          buffer.write('?');
        } else {
          buffer.write('&');
        }
        buffer.write('${qp.key}=${qp.value}');
      }
      queryLogString += buffer.toString();
    }
    devLog('$verb $queryLogString', name: runtimeType.toString());
  }
}
