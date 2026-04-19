import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/digital_hug.dart';
import '../../domain/entities/kindness_streak.dart';
import '../../domain/repositories/wellness_repository.dart';
import 'package:equatable/equatable.dart';

abstract class WellnessState extends Equatable {
  const WellnessState();
  @override
  List<Object?> get props => [];
}

class WellnessInitial extends WellnessState {}
class WellnessLoading extends WellnessState {}
class WellnessLoaded extends WellnessState {
  final List<KindnessStreakEntity> streaks;
  const WellnessLoaded(this.streaks);
  @override
  List<Object?> get props => [streaks];
}
class WellnessError extends WellnessState {
  final String message;
  const WellnessError(this.message);
  @override
  List<Object?> get props => [message];
}

@injectable
class WellnessCubit extends Cubit<WellnessState> {
  final IWellnessRepository _repository;
  final SupabaseClient _client;

  WellnessCubit(this._repository, this._client) : super(WellnessInitial());

  Future<void> sendHug(String receiverId, String circleId) async {
    final senderId = _client.auth.currentUser?.id;
    if (senderId == null) return;

    final hug = DigitalHugEntity(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      circleId: circleId,
      sentAt: DateTime.now(),
    );

    await _repository.sendDigitalHug(hug);
    // Optionally log as kindness action
    await _repository.logKindnessAction(KindnessStreakEntity(
      id: '',
      userId: senderId,
      circleId: circleId,
      actionType: 'digital_hug',
      loggedAt: DateTime.now(),
    ));
  }

  Future<void> loadStreaks(String circleId) async {
    emit(WellnessLoading());
    final result = await _repository.getKindnessStreaks(circleId);
    result.fold(
      (failure) => emit(WellnessError(failure.message)),
      (streaks) => emit(WellnessLoaded(streaks)),
    );
  }
}
