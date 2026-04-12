import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/reflection.dart';

abstract class IReflectionRepository {
  Future<Either<Failure, List<ReflectionEntity>>> getReflections();
  Future<Either<Failure, void>> addReflection(ReflectionEntity reflection);
}
