import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_best_practices/exceptions.dart';
import 'package:flutter_best_practices/services/api_service.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class AuthService extends ApiService with Logging {
  final authToken = ValueNotifier<String?>(null);
  final authTokenValidating = ValueNotifier<bool>(false);

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await basePost(
      path: 'login',
      data: {
        'username': username,
        'password': password,
      },
      withAuthToken: false,
    );
    authToken.value = response.data['token'] as String?;
  }

  Future<void> validateAuthToken() async {
    if (authToken.value == null) {
      throw Error();
    }
    await baseGet(path: 'validate-token');
  }
}

class MockAuthService extends AuthService with Logging {
  final String errorEmail;
  final String networkTimeoutEmail;
  final bool validateAuthTokenSuccess;

  MockAuthService({
    this.errorEmail = 'error@example.com',
    this.networkTimeoutEmail = 'networktimeout@example.com',
    this.validateAuthTokenSuccess = true,
  });

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    log('MockAuthService.login called with: $username / $password');
    checkNetworkConnectivity();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (username == errorEmail) {
      throw DioException(requestOptions: RequestOptions(path: 'login'));
    }
    if (username == networkTimeoutEmail) {
      throw NetworkTimeoutException();
    }
    authToken.value = 'mock_token';
  }

  @override
  Future<void> validateAuthToken() async {
    log('MockAuthService.validateAuthToken called');
    checkNetworkConnectivity();
    if (authToken.value == null) {
      throw Error();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (!validateAuthTokenSuccess) {
      throw DioException(
        requestOptions: RequestOptions(
          path: 'validate-token',
        ),
        error: 'Not Authorized',
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(
            path: 'validate-token',
          ),
        ),
      );
    }
  }
}
