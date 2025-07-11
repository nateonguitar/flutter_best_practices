class Provider {
  static bool _initialized = false;
  static final Map<Type, dynamic> _instances = {};
  static final Map<Type, dynamic Function()> _lazyInitializers = {};

  static void initialize({
    required Map<Type, dynamic Function()> instances,
    Map<Type, dynamic Function()> lazyInstances = const {},
    Map<Type, dynamic Function()> overrides = const {},
    Map<Type, dynamic Function()> lazyOverrides = const {},
  }) {
    // Apply overrides first (eagerly initialized)
    for (final MapEntry<Type, dynamic Function()> entry in overrides.entries) {
      _instances[entry.key] = entry.value();
    }

    // Register eager instances
    for (final initializer in instances.entries) {
      if (!_instances.containsKey(initializer.key)) {
        _instances[initializer.key] = initializer.value();
      }
    }

    // Register lazy overrides
    for (final initializer in lazyOverrides.entries) {
      if (!_instances.containsKey(initializer.key)) {
        // Store the initializer, not the instance
        _lazyInitializers[initializer.key] = initializer.value;
      }
    }

    // Register lazy initializers
    for (final initializer in lazyInstances.entries) {
      if (!_instances.containsKey(initializer.key) &&
          !_lazyInitializers.containsKey(initializer.key)) {
        // Store the initializer, not the instance
        _lazyInitializers[initializer.key] = initializer.value;
      }
    }

    _initialized = true;
  }

  /// Get a singleton that was registered. For example:
  ///
  /// ```dart
  /// final authService = Provider.get<AuthService>();
  /// ```
  static T get<T>() {
    if (!_initialized) {
      throw Error();
    }

    // Check if instance exists
    dynamic value = _instances[T];

    // If not, check if we have a lazy initializer for it
    if (value == null) {
      if (_lazyInitializers.containsKey(T)) {
        _instances[T] = _lazyInitializers[T]!();
        value = _instances[T];
      }
    }

    if (value == null) {
      throw Exception(
        'Instance not found, '
        'go register ${T.runtimeType} in provider_instances.dart',
      );
    }

    return value as T;
  }
}
