import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/notifications/push_notification_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final IPushNotificationService _pushService;
  StreamSubscription? _authSubscription;

  AuthBloc(this._authRepository, this._pushService) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);

    _authSubscription = _authRepository.onAuthStateChanged.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    final user = event.user;
    if (user != null) {
      emit(Authenticated(user));
      _pushService.initialize();
      _pushService.registerToken();
    } else if (state is! Authenticated) {
      // Only emit Unauthenticated from the stream when we are NOT already
      // Authenticated. This prevents a race condition where:
      //  1. signIn() succeeds and emits Authenticated, then
      //  2. the onAuthStateChanged stream fires null (profile fetch failed)
      //     and overwrites Authenticated → Unauthenticated, blocking navigation.
      // Real sign-outs are handled by _onSignOutRequested which explicitly
      // emits Unauthenticated before this stream can react.
      emit(Unauthenticated());
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: SignInRequested for ${event.email}');
    emit(AuthLoading());
    final result = await _authRepository.signIn(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) {
        debugPrint('AuthBloc: SignIn Failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        debugPrint('AuthBloc: SignIn Success for ${user.id}');
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signUp(
      email: event.email,
      password: event.password,
      username: event.username,
      displayName: event.displayName,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
