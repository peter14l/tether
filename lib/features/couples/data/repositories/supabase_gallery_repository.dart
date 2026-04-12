import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../domain/entities/gallery_item.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../models/gallery_item_model.dart';

@LazySingleton(as: IGalleryRepository)
class SupabaseGalleryRepository implements IGalleryRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;

  static final List<int> _placeholderKey = List.filled(32, 3); // Different key for gallery

  SupabaseGalleryRepository(this._client, this._encryptionService);

  @override
  Future<Either<Failure, List<GalleryItemEntity>>> getGalleryItems(String circleId) async {
    try {
      final response = await _client
          .from('private_gallery')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final List<GalleryItemEntity> items = [];
      for (final json in (response as List)) {
        String? decryptedCaption;
        if (json['caption'] != null) {
          decryptedCaption = await _encryptionService.decrypt(json['caption'] as String, _placeholderKey);
        }
        final item = GalleryItemModel.fromJson(json);
        items.add(item.copyWithCaption(decryptedCaption));
      }
      
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadGalleryItem(String circleId, File file, String? caption) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'private-gallery/$circleId/$fileName';
      
      await _client.storage.from('private-gallery').upload(storagePath, file);

      String? encryptedCaption;
      if (caption != null) {
        encryptedCaption = await _encryptionService.encrypt(caption, _placeholderKey);
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

// Extension to allow copying with decrypted caption since entities are immutable
extension on GalleryItemEntity {
  GalleryItemEntity copyWithCaption(String? newCaption) {
    return GalleryItemEntity(
      id: this.id,
      circleId: circleId,
      uploadedBy: uploadedBy,
      storagePath: storagePath,
      caption: newCaption,
      createdAt: createdAt,
    );
  }
}
