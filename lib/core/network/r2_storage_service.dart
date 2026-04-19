import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class R2StorageService {
  final SupabaseClient _supabase;
  final AesGcm _aesGcm = AesGcm.with256bits();

  R2StorageService(this._supabase);

  /// Encrypts a file and returns the encrypted bytes and the media key.
  Future<({Uint8List encryptedBytes, List<int> mediaKey})> encryptFile(File file) async {
    final bytes = await file.readAsBytes();
    final secretKey = await _aesGcm.newSecretKey();
    final mediaKey = await secretKey.extractBytes();
    
    final secretBox = await _aesGcm.encrypt(
      bytes,
      secretKey: secretKey,
    );

    // Combine nonce + ciphertext + mac tag for storage
    // Format: [nonce_length (1 byte)][nonce][tag_length (1 byte)][tag][ciphertext]
    final nonce = secretBox.nonce;
    final tag = secretBox.mac.bytes;
    final ciphertext = secretBox.cipherText;

    final builder = BytesBuilder();
    builder.addByte(nonce.length);
    builder.add(nonce);
    builder.addByte(tag.length);
    builder.add(tag);
    builder.add(ciphertext);

    return (encryptedBytes: builder.toBytes(), mediaKey: mediaKey);
  }

  /// Decrypts bytes using the provided media key.
  Future<Uint8List> decryptBytes(Uint8List encryptedData, List<int> mediaKey) async {
    final secretKey = SecretKey(mediaKey);
    
    int offset = 0;
    final nonceLength = encryptedData[offset++];
    final nonce = encryptedData.sublist(offset, offset + nonceLength);
    offset += nonceLength;
    
    final tagLength = encryptedData[offset++];
    final tag = encryptedData.sublist(offset, offset + tagLength);
    offset += tagLength;
    
    final ciphertext = encryptedData.sublist(offset);

    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: Mac(tag),
    );

    final clearText = await _aesGcm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return Uint8List.fromList(clearText);
  }

  /// Gets a presigned URL from Supabase Edge Function and uploads the file.
  Future<String> uploadEncryptedFile(Uint8List encryptedBytes, String fileName) async {
    // 1. Get presigned URL
    final response = await _supabase.functions.invoke('get-r2-presigned-url', body: {
      'file_name': fileName,
      'content_type': 'application/octet-stream',
      'method': 'PUT',
    });

    if (response.status != 200) {
      throw Exception('Failed to get presigned URL: ${response.data}');
    }

    final presignedUrl = response.data['url'] as String;
    final objectKey = response.data['key'] as String;

    // 2. Upload to R2
    final uploadResponse = await http.put(
      Uri.parse(presignedUrl),
      body: encryptedBytes,
      headers: {'Content-Type': 'application/octet-stream'},
    );

    if (uploadResponse.statusCode != 200) {
      throw Exception('Failed to upload to R2: ${uploadResponse.body}');
    }

    return objectKey;
  }

  /// Downloads and decrypts a file from R2.
  Future<Uint8List> downloadAndDecrypt(String objectKey, List<int> mediaKey) async {
    // 1. Get presigned URL for GET
    final response = await _supabase.functions.invoke('get-r2-presigned-url', body: {
      'file_name': objectKey,
      'method': 'GET',
    });

    if (response.status != 200) {
      throw Exception('Failed to get presigned URL for download');
    }

    final presignedUrl = response.data['url'] as String;

    // 2. Download from R2
    final downloadResponse = await http.get(Uri.parse(presignedUrl));

    if (downloadResponse.statusCode != 200) {
      throw Exception('Failed to download from R2');
    }

    // 3. Decrypt
    return await decryptBytes(downloadResponse.bodyBytes, mediaKey);
  }
}
