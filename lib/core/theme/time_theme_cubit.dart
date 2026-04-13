import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'theme_tokens.dart';
import 'time_theme_state.dart';

@lazySingleton
class TimeThemeCubit extends Cubit<TimeThemeState> {
  Timer? _timer;

  TimeThemeCubit() : super(TimeThemeState(_calculateSlot())) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // Don't auto-update slot if user has manually overridden dark mode
      if (state.isDarkModeOverride != null) return;

      final newSlot = _calculateSlot();
      if (newSlot != state.slot) {
        emit(TimeThemeState(newSlot));
      }
    });
  }

  void toggleDarkMode({required bool enabled}) {
    emit(state.copyWith(isDarkModeOverride: enabled ? true : false));
  }

  void clearDarkModeOverride() {
    emit(TimeThemeState(_calculateSlot()));
  }

  static TimeSlot _calculateSlot() {
    final now = DateTime.now();
    final hour = now.hour + (now.minute / 60.0);

    // Morning: 5:00 - 11:59
    if (hour >= 5.0 && hour < 12.0) return TimeSlot.morning;
    // Afternoon: 12:00 - 17:29
    if (hour >= 12.0 && hour < 17.5) return TimeSlot.afternoon;
    // Dusk: 17:30 - 20:59
    if (hour >= 17.5 && hour < 21.0) return TimeSlot.dusk;
    // Night: 21:00 - 4:59
    return TimeSlot.night;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
