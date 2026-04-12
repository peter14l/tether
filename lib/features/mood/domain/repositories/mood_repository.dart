import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/mood_status.dart';

abstract class IMoodRepository {
  Future<Either<Failure, MoodStatusEntity>> getMoodStatus(String userId);
  Future<Either<Failure, void>> setMoodStatus(MoodStatusEntity status);
}
