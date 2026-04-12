import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class IPresenceRepository {
  Future<Either<Failure, void>> toggleQuietMode(bool enabled);
  Stream<Map<String, dynamic>> streamPresence(String circleId);
}
