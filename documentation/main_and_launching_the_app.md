# Main and Launching the App

Flutter uses `lib/main.dart` as the injection point of the app. In a fresh app, this just calls `runApp` with the root widget `App`

```dart
// default lib/main.dart
runApp(const App());
```

A convenient pattern is to make the `main.dart` be the production build, so `flutter build appbundle`
will automatically point at the correct main for releasing.
Other "mains" can be created for other purposes, like development.

This tutorial will show how to create separate lauch configs for different mains,
a `BuildConfig` for customizing builds, and examples of different mains.

If using VSCode create a `.vscode/launch.json` file.
Add `.vscode` to the `.gitignore` so developers can customize as needed. Consider creating a `.vscode.example` folder with good defaults so developers can copy and get up and running quick.

```
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Run app - Development",
            "request": "launch",
            "type": "dart",
            "program": "lib/main_dev.dart"
        },
        {
            "name": "Run app - Production",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart"
        }
    ]
}
```

Create a `BuildConfig` class for holding configurations set at launch time.

```dart
// lib/build_config.dart
class BuildConfig {
  static late BuildConfig instance;
  final String apiUrl;
  final bool showFooDebugTools;

  BuildConfig({
    required this.apiUrl,
    this.showFooDebugTools = false,
  });
}
```

Create a `run_app.dart` file that has a `runApplication` function. Use this function inside all "mains".

```dart
// lib/run_app.dart

Future<void> runApplication() async {
  // This function is async because most applications have some kind of async setup, like initializing a local sqlite database, even if it's near instantanious.

  // Any customization that needs to happen can happen here, like setting up a network adapter. These documentations always use dio.
  ApiService.dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      baseUrl: BuildConfig.instance.apiUrl,
    ),
  );

  // The original run app
  runApp(const App());
}
```

Then in any "main" set the build config and call this function.
```dart
// lib/main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig.instance = BuildConfig(
    apiUrl: 'https://realproductionapi.com/api/',
  );
  await runApplication();
}
```

```dart
// lib/main_dev.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig.instance = BuildConfig(
    apiUrl: 'http://localhost:8000/api/',
    showFooDebugTools: true,
  );
  await runApplication();
}
```

Consider adding `lib/main_dev.dart` to `.gitignore` so developers can customize their own dev instances,
like pointing the app at their own localhost and port without causing git changes.
Create a `lib/main_dev.example.dart` with a recommended configuration for developing.

BuildConfig options are accessible anywhere in the application via `BuildConfig.instance`.

```dart
// lib/pages/home_page.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        if (BuildConfig.instance.showFooDebugTools)
          FooDebugTools(),
        Expanded(
          child: ListView(),
        ),
      ]
    ),
  );
}
```
