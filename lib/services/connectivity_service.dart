import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_best_practices/utils/deferred_change_notifier.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class ConnectivityService extends DeferredChangeNotifier with Logging {
  @protected
  Connectivity? connectivity;

  List<ConnectivityResult> _statuses = [ConnectivityResult.none];

  /// Returns last known statuses:
  /// - bluetooth
  /// - wifi
  /// - ethernet
  /// - mobile
  /// - none
  /// - vpn
  /// - other
  List<ConnectivityResult> get statuses => [..._statuses];

  @protected
  bool connected = false;

  bool get isConnected {
    return connected;
  }

  ConnectivityService() {
    connectivity = Connectivity();
    connectivity!.onConnectivityChanged.listen((result) {
      log('Received connection status of $result.');
      _statuses = result;
      final prevConnected = connected;
      connected =
          _statuses.contains(ConnectivityResult.vpn) ||
          _statuses.contains(ConnectivityResult.wifi) ||
          _statuses.contains(ConnectivityResult.mobile) ||
          _statuses.contains(ConnectivityResult.ethernet);
      if (connected != prevConnected) {
        notifyListeners();
      }
    });
  }

  /// This constructor is for TestConnectivityService to call
  /// so the default constructor is not implicitly called.
  ConnectivityService._noListeners();

  /// This is only needed on pages where the a user can await for the connectivity
  /// to be established such as the landing page. Otherwise, [isConnected] should
  /// be used, or the [connectedStream] can be listened to.
  Future<void> checkConnectivity() async {
    _statuses =
        await connectivity?.checkConnectivity() ?? [ConnectivityResult.none];
    final prevConnected = connected;
    connected =
        _statuses.contains(ConnectivityResult.wifi) ||
        _statuses.contains(ConnectivityResult.mobile) ||
        _statuses.contains(ConnectivityResult.ethernet);
    if (connected != prevConnected) {
      notifyListeners();
    }
  }
}

class MockConnectivityService extends ConnectivityService {
  MockConnectivityService({required bool connected}) : super._noListeners() {
    this.connected = connected;
  }

  @override
  Future<void> checkConnectivity() async {
    // Do nothing
  }
}
