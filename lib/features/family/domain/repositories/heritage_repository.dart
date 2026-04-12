import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/heritage_item.dart';

abstract class IHeritageRepository {
  Future<Either<Failure, List<HeritageItemEntity>>> getHeritageItems(String circleId);
  Future<Either<Failure, void>> uploadHeritageItem(HeritageItemEntity item, File file);
}
