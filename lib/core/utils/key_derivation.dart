import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

/// Key derivation utilities using PBKDF2 with HMAC-SHA256.
@lazySingleton
class KeyDerivation {
  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000, // Reasonable number of iterations
    bits: 256, // 32 bytes for AES-256
  );

  /// Derives a 32-byte key from [pin] and [salt].
  Future<List<int>> deriveKeyFromPin(String pin, List<int> salt) async {
    final password = SecretKey(utf8.encode(pin));
    final derivedKey = await _pbkdf2.deriveKey(
      secretKey: password,
      nonce: salt,
    );
    return await derivedKey.extractBytes();
  }

  /// Generates a random 32-byte salt.
  List<int> generateSalt() {
    final random = Random.secure();
    final bytes = Uint8List(32);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes.toList();
  }
}
