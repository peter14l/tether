import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/family_ritual.dart';

abstract class IFamilyRitualRepository {
  Future<Either<Failure, List<FamilyRitualEntity>>> getCircleRituals(String circleId);
  Future<Either<Failure, void>> createRitual(FamilyRitualEntity ritual);
  Stream<List<FamilyRitualEntity>> streamCircleRituals(String circleId);
}
