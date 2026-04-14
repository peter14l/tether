import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.displayName,
    super.avatarUrl,
    super.bio,
    super.pronouns,
    super.moodStatus,
    super.isQuiet,
    super.quietUntil,
    super.timezone,
    super.subscriptionTier = 'free',
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String email, {String? tier}) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: email,
      username: json['username'] as String? ?? email.split('@').first,
      displayName: json['display_name'] as String? ?? email.split('@').first,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      pronouns: json['pronouns'] as String?,
      moodStatus: json['mood_status'] as String?,
      isQuiet: json['is_quiet'] as bool? ?? false,
      quietUntil: json['quiet_until'] != null ? DateTime.parse(json['quiet_until'] as String) : null,
      timezone: json['timezone'] as String?,
      subscriptionTier: tier ?? json['subscription_tier'] as String? ?? 'free',
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String) 
        : DateTime.now(),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'] as String) 
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'pronouns': pronouns,
      'mood_status': moodStatus,
      'is_quiet': isQuiet,
      'quiet_until': quietUntil?.toIso8601String(),
      'timezone': timezone,
      'subscription_tier': subscriptionTier,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
