enum Environment {
  production,
  staging,
  development,
  test,
  //
}

class LoginAutofill {
  final String email;
  final String password;

  LoginAutofill({
    required this.email,
    required this.password,
  });
}

class BuildConfig {
  static late BuildConfig instance;

  final String apiUrl;
  final Duration? mockNetworkLatencyDuration;
  final Environment environment;
  final String appDocumentDirSubFolder;
  LoginAutofill? loginAutofill;

  BuildConfig({
    required this.apiUrl,
    this.loginAutofill,
    this.mockNetworkLatencyDuration,
    this.environment = Environment.production,
    this.appDocumentDirSubFolder = 'com.example.flutter_best_practices',
  }) {
    if (environment == Environment.production) {
      loginAutofill = null;
    }
  }
}
