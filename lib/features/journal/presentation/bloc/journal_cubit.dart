import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import 'journal_state.dart';

@injectable
class JournalCubit extends Cubit<JournalState> {
  final IJournalRepository _journalRepository;
  final SupabaseClient _supabaseClient;

  JournalCubit(this._journalRepository, this._supabaseClient) : super(JournalInitial());

  Future<void> loadEntries() async {
    emit(JournalLoading());
    final result = await _journalRepository.getJournalEntries();
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (entries) => emit(JournalLoaded(entries)),
    );
  }

  Future<void> addEntry(String content) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const JournalError('User not authenticated'));
      return;
    }

    final newEntry = JournalEntryEntity(
      id: '',
      userId: userId,
      content: content,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final result = await _journalRepository.addJournalEntry(newEntry);
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (_) {
        emit(JournalEntryAdded());
        loadEntries();
      },
    );
  }
}
