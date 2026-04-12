import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/bedtime_story.dart';

abstract class IBedtimeStoriesRepository {
  Future<Either<Failure, List<BedtimeStoryEntity>>> getBedtimeStories(String circleId);
  Future<Either<Failure, void>> saveBedtimeStory(BedtimeStoryEntity story, File file);
}
