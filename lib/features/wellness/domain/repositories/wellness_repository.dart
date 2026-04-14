import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/digital_hug.dart';
import '../entities/kindness_streak.dart';

abstract class IWellnessRepository {
  Future<Either<Failure, void>> sendDigitalHug(DigitalHugEntity hug);
  Stream<List<DigitalHugEntity>> streamDigitalHugs(String circleId);
  
  Future<Either<Failure, List<KindnessStreakEntity>>> getKindnessStreaks(String circleId);
  Future<Either<Failure, void>> logKindnessAction(KindnessStreakEntity streak);
}
