import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tether/features/messaging/data/repositories/supabase_messaging_repository.dart';
import 'package:tether/features/messaging/domain/entities/message_entity.dart';
import 'package:tether/core/security/e2ee_service.dart';
import 'package:tether/core/network/r2_storage_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockE2EEService extends Mock implements IE2EEService {}
class MockR2StorageService extends Mock implements R2StorageService {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<Map<String, dynamic>?> {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder<Map<String, dynamic>> {}
class MockPostgrestFilterBuilderList extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  late SupabaseMessagingRepository repository;
  late MockSupabaseClient mockSupabase;
  late MockE2EEService mockE2EE;
  late MockR2StorageService mockR2;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockE2EE = MockE2EEService();
    mockR2 = MockR2StorageService();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('user-123');

    repository = SupabaseMessagingRepository(mockSupabase, mockE2EE, mockR2);
  });

  group('SupabaseMessagingRepository', () {
    test('sendMessage should encrypt text and insert message', () async {
      // Arrange
      final roomId = 'room-456';
      final message = MessageEntity(
        id: '',
        roomId: roomId,
        senderId: 'user-123',
        messageType: 'text',
        encryptedText: 'Hello World',
        createdAt: DateTime.now(),
      );

      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final mockTransformBuilder = MockPostgrestTransformBuilder();
      final mockFilterBuilderList = MockPostgrestFilterBuilderList();

      // Mock _getOtherParticipant
      when(() => mockSupabase.from('participants')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.select('user_id')).thenReturn(mockFilterBuilder as dynamic);
      when(() => mockFilterBuilder.eq('room_id', roomId)).thenReturn(mockFilterBuilder as dynamic);
      when(() => mockFilterBuilder.neq('user_id', 'user-123')).thenReturn(mockFilterBuilder as dynamic);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) async => {'user_id': 'user-789'});

      // Mock encryption
      when(() => mockE2EE.encryptMessage('Hello World', 'user-789'))
          .thenAnswer((_) async => jsonEncode({'e2ee': true, 'ciphertext': 'xyz'}));

      // Mock insertion
      when(() => mockSupabase.from('messages')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.insert(any())).thenReturn(mockFilterBuilderList as dynamic);
      when(() => (mockFilterBuilderList as dynamic).select()).thenReturn(mockTransformBuilder);
      when(() => mockTransformBuilder.single()).thenAnswer((_) async => {
        'id': 'msg-001',
        'room_id': roomId,
        'sender_id': 'user-123',
        'message_type': 'text',
        'encrypted_text': 'xyz',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Act
      final result = await repository.sendMessage(message);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockE2EE.encryptMessage('Hello World', 'user-789')).called(1);
    });
  });
}
