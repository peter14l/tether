import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../../../core/utils/user_key_manager.dart';
import '../../domain/entities/gallery_item.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../models/gallery_item_model.dart';

@LazySingleton(as: IGalleryRepository)
class SupabaseGalleryRepository implements IGalleryRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;
  final UserKeyManager _keyManager;

  SupabaseGalleryRepository(
    this._client,
    this._encryptionService,
    this._keyManager,
  );

  @override
  Future<Either<Failure, List<GalleryItemEntity>>> getGalleryItems(
    String circleId,
  ) async {
    try {
      final response = await _client
          .from('private_gallery')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final userKey = await _keyManager.getUserKey();
      final List<GalleryItemEntity> items = [];
      for (final json in (response as List)) {
        String? decryptedCaption;
        if (json['caption'] != null) {
          decryptedCaption = await _encryptionService.decrypt(
            json['caption'] as String,
            userKey,
          );
        }
        items.add(
          GalleryItemModel.fromJson(json).copyWith(caption: decryptedCaption),
        );
      }

      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadGalleryItem(
    String circleId,
    File file,
    String? caption,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'private-gallery/$circleId/$fileName';

      await _client.storage.from('private-gallery').upload(storagePath, file);

      String? encryptedCaption;
      if (caption != null) {
        final userKey = await _keyManager.getUserKey();
        encryptedCaption = await _encryptionService.encrypt(caption, userKey);
      }

      final model = GalleryItemModel(
        id: '',
        circleId: circleId,
        uploadedBy: userId,
        storagePath: storagePath,
        caption: encryptedCaption,
        createdAt: DateTime.now(),
      );

      await _client.from('private_gallery').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
