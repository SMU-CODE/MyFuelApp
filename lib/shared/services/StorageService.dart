import 'package:get_storage/get_storage.dart';
import 'package:my_fuel/shared/constant/AppKeys.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';

/// A singleton-like class that manages local persistent storage using GetStorage.
class StorageService {
  static final GetStorage _storage = GetStorage();
  static bool _isInitialized = false;

  /// Initializes the storage if not already initialized.
  static Future<void> init() async {
    if (!_isInitialized) {
      await _storage.initStorage;
      _isInitialized = true;
    }
  }

  /// Ensures that the storage is initialized before performing any operation.
  static Future<void> _ensureInit() async {
    if (!_isInitialized) {
      await init();
    }
  }

  /// Writes a value to storage using the given key.
  static Future<void> write(String key, dynamic value) async {
    await _ensureInit();
    try {
      await _storage.write(key, value);
    } catch (e, st) {
      MuLogger.exception("Failed to write key: '$key'", st);
      rethrow;
    }
  }

  /// Reads a value of type [T] from storage using the given key.
  static T? read<T>(String key) {
    assert(_isInitialized, 'StorageService must be initialized first');
    try {
      return _storage.read<T>(key);
    } catch (e, st) {
      MuLogger.exception("Failed to read key: '$key'", st);
      return null;
    }
  }

  /// Removes the value associated with the given key.
  static Future<void> remove(String key) async {
    await _ensureInit();
    try {
      await _storage.remove(key);
    } catch (e, st) {
      MuLogger.exception("Failed to remove key: '$key'", st);
    }
  }

  /// Checks if the user is logged in by validating essential user keys.
  static bool checkLoginStatus() {
    try {
      final id = read<int>(AppKeys.userId);
      MuLogger.notice("Login status check Start checkLoginStatus()  ");
      return id != null &&
          id != 0 &&
          read<String>(AppKeys.userName) != null &&
          read<String>(AppKeys.phoneNumber) != null &&
          read<String>(AppKeys.authToken) != null;
    } catch (e, st) {
      MuLogger.exception("Login status check failed", st);
      return false;
    }
  }

  /// Checks if a specific key exists in the storage.
  static bool hasKey(String key) {
    assert(_isInitialized, 'StorageService must be initialized first');
    return _storage.hasData(key);
  }

  /// Clears all stored data.
  static Future<void> clearAll() async {
    await _ensureInit();
    try {
      await _storage.erase();
    } catch (e, st) {
      MuLogger.exception("Failed to clear storage", st);
    }
  }

  /// Reads a value or returns the given default if not found or an error occurs.
  static T readOrDefault<T>(String key, T defaultValue) {
    try {
      return read<T>(key) ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static Future<T?> readAsync<T>(String key) async {
    await _ensureInit(); // يتأكد من التهيئة
    try {
      return _storage.read<T>(key);
    } catch (e, st) {
      MuLogger.exception("Failed to read key '$key'", st);
      return null;
    }
  }
}
