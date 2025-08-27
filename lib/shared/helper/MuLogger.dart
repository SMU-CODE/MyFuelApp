import 'package:flutter/foundation.dart';

enum LogType {
  log,
  info,
  warning,
  error,
  success,
  critical,
  debugTest,
  exception,
  todo,
  important,
  notice,
  custom,
}

enum LogLevel { none, error, warning, info, verbose }

class MuLogger {
  // ANSI colors
  static const _reset = '\x1B[0m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _blue = '\x1B[34m';
  static const _magenta = '\x1B[35m';
  static const _cyan = '\x1B[36m';
  static const _white = '\x1B[37m';
  static const _orange = '\x1B[38;5;208m';

  static final _logColors = {
    LogType.log: _white,
    LogType.info: _cyan,
    LogType.warning: _orange,
    LogType.error: _red,
    LogType.success: _green,
    LogType.critical: _magenta,
    LogType.debugTest: _blue,
    LogType.exception: _red,
    LogType.todo: _yellow,
    LogType.important: _magenta,
    LogType.notice: _blue,
    LogType.custom: _white,
  };

  static LogLevel logLevel = kDebugMode ? LogLevel.verbose : LogLevel.none;

  static bool _shouldLog(LogType type) {
    switch (logLevel) {
      case LogLevel.none:
        return false;
      case LogLevel.error:
        return [
          LogType.error,
          LogType.exception,
          LogType.critical,
        ].contains(type);
      case LogLevel.warning:
        return [
          LogType.warning,
          LogType.error,
          LogType.exception,
          LogType.critical,
        ].contains(type);
      case LogLevel.info:
        return ![
          LogType.log,
          LogType.debugTest,
          LogType.todo,
          LogType.custom,
        ].contains(type);
      case LogLevel.verbose:
        return true;
    }
  }

  static void _log(LogType type, String message, [String? label]) {
    if (!_shouldLog(type)) return;

    final color = _logColors[type] ?? _white;
    final header =
        '${'═' * 15} <${label ?? type.name.toUpperCase()}> ${'═' * 15}';
    final time = DateTime.now().toLocal().toString().substring(11, 19);

    debugPrint('$color$header$_reset');
    debugPrint('$color     Time: $time$_reset');
    debugPrint('$color  Message: $message$_reset');
    debugPrint('$color${'═' * header.length}$_reset');
  }

  // Public logging methods
  static void log(String message) => _log(LogType.log, message);
  static void info(String message) => _log(LogType.info, message);
  static void warning(String message) => _log(LogType.warning, message);
  static void error(String message) => _log(LogType.error, message);
  static void success(String message) => _log(LogType.success, message);
  static void critical(String message) => _log(LogType.critical, message);
  static void debug(String message) => _log(LogType.debugTest, message);
  //static void exception(Object error, [StackTrace? stack]) => _log(LogType.exception, '$error\n${stack ?? StackTrace.current}');
  static void todo(String message) => _log(LogType.todo, message);
  static void important(String message) => _log(LogType.important, message);
  static void notice(String message) => _log(LogType.notice, message);
  void custom(String label, String message) =>
      _log(LogType.custom, message, label);
  static void exception(Object error, [StackTrace? stackTrace, String? msg]) {
    _log(
      LogType.exception,
      '....MyMessage:$msg......\n wih Error: $error\nStackTrace: ${stackTrace ?? StackTrace.current},,,e.message:${error.toString()}',
    );
  }
}
