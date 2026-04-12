import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/heritage_item.dart';
import '../../domain/repositories/heritage_repository.dart';
import '../models/heritage_item_model.dart';

@LazySingleton(as: IHeritageRepository)
class SupabaseHeritageRepository implements IHeritageRepository {
  final SupabaseClient _client;

  SupabaseHeritageRepository(this._client);

  @override
  Future<Either<Failure, List<HeritageItemEntity>>> getHeritageItems(String circleId) async {
    try {
      final response = await _client
          .from('heritage_corner')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final items = (response as List).map((json) => HeritageItemModel.fromJson(json)).toList();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadHeritageItem(HeritageItemEntity item, File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'heritage/$fileName';
      await _client.storage.from('circle-media').upload(path, file);

      final model = HeritageItemModel(
        id: item.id,
        circleId: item.circleId,
        uploadedBy: item.uploadedBy,
        mediaUrl: path,
        caption: item.caption,
        eraLabel: item.eraLabel,
        tags: item.tags,
        createdAt: item.createdAt,
      );

      await _client.from('heritage_corner').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
