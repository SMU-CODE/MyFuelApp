import 'package:intl/intl.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

/// Utility class for parsing and formatting data
class Parser {
  // Default configurations
  static String defaultCurrency = 'YER';
  static String defaultDateFormat = 'yyyy-MM-dd';
  static String defaultNullString = 'N/A';
  static DateTime defaultNullDate = DateFormat(
    defaultDateFormat,
  ).parse("2000-02-18");

  /// Parse dynamic to DateTime with default format
  static DateTime parseDateTime(
    dynamic val, {
    String? format,
    String? variableName,
  }) {
    final dateFormat = format ?? defaultDateFormat;

    if (val == null) {
      _logError('parseDateTime', 'Value is null', variableName);
      return defaultNullDate;
    }

    if (val is DateTime) return val;

    if (val is String) {
      try {
        return DateFormat(dateFormat).parse(val);
      } catch (e) {
        _logWarning(
          'parseDateTime',
          "Failed with format '$dateFormat'",
          variableName,
        );
        return DateTime.tryParse(val) ?? defaultNullDate;
      }
    }

    _logError('parseDateTime', "Unsupported type", variableName);
    return defaultNullDate;
  }

  /// Format dynamic to date string with default format
  static String formatDateTime(
    dynamic val, {
    String? format,
    String? variableName,
  }) {
    final dateFormat = format ?? defaultDateFormat;

    if (val == null) {
      _logError('formatDateTime', 'Value is null', variableName);
      return defaultNullString;
    }

    final date =
        val is DateTime
            ? val
            : parseDateTime(
              val,
              format: dateFormat,
              variableName: variableName,
            );
    try {
      return DateFormat(dateFormat).format(date);
    } catch (e) {
      _logError('formatDateTime', "Format error", variableName);
      return defaultNullString;
    }
  }

  /// Format currency with support for Yemeni Rial (YER)
  static String formatCurrency(double value, {String? symbol, String? locale}) {
    final currencySymbol = symbol ?? defaultCurrency;

    if (currencySymbol == 'YER') {
      return NumberFormat.currency(
        symbol: 'ر.ي',
        decimalDigits: 2,
        locale: 'ar',
      ).format(value);
    }

    return NumberFormat.currency(symbol: currencySymbol).format(value);
  }

  /// Parse dynamic to int
  static int parseInt(dynamic val, {String? variableName}) {
    if (val == null) {
      _logError('parseInt', 'Value is null', variableName);
      return 0;
    }
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) {
      return int.tryParse(val) ?? double.tryParse(val)?.toInt() ?? 0;
    }

    _logError('parseInt', "Unsupported type", variableName);
    return 0;
  }

  /// Parse dynamic to double
  static double parseDouble(dynamic val, {String? variableName}) {
    if (val == null) {
      _logError('parseDouble', 'Value is null', variableName);
      return 0.0;
    }

    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;

    _logError('parseDouble', "Unsupported type", variableName);
    return 0.0;
  }

  /// Parse dynamic to string
  static String parseString(dynamic val, {String? variableName}) {
    if (val == null) {
      _logError('parseString', 'Value is null', variableName);
      return defaultNullString;
    }
    return val.toString().trim();
  }

  /// Parse dynamic to bool
  static bool parseBool(dynamic val, {String? variableName}) {
    if (val == null) {
      _logError('parseBool', 'Value is null', variableName);
      return false;
    }

    if (val is bool) return val;
    if (val is int) return val != 0;
    if (val is String) return val.toLowerCase() == 'true' || val == '1';

    _logError('parseBool', "Unsupported type", variableName);
    return false;
  }

  /// Parse dynamic to List< T >
  static List<T> parseList<T>(
    dynamic val,
    T Function(dynamic) parser, {
    String? variableName,
  }) {
    if (val == null) {
      _logError('parseList', 'Value is null', variableName);
      return [];
    }
    return val is List
        ? val.map((item) => parser(item)).whereType<T>().toList()
        : [];
  }

  /// Parse dynamic to Map< K,V >
  static Map<K, V> parseMap<K, V>(
    dynamic val,
    K Function(dynamic) keyParser,
    V Function(dynamic) valueParser, {
    String? variableName,
  }) {
    if (val == null || val is! Map) {
      _logError('parseMap', 'Invalid input', variableName);
      return {};
    }

    final result = <K, V>{};
    val.forEach((k, v) {
      final key = keyParser(k);
      final value = valueParser(v);
      if (key != null && value != null) result[key] = value;
    });
    return result;
  }

  /// Parse with default fallback
  static T parseWithDefault<T>(
    dynamic val,
    T Function(dynamic) parser,
    T defaultValue, {
    String? variableName,
  }) {
    try {
      return parser(val) ?? defaultValue;
    } catch (e) {
      _logError('parseWithDefault', "Parsing error", variableName);
      return defaultValue;
    }
  }

  // Private error logger
  static void _logError(String fn, String msg, String? varName) {
    MuLogger.error('ERROR in $fn${varName != null ? " ($varName)" : ""}: $msg');
  }

  // Private warning logger
  static void _logWarning(String fn, String msg, String? varName) {
    MuLogger.warning(
      'WARNING in $fn${varName != null ? " ($varName)" : ""}: $msg',
    );
  }
}
