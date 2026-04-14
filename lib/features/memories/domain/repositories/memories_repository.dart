import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/memory.dart';

abstract class IMemoriesRepository {
  Future<Either<Failure, List<MemoryEntity>>> getCircleMemories(String circleId);
  Future<Either<Failure, void>> addMemory(MemoryEntity memory);
  Stream<List<MemoryEntity>> streamCircleMemories(String circleId);
}
