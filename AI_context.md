# Instructions

This document provides guidance for AI to assist with application development.

## Project Overview

The app follows a clean architecture pattern with services, managers, and UI components.

## Code Structure

- **lib/**: Main source code
  - **main.dart**: Production entry point
  - **main_dev.dart**: Development entry point
  - **app.dart**: Main application widget
  - **router.dart**: Application routing
  - **services/**: API and other services
  - **managers/**: Business logic
  - **models/**: Data models
  - **pages/**: UI screens
  - **widgets/**: Reusable UI components
  - **themes/**: UI themes and styles
  - **utils/**: Utility functions
  - **mixins/**: Reusable code patterns

## Coding Standards

1. **Architecture**:
   - Use custom Provider pattern for dependency injection (not Flutter's Provider package, but a home-grown solution that doesn't rely on widget tree context)
   - Follow separation of concerns (UI, business logic, data)
   - Use GoRouter for navigation

2. **Naming Conventions**:
   - Use community standards for variable, class, funcion, method, etc. names applicable to the coding language.

3. **Code Formatting**:
   - 80 character line limit
   - Use 2-space indentation
   - Follow Dart's style guide

4. **Documentation**:
   - Document public APIs
   - Add code comments where logic is complex
   - Use /// for documentation comments

5. **Testing**:
   - Write unit tests for business logic
   - Use test_utils.dart for common test setup

## Best Practices

### State Management
- Use custom Provider solution for global state management (home-grown implementation, not the Flutter Provider package)
- Always dispose listeners and controllers

### Error Handling
- Use try/catch blocks for API calls
- Log errors with proper context using the Logging mixin
- Display user-friendly error messages

### Performance
- Minimize UI rebuilds
- Use const constructors when possible

### API Calls
- Use services that inherit from ApiService for network requests
- Handle loading and error states

## Common Patterns

### Handling lists

- Always use list comprehension where possible over using list methods.
- Good: `final projects = [for (final m in responseMaps) Project.fromMap(m)]`
- Bad: `final projects = responseMaps.map((m) => Project.fromMap(m)).toList()`

### Model Classes
```dart
class MyModel with CopyWith<MyModel> {
  final String id;
  final String name;
  final int? value;

  const MyModel._copyWith(
    required this.id,
    required this.name,
    this.value,
  );

  const MyModel.mock({
    required this.id,
    required this.name,
    this.value,
  });

  MyModel fromMap(Map m)
    : id = m['id'],
      name = m['name'],
      value = m['value'];

  Map toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }

  @override
  MyModel copyWith({
    String? id,
    String? name,
    AssignableValue<int?> value = const MissingValue(),
  }) {
    return MyModel._copyWith(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value is NullableValue<int?> ? value.value : this.value,
    );
  }
}
```

### Service Classes
```dart
class MyService with Logging {
  Future<List<MyModel>> getItems() async {
    try {
      final response = await ApiService.dio.get('/items');
      return [
        for (final item in response.data as List)
          MyModel.fromJson(item)
      ];
    } catch (e) {
      devLog('Error fetching items: $e', name: runtimeType.toString());
      rethrow;
    }
  }
}
```

### Page Structure
```dart
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with Logging {
  final _myService = Provider.get<MyService>();
  late ThemeData _theme;
  late FirebaseLocalizations _localizations;
  bool _loading = false;
  String? _error;
  List<MyModel> _items = [];

  // Lifecycle hooks first, like initState and dispose
  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    // Localizations come from a custom inherited widget
    _localizations = AppLocalizations.of(context);
    _theme = Theme.of(context);
    if (_loading || _error != null) {
      return Scaffold(
        appBar: _appBar(),
        body: Center(
          child: Column(
            children: [
              if (_loading) const CircularProgressIndicator(),
              if (_error != null) _errorText(),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: _appBar(),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_items[index].name),
        ),
      ),
    );
  }

  // Widget methods go after the build
  AppBar _appBar() {
    return AppBar(
      title: Text(_localizations.get('my-page|title'))
    );
  }

  Widget _errorText() {
    return Text(
      _error!,
      style: _theme.textTheme.bodyMedium?.copyWith(
        color: _theme.colorScheme.error,
      ),
    );
  }

  // All other methods go after widget methods
  Future<void> _getItems() async {
    if (mounted) {
      // Never nest state variable assignment inside setState
      _loading = true;
      _error = null;
      setState(() {});
    }
    try {
      final items = await _myService.getItems();
      if (mounted) {
        _items = items;
      }
    } on DioException catch (e) {
      log('DioException getting items', error: e);
      _error = _localizations.get('my-page|error|get-items');
    } catch (e, stackTrace) {
      _error = _localizations.get('my-page|error|get-items');
      log('Error getting items', error: e, stackTrace: stackTrace);
    }
    finally {
      if (mounted) {
        _loading = false;
        setState(() {});
      }
    }
  }
}
```

## Environment Configuration

- Development environment uses `main_dev.dart`
- Production environment uses `main.dart`
- Environment settings are configured in `build_config.dart`

## Routing

- Routes are defined in `router.dart`
- Use the `AppRoute` enum for route names
- Route parameters should be properly typed

## Adding New Features

1. Create necessary models
2. Implement service methods
3. Add business logic in managers if needed
4. Create UI components
5. Update routing if required