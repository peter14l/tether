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
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Sign up failed'));
      }

      // Create profile record
      final profile = {
        'id': user.id,
        'username': username,
        'display_name': displayName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('profiles').insert(profile);

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
          .single();

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
      final profileResponse = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return Right(UserModel.fromJson(profileResponse, user.email ?? ''));
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
      try {
        final profileResponse = await _client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        return UserModel.fromJson(profileResponse, user.email ?? '');
      } catch (e) {
        return null;
      }
    });
  }
}
