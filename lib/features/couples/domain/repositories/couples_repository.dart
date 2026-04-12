import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/couple_bubble.dart';
import '../entities/digital_hug.dart';
import '../entities/heartbeat.dart';

abstract class ICouplesRepository {
  Future<Either<Failure, CoupleBubbleEntity>> getCoupleBubble(String circleId);
  Future<Either<Failure, void>> updateCoupleBubble(CoupleBubbleEntity bubble);
  Future<Either<Failure, void>> sendDigitalHug(DigitalHugEntity hug);
  Future<Either<Failure, void>> sendHeartbeat(HeartbeatEntity heartbeat);
  Stream<DigitalHugEntity> streamDigitalHugs(String circleId);
  Stream<HeartbeatEntity> streamHeartbeats(String circleId);
}
