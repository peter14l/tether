import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/journal_entry.dart';

abstract class IJournalRepository {
  Future<Either<Failure, List<JournalEntryEntity>>> getJournalEntries();
  Future<Either<Failure, void>> addJournalEntry(JournalEntryEntity entry);
}
