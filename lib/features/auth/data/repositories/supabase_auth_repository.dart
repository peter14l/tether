import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/user_key_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../injection_container.dart';
import '../../../monetization/domain/repositories/billing_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: IAuthRepository)
class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient _client;
  final UserKeyManager _keyManager;

  SupabaseAuthRepository(this._client, this._keyManager);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'display_name': displayName},
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Sign up failed'));
      }

      await _keyManager.generateAndStoreKey();

      final profile = {
        'id': user.id,
        'username': username,
        'display_name': displayName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final userEntity = UserModel.fromJson(profile, email);
      unawaited(getIt<IBillingRepository>().identify(user.id));
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Sign in failed'));
      }

      if (!await _keyManager.hasUserKey()) {
        await _keyManager.generateAndStoreKey();
      }

      final profileResponse = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      dynamic newProfile;
      if (profileResponse == null) {
        newProfile = {
          'id': user.id,
          'username': email.split('@').first,
          'display_name': email.split('@').first,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        await _client.from('profiles').insert(newProfile);
      }

      final tier = await _fetchSubscriptionTier(user.id);
      unawaited(getIt<IBillingRepository>().identify(user.id));

      final userModel = UserModel.fromJson(
        profileResponse ?? newProfile,
        email,
        tier: tier,
      );
      debugPrint(
        'SupabaseAuthRepository: Handled user model for ${userModel.id}',
      );
      return Right(userModel);
    } catch (e) {
      debugPrint('SupabaseAuthRepository: Error during signIn: $e');
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      unawaited(getIt<IBillingRepository>().reset());
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) return const Right(null);

      final user = session.user;

      for (int i = 0; i < 3; i++) {
        final profileResponse = await _client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          final tier = await _fetchSubscriptionTier(user.id);
          unawaited(getIt<IBillingRepository>().identify(user.id));
          return Right(
            UserModel.fromJson(profileResponse, user.email ?? '', tier: tier),
          );
        }

        if (i < 2) await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return null;

      final user = session.user;

      for (int i = 0; i < 3; i++) {
        try {
          final profileResponse = await _client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

          if (profileResponse != null) {
            final tier = await _fetchSubscriptionTier(user.id);
            unawaited(getIt<IBillingRepository>().identify(user.id));
            return UserModel.fromJson(
              profileResponse,
              user.email ?? '',
              tier: tier,
            );
          }

          if (i < 2)
            await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        } catch (_) {
          if (i == 2) return null;
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        }
      }

      return null;
    });
  }

  Future<String> _fetchSubscriptionTier(String userId) async {
    try {
      final subscription = await _client
          .from('user_subscriptions')
          .select('tier')
          .eq('user_id', userId)
          .maybeSingle();

      return subscription?['tier'] as String? ?? 'free';
    } catch (_) {
      return 'free';
    }
  }
}
