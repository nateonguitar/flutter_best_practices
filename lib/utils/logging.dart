import 'dart:async';
import 'dart:developer' as developer;

/// If possible, use the `with Logging` mixin instead of this.
void devLog(
  String message, {
  required String name,
  String? extraLogLabel,
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
  bool skipSendLog = false,
}) {
  if (extraLogLabel != null) {
    name += ' - $extraLogLabel';
  }
  developer.log(
    message,
    time: time,
    sequenceNumber: sequenceNumber,
    level: level,
    name: name,
    zone: zone,
    error: error,
    stackTrace: stackTrace,
  );
}

/// Use this mixin on all classes possible and avoid using `developer.log`.
/// Where this mixing is not possible, use the `devLog` function.
mixin Logging {
  String get loggerName => runtimeType.toString();

  void log(
    String message, {
    String? extraLogLabel,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String? name,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
    bool skipSendLog = false,
  }) {
    name ??= loggerName;
    if (extraLogLabel != null) {
      name += ' - $extraLogLabel';
    }
    developer.log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logWidgetMounted({
    String? extra,
  }) {
    // https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters
    // ANSI Legend:
    // 35 - magenta foreground
    // 2  - faint
    final List<String> parts = [
      '\x1B[35;2m',
      'Mounted',
      if (extra != null) ' - $extra',
      '\x1B[0m',
    ];
    developer.log(
      parts.join(),
      name: loggerName,
    );
  }
}
