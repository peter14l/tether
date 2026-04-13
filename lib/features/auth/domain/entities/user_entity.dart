import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final String? pronouns;
  final String? moodStatus;
  final bool isQuiet;
  final DateTime? quietUntil;
  final String? timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.pronouns,
    this.moodStatus,
    this.isQuiet = false,
    this.quietUntil,
    this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        displayName,
        avatarUrl,
        bio,
        pronouns,
        moodStatus,
        isQuiet,
        quietUntil,
        timezone,
        createdAt,
        updatedAt,
      ];
}
