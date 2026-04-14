import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/future_letter.dart';

abstract class IFutureLetterRepository {
  Future<Either<Failure, List<FutureLetterEntity>>> getFutureLetters(String circleId);
  Future<Either<Failure, void>> sendFutureLetter(FutureLetterEntity letter);
  Stream<List<FutureLetterEntity>> streamFutureLetters(String circleId);
}
