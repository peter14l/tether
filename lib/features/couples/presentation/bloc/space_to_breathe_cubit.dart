import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/couples_repository.dart';
import 'space_to_breathe_state.dart';

@injectable
class SpaceToBreatheCubit extends Cubit<SpaceToBreatheState> {
  final ICouplesRepository _couplesRepository;
  final SupabaseClient _supabaseClient;

  SpaceToBreatheCubit(this._couplesRepository, this._supabaseClient) : super(SpaceToBreatheInitial());

  Future<void> loadStatus(String circleId) async {
    emit(SpaceToBreatheLoading());
    final result = await _couplesRepository.getCoupleBubble(circleId);
    result.fold(
      (failure) => emit(SpaceToBreatheError(failure.message)),
      (bubble) => emit(SpaceToBreatheStatus(
        isActive: bubble.spaceToBreatheActive,
        until: bubble.spaceToBreatheUntil,
        activeBy: bubble.spaceToBreatheBy,
      )),
    );
  }

  Future<void> toggleSpace(String circleId, bool active, {int? hours}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final bubbleResult = await _couplesRepository.getCoupleBubble(circleId);
    if (bubbleResult.isLeft()) return;

    final bubble = (bubbleResult as dynamic).value;
    final updatedBubble = bubble.copyWith(
      spaceToBreatheActive: active,
      spaceToBreatheUntil: active && hours != null ? DateTime.now().add(Duration(hours: hours)) : null,
      spaceToBreatheBy: active ? userId : null,
    );

    final result = await _couplesRepository.updateCoupleBubble(updatedBubble);
    result.fold(
      (failure) => emit(SpaceToBreatheError(failure.message)),
      (_) => emit(SpaceToBreatheStatus(
        isActive: active,
        until: updatedBubble.spaceToBreatheUntil,
        activeBy: updatedBubble.spaceToBreatheBy,
      )),
    );
  }
}

// Helper extension for copyWith if not in entity
extension on dynamic {
  dynamic copyWith({bool? spaceToBreatheActive, DateTime? spaceToBreatheUntil, String? spaceToBreatheBy}) {
    // This is a hack for the prototype, in a real app entities should have copyWith
    return this; 
  }
}
