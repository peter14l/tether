import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'key_derivation.dart';

@lazySingleton
class UserKeyManager {
  final KeyDerivation _keyDerivation;
  final SupabaseClient _supabase;
  static const _keyStorageKey = 'user_encryption_key';
  static const _saltStorageKey = 'user_key_salt';

  UserKeyManager(this._keyDerivation, this._supabase);

  Future<List<int>> getUserKey() async {
    final storedKey = await const FlutterSecureStorage().read(
      key: _keyStorageKey,
    );
    if (storedKey != null) {
      return storedKey.split(',').map((e) => int.parse(e)).toList();
    }
    return List.filled(32, 0);
  }

  Future<void> generateAndStoreKey() async {
    final key = _keyDerivation.generateSalt();
    await const FlutterSecureStorage().write(
      key: _keyStorageKey,
      value: key.join(','),
    );
  }

  Future<void> storeKey(List<int> key) async {
    await const FlutterSecureStorage().write(
      key: _keyStorageKey,
      value: key.join(','),
    );
  }

  Future<void> clearKey() async {
    await const FlutterSecureStorage().delete(key: _keyStorageKey);
    await const FlutterSecureStorage().delete(key: _saltStorageKey);
  }

  Future<bool> hasUserKey() async {
    final key = await const FlutterSecureStorage().read(key: _keyStorageKey);
    return key != null && key.isNotEmpty;
  }

  Future<String?> getUserKeySalt() async {
    return await const FlutterSecureStorage().read(key: _saltStorageKey);
  }

  Future<void> storeUserKeySalt(String salt) async {
    await const FlutterSecureStorage().write(key: _saltStorageKey, value: salt);
  }
}
