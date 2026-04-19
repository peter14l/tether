import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/encryption_service.dart';
import '../../core/utils/user_key_manager.dart';

abstract class IE2EEService {
  Future<void> initializeKeys();
  Future<String> encryptMessage(String plaintext, String otherUserId);
  Future<String> decryptMessage(String ciphertextJson, String otherUserId);
}

@LazySingleton(as: IE2EEService)
class E2EEService implements IE2EEService {
  final SupabaseClient _supabase;
  final UserKeyManager _keyManager;
  final EncryptionService _encryptionService;

  SimpleKeyPair? _myKeyPair;
  final Map<String, SecretKey> _sharedSecretsCache = {};
  final X25519 _x25519 = X25519();
  final AesGcm _aesGcm = AesGcm.with256bits();

  E2EEService(this._supabase, this._keyManager, this._encryptionService);

  @override
  Future<void> initializeKeys() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final masterKey = await _keyManager.getUserKey();
      
      final response = await _supabase
          .from('user_keypairs')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // Generate new keypair
        final keyPair = await _x25519.newKeyPair();
        _myKeyPair = keyPair as SimpleKeyPair;

        final pubKeyBytes = await keyPair.extractPublicKey();
        final privKeyBytes = await keyPair.extractPrivateKeyBytes();

        final pubKeyBase64 = base64Encode(pubKeyBytes.bytes);
        final privKeyBase64 = base64Encode(privKeyBytes);

        // Encrypt private key with master key
        final encryptedPrivKey = await _encryptionService.encrypt(privKeyBase64, masterKey);

        await _supabase.from('user_keypairs').insert({
          'user_id': userId,
          'public_key': pubKeyBase64,
          'encrypted_private_key': encryptedPrivKey,
        });
        debugPrint('E2EE: Generated and saved new keypair for user.');
      } else {
        // Load existing keypair
        final pubKeyBase64 = response['public_key'] as String;
        final encryptedPrivKey = response['encrypted_private_key'] as String;

        final privKeyBase64 = await _encryptionService.decrypt(encryptedPrivKey, masterKey);
        final privKeyBytes = base64Decode(privKeyBase64);
        final pubKeyBytes = base64Decode(pubKeyBase64);

        _myKeyPair = SimpleKeyPairData(
          privKeyBytes,
          publicKey: SimplePublicKey(pubKeyBytes, type: KeyPairType.x25519),
          type: KeyPairType.x25519,
        );
        debugPrint('E2EE: Loaded existing keypair.');
      }
    } catch (e) {
      debugPrint('E2EE Initialization Error: $e');
    }
  }

  Future<SecretKey> _getSharedSecret(String otherUserId) async {
    if (_sharedSecretsCache.containsKey(otherUserId)) {
      return _sharedSecretsCache[otherUserId]!;
    }

    if (_myKeyPair == null) {
      throw Exception('E2EE not initialized. KeyPair is missing.');
    }

    final response = await _supabase
        .from('user_keypairs')
        .select('public_key')
        .eq('user_id', otherUserId)
        .maybeSingle();

    if (response == null) {
      throw Exception('Other user has not initialized E2EE yet.');
    }

    final pubKeyBase64 = response['public_key'] as String;
    final pubKeyBytes = base64Decode(pubKeyBase64);
    final remotePublicKey = SimplePublicKey(pubKeyBytes, type: KeyPairType.x25519);

    final sharedSecret = await _x25519.sharedSecretKey(
      keyPair: _myKeyPair!,
      remotePublicKey: remotePublicKey,
    );

    _sharedSecretsCache[otherUserId] = sharedSecret;
    return sharedSecret;
  }

  @override
  Future<String> encryptMessage(String plaintext, String otherUserId) async {
    try {
      final sharedSecret = await _getSharedSecret(otherUserId);
      final clearTextBytes = utf8.encode(plaintext);
      final secretBox = await _aesGcm.encrypt(clearTextBytes, secretKey: sharedSecret);

      final result = {
        'e2ee': true,
        'ciphertext': base64Encode(secretBox.cipherText),
        'nonce': base64Encode(secretBox.nonce),
        'tag': base64Encode(secretBox.mac.bytes),
      };
      return jsonEncode(result);
    } catch (e) {
      debugPrint('E2EE Encrypt Error: $e');
      // Fallback to plaintext if encryption fails or other user has no keys
      return plaintext;
    }
  }

  @override
  Future<String> decryptMessage(String ciphertextJson, String otherUserId) async {
    try {
      final data = jsonDecode(ciphertextJson);
      if (data is! Map || data['e2ee'] != true) {
        return ciphertextJson; // Not encrypted
      }

      final sharedSecret = await _getSharedSecret(otherUserId);
      final ciphertext = base64Decode(data['ciphertext'] as String);
      final nonce = base64Decode(data['nonce'] as String);
      final tag = base64Decode(data['tag'] as String);

      final secretBox = SecretBox(
        ciphertext,
        nonce: nonce,
        mac: Mac(tag),
      );

      final clearTextBytes = await _aesGcm.decrypt(secretBox, secretKey: sharedSecret);
      return utf8.decode(clearTextBytes);
    } catch (e) {
      debugPrint('E2EE Decrypt Error: $e');
      return '[Encrypted Message]';
    }
  }
}
