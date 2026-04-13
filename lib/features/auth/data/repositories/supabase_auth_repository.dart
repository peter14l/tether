import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: IAuthRepository)
class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

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
        data: {
          'username': username,
          'display_name': displayName,
        },
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Sign up failed'));
      }

      // Profile is now created by database trigger. 
      // We fetch it here if we want to return the full model.
      // If email confirmation is enabled, we won't have it yet, 
      // but we can return a skeleton model.

      final profile = {
        'id': user.id,
        'username': username,
        'display_name': displayName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      return Right(UserModel.fromJson(profile, email));
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

      final profileResponse = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profileResponse == null) {
        // Create a basic profile if missing (fallback)
        final newProfile = {
          'id': user.id,
          'username': email.split('@').first,
          'display_name': email.split('@').first,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        await _client.from('profiles').insert(newProfile);
        return Right(UserModel.fromJson(newProfile, email));
      }

      return Right(UserModel.fromJson(profileResponse, email));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
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
      
      // Retry profile fetch a few times
      for (int i = 0; i < 3; i++) {
        final profileResponse = await _client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          return Right(UserModel.fromJson(profileResponse, user.email ?? ''));
        }
        
        if (i < 2) await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }

      // If still no profile after retries, return null
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
      
      // Try to fetch profile with a simple retry logic to account for database triggers
      for (int i = 0; i < 3; i++) {
        try {
          final profileResponse = await _client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

          if (profileResponse != null) {
            return UserModel.fromJson(profileResponse, user.email ?? '');
          }
          
          // If profile not found, wait a bit and retry (only if we have a session)
          if (i < 2) await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        } catch (e) {
          if (i == 2) return null;
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        }
      }

      // Final fallback: if we have a session but still no profile after retries,
      // we return null which will trigger Unauthenticated, but the retries
      // should have given enough time for the trigger or signIn/signUp logic to finish.
      return null;
    });
  }
}
