import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/presence_repository.dart';
import 'presence_state.dart';

@injectable
class PresenceCubit extends Cubit<PresenceState> {
  final IPresenceRepository _presenceRepository;
  StreamSubscription? _presenceSubscription;

  PresenceCubit(this._presenceRepository) : super(const PresenceState());

  Future<void> toggleQuietMode(bool enabled) async {
    final result = await _presenceRepository.toggleQuietMode(enabled);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(isQuiet: enabled)),
    );
  }

  void trackCirclePresence(String circleId) {
    _presenceSubscription?.cancel();
    _presenceSubscription = _presenceRepository
        .streamPresence(circleId)
        .listen((presence) {
      emit(state.copyWith(circlePresence: presence));
    });
  }

  @override
  Future<void> close() {
    _presenceSubscription?.cancel();
    return super.close();
  }
}
