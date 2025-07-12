# State Management and Dependency Injection

(Read [Main and Launching the App](./main_and_launching_the_app.md) before this)

The Flutter framework has great state management tools built in, no need to pull in a state management package (like Riverpod). Those packages are very good, but often overkill.

With a little boiler plate, this pattern will replace almost all reasons to use a state management package. On top of that, this pattern helps developers to understand how Dart and Flutter work. When it is appropriate to completely use or weave in another state management package, developers who know the basics can better utilize those packages (similar to how knowing SQL can help to more effectively use a database ORM).

This pattern seamlessly integrates with other state management packages, so if Riverpod is the right choice for a section of the app, go ahead and use it. But consider using the built-in state management and this pattern before using those systems. When something goes wrong, those other packages cang get very difficult to debug.

# Dependency Injection

Copy the file [lib/provider.dart](../lib/provider.dart) into a new Flutter application. This 75ish line file serves as the dependency enjection tool used across the entire application, and almost completely replaces the need for other state management tools.

Another benefit to this pattern, unlike some state management tools, this pattern does not require a `context` or `ref`.

 Make a `lib/provider_instances.dart` following the pattern in [lib/provider_instances.dart](../lib/provider_instances.dart). This is where singleton instances can be registered in the provider system.

```dart
Map<Type, dynamic Function()> providerInstances = {
  // Example API service
  ProductService: () => ProductService(),
};

Map<Type, dynamic Function()> lazyProviderInstances = {};
```

Modify the custom `runApplication()` function.

```dart
// lib/runApp.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/app.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/provider_instances.dart';
import 'package:flutter_best_practices/services/api_service.dart';

Future<void> runApplication({
  Map<Type, dynamic Function()> providerOverrides = const {},
  Map<Type, dynamic Function()> lazyProviderInstances = const {},
}) async {
  ApiService.dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      baseUrl: BuildConfig.instance.apiUrl,
    ),
  );
  Provider.initialize(
    instances: providerInstances,
    lazyInstances: lazyProviderInstances,
    overrides: providerOverrides,
    lazyOverrides: lazyProviderInstances,
  );
  runApp(const App());
}
```

Now injected services can be overridden with mock services in `main_dev.dart` or in a Flutter test.

```dart
// lib/main_dev.dart
// ignore_for_file: unused_import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String apiUrl;
  if (Platform.isAndroid) {
    // Android emulator localhost of the host computer magic ip = 10.0.2.2
    apiUrl = 'http://10.0.2.2:5104/api/';
  } else {
    apiUrl = 'http://localhost:5104/api/';
  }
  BuildConfig.instance = BuildConfig(
    apiUrl: apiUrl,
  );
  MockData.generate(
  );
  await runApplication(
    providerOverrides: {
      // MockProductionService mocks network calls,
      // useful in automated tests or if another team is building the api and it's down at the moment.
      ProductService: () => MockProductService(),
    },
  );
}
```

Now these instances are accessible anywhere in the app.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productService = Provider.get<ProductService>();

  bool _loadingProducts = false;
  List<Product> _products = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    if (_loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }
    if (_products.isEmpty) {
      return const Center(
        child: Text('No products available.'),
      );
    }
    return Column(
      children: [
        for (final product in _products)
          Text(product.name),
      ],
    );
  }

  Future<void> _getProducts() async {
    _loadingProducts = true;
    setState(() {});
    try {
      _products = await _productService.getAll();
    } on DioException {
      _error = 'Network error';
    } catch (e, stackTrace) {
      _error = 'Something went wrong getting products';
    } finally {
      _loadingProducts = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
```

# Subscribing to Events

Flutter's built in `ChangeNotifier` class works very well, it lets you watch for changes. For instance, if you had a synchronizer running in the background that was keeping a sqlite database up to date with an api, you could have a sync-status indicator widget showing if you are syncing right now or not.

But it has a flaw when integrating it into widget building, it is not aware of when Flutter is in the middle of building a frame.

If you subscribe to a `ChangeNotifier` and just call `setState(() {})`, you risk the "setState() or markNeedsBuild() called during build" error showing in the terminal, and missing some builds.

This example repo provides a `DeferredChangeNotifier` class that will only update its listeners between frames. Copy it from [here](../lib/utils/deferred_change_notifier.dart).

### Example synchronizer and page watching for changes:

```dart
enum SyncStep {
  idle,
  syncing,
}

class Synchronizer extends DeferredChangeNotifier {
  SyncStep _syncStep = SyncStep.idle;
  SyncStep get syncStep => _syncStep;

  // Called on a timer in the background, launched from main.dart or after a user logs in.
  Future<void> syncUp() {
    try {
      _syncStep = SyncStep.syncing;
      notifyListeners();
      await someSyncMethod();
    }
    catch (e) {
      // log an error message, or some business logic
    }
    finally {
      _syncStep = SyncStep.idle;
      notifyListeners();
    }
  }
}
```

Provide the synchronizer in the provider system

```dart
Map<Type, dynamic Function()> providerInstances = {
  // Utilities
  Synchronizer: () => Synchronizer(),
  ThemeManager: () => ThemeManager(),

  // Api services
  AuthService: () => AuthService(),
  ProductService: () => ProductService(),
};
```

Listen to changes
```dart
class SyncStatusIndicator extends StatefulWidget {
  const SyncStatusIndicator({super.key});

  @override
  State<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends State<SyncStatusIndicator> with Logging {
  late ThemeData _theme;
  final _synchronizer = Provider.get<Synchronizer>();


  @override
  initState() {
    _synchronizer.addListener(_onSynchronizerChanged);
  }

  void _onSynchronizerChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _synchronizer.removeListener(_onSynchronizerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      switch(_synchronizer.syncStep) {
        SyncStep.idle -> Icons.sync,
        SyncStep.syncing -> Icons.refresh,
      }
    );
  }
}
```