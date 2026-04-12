import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/reflection.dart';
import '../../domain/repositories/reflection_repository.dart';
import 'reflection_state.dart';

@injectable
class ReflectionCubit extends Cubit<ReflectionState> {
  final IReflectionRepository _reflectionRepository;
  final SupabaseClient _supabaseClient;

  ReflectionCubit(this._reflectionRepository, this._supabaseClient) : super(ReflectionInitial());

  Future<void> loadReflections() async {
    emit(ReflectionLoading());
    final result = await _reflectionRepository.getReflections();
    result.fold(
      (failure) => emit(ReflectionError(failure.message)),
      (reflections) => emit(ReflectionLoaded(reflections)),
    );
  }

  Future<void> addReflection(String content) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const ReflectionError('User not authenticated'));
      return;
    }

    final newReflection = ReflectionEntity(
      id: '',
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
    );

    final result = await _reflectionRepository.addReflection(newReflection);
    result.fold(
      (failure) => emit(ReflectionError(failure.message)),
      (_) {
        emit(ReflectionAdded());
        loadReflections();
      },
    );
  }
}
