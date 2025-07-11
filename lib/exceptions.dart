class NetworkTimeoutException implements Exception {
  @override
  String toString() => 'Network timeout';
}

class NoNetworkConnectionException implements Exception {
  @override
  String toString() => 'Not connected to a network';
}

class CurrentLocationException implements Exception {
  @override
  String toString() => 'Could not determine current location.';
}

class NoCamerasAvailableException implements Exception {
  @override
  String toString() => 'No cameras available';
}

class LocationPermissionDeniedException implements Exception {
  @override
  String toString() => 'Location Permissions Denied';
}

class LocationPermissionDeniedForeverException implements Exception {
  @override
  String toString() => 'Location Permissions Denied Forever';
}

class LocationServicesDisabledException implements Exception {
  @override
  String toString() => 'Location Services Disabled';
}

class TooManyRetriesException implements Exception {
  @override
  String toString() => 'Too many retries';
}

class SessionExpiredException implements Exception {
  @override
  String toString() => 'Session expired';
}

class InvalidUserRolesException implements Exception {
  @override
  String toString() => 'Invalid user roles';
}

class SessionUserIdNotSet implements Exception {
  @override
  String toString() => 'Session user ID not set';
}
