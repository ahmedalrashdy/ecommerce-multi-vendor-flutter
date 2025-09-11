import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';

import '../enums/enums.dart';

class SecureStorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  Future<void> write({
    required String key,
    required String value,
  }) async {
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      throw AppException.fromData(
          'Failed to write data for key: $key, error:${e.toString()}',
          AppExceptionType.cacheException);
    }
  }

  Future<String?> read({
    required String key,
  }) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      throw AppException.fromData(
          'Failed to read data for key: $key, error:${e.toString()}',
          AppExceptionType.cacheException);
    }
  }

  Future<void> delete({
    required String key,
  }) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      throw AppException.fromData(
          'Failed to delete data for key: $key, error:${e.toString()}',
          AppExceptionType.cacheException);
    }

    Future<void> deleteAll() async {
      try {
        await storage.deleteAll();
      } catch (e) {
        throw AppException.fromData(
            'Failed to delete all data , error:${e.toString()}',
            AppExceptionType.cacheException);
      }
    }

    Future<bool> containsKey({
      required String key,
    }) async {
      try {
        return await storage.containsKey(key: key);
      } catch (e) {
        throw AppException.fromData(
            'Failed to search if key:($key) exists or not, error:${e.toString()}',
            AppExceptionType.cacheException);
      }
    }

    Future<Map<String, String>> readAll() async {
      try {
        return await storage.readAll();
      } catch (e) {
        throw AppException.fromData(
            'Failed to read all data , error:${e.toString()}',
            AppExceptionType.cacheException);
      }
    }
  }
}
