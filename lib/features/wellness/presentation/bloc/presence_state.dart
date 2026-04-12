import 'package:equatable/equatable.dart';

class PresenceState extends Equatable {
  final Map<String, dynamic> circlePresence;
  final bool isQuiet;
  final String? errorMessage;

  const PresenceState({
    this.circlePresence = const {},
    this.isQuiet = false,
    this.errorMessage,
  });

  PresenceState copyWith({
    Map<String, dynamic>? circlePresence,
    bool? isQuiet,
    String? errorMessage,
  }) {
    return PresenceState(
      circlePresence: circlePresence ?? this.circlePresence,
      isQuiet: isQuiet ?? this.isQuiet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [circlePresence, isQuiet, errorMessage];
}
