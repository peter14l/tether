import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tether/core/network/r2_storage_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
  late R2StorageService r2StorageService;
  late MockSupabaseClient mockSupabase;
  late MockFunctionsClient mockFunctions;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockFunctions = MockFunctionsClient();
    when(() => mockSupabase.functions).thenReturn(mockFunctions);
    r2StorageService = R2StorageService(mockSupabase);
  });

  group('R2StorageService Encryption', () {
    test('should encrypt and decrypt data correctly', () async {
      // Arrange
      final originalText = 'Hello Tether E2EE';
      final tempFile = File('temp_test_file.txt');
      await tempFile.writeAsString(originalText);

      // Act - Encrypt
      final encryptionResult = await r2StorageService.encryptFile(tempFile);
      
      // Act - Decrypt
      final decryptedBytes = await r2StorageService.decryptBytes(
        encryptionResult.encryptedBytes, 
        encryptionResult.mediaKey
      );
      final decryptedText = String.fromCharCodes(decryptedBytes);

      // Assert
      expect(decryptedText, originalText);
      expect(encryptionResult.encryptedBytes, isNot(Uint8List.fromList(originalText.codeUnits)));
      
      // Cleanup
      await tempFile.delete();
    });

    test('should throw error if decryption key is wrong', () async {
      final originalText = 'Secret data';
      final tempFile = File('temp_test_file_2.txt');
      await tempFile.writeAsString(originalText);

      final encryptionResult = await r2StorageService.encryptFile(tempFile);
      final wrongKey = List<int>.filled(32, 0);

      expect(
        () => r2StorageService.decryptBytes(encryptionResult.encryptedBytes, wrongKey),
        throwsException,
      );

      await tempFile.delete();
    });
  });
}
