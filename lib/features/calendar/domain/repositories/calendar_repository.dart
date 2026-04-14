import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/calendar_event.dart';

abstract class ICalendarRepository {
  Future<Either<Failure, List<CalendarEventEntity>>> getCircleEvents(String circleId);
  Future<Either<Failure, void>> createEvent(CalendarEventEntity event);
  Future<Either<Failure, void>> deleteEvent(String eventId);
  Stream<List<CalendarEventEntity>> streamCircleEvents(String circleId);
}
