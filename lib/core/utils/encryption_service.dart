import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

/// Service for E2E encryption using AES-256-GCM.
@lazySingleton
class EncryptionService {
  final _algorithm = AesGcm.with256bits();

  /// Encrypts [data] using [masterKey].
  /// Returns a JSON string containing the base64 encoded ciphertext, nonce, and tag.
  Future<String> encrypt(String data, List<int> masterKey) async {
    final secretKey = SecretKey(masterKey);
    final clearText = utf8.encode(data);
    
    final secretBox = await _algorithm.encrypt(
      clearText,
      secretKey: secretKey,
    );

    final result = {
      'ciphertext': base64Encode(secretBox.cipherText),
      'nonce': base64Encode(secretBox.nonce),
      'tag': base64Encode(secretBox.mac.bytes),
    };

    return jsonEncode(result);
  }

  /// Decrypts [encryptedDataJson] using [masterKey].
  /// Expects a JSON string with base64 encoded ciphertext, nonce, and tag.
  Future<String> decrypt(String encryptedDataJson, List<int> masterKey) async {
    final secretKey = SecretKey(masterKey);
    final data = jsonDecode(encryptedDataJson) as Map<String, dynamic>;

    final ciphertext = base64Decode(data['ciphertext'] as String);
    final nonce = base64Decode(data['nonce'] as String);
    final tag = base64Decode(data['tag'] as String);

    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: Mac(tag),
    );

    final clearText = await _algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(clearText);
  }

  /// Generates a random 256-bit (32-byte) Master Key.
  Future<List<int>> generateMasterKey() async {
    final secretKey = await _algorithm.newSecretKey();
    return await secretKey.extractBytes();
  }
}
