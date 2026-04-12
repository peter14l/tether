import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/gallery_item.dart';

abstract class IGalleryRepository {
  Future<Either<Failure, List<GalleryItemEntity>>> getGalleryItems(String circleId);
  Future<Either<Failure, void>> uploadGalleryItem(String circleId, File file, String? caption);
}
