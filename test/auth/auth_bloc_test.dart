import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/core/error/failures.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------
class MockAuthRepository extends Mock implements IAuthRepository {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
UserEntity fakeUser() => UserEntity(
      id: 'user-123',
      email: 'test@example.com',
      username: 'testuser',
      displayName: 'Test User',
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    // Default: stream never emits (no spurious events)
    when(() => mockRepo.onAuthStateChanged)
        .thenAnswer((_) => const Stream.empty());
  });

  // -------------------------------------------------------------------------
  // TEST 1 – Happy-path: signIn emits Authenticated ✔
  // -------------------------------------------------------------------------
  group('SignInRequested – success', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when signIn succeeds',
      build: () {
        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => const Stream.empty());
        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(fakeUser()));
        return AuthBloc(mockRepo);
      },
      act: (bloc) =>
          bloc.add(const SignInRequested('test@example.com', 'secret')),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
    );
  });

  // -------------------------------------------------------------------------
  // TEST 2 – SignIn error emits AuthError ✔
  // -------------------------------------------------------------------------
  group('SignInRequested – failure', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => const Stream.empty());
        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
            (_) async => const Left(AuthFailure('Invalid credentials')));
        return AuthBloc(mockRepo);
      },
      act: (bloc) =>
          bloc.add(const SignInRequested('bad@example.com', 'wrong')),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      verify: (bloc) {
        final last = bloc.state as AuthError;
        expect(last.message, contains('Invalid credentials'));
      },
    );
  });

  // -------------------------------------------------------------------------
  // TEST 3 – REGRESSION: onAuthStateChanged emitting null after successful
  //           signIn must NOT override the Authenticated state.
  // -------------------------------------------------------------------------
  group('REGRESSION: onAuthStateChanged race condition fix', () {
    test(
      'stream emitting null after signIn does NOT override Authenticated state',

      () async {
        // Arrange: stream controller that we fire manually
        final streamController = StreamController<UserEntity?>();

        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => streamController.stream);

        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(fakeUser()));

        final bloc = AuthBloc(mockRepo);

        // Collect states
        final states = <AuthState>[];
        final sub = bloc.stream.listen(states.add);

        // Act: user taps "Log In"
        bloc.add(const SignInRequested('test@example.com', 'secret'));

        // Wait for signIn to complete and emit Authenticated
        await Future.delayed(const Duration(milliseconds: 100));

        // Now the onAuthStateChanged stream fires null
        // (e.g., profile fetch inside onAuthStateChanged returned null)
        streamController.add(null);
        await Future.delayed(const Duration(milliseconds: 100));

        // --- Assertion ---
        // We EXPECT the final state to remain Authenticated, …
        // but the bug causes it to be Unauthenticated because
        // the null-emission overwrites the state, blocking navigation.
        final finalState = bloc.state;

        await sub.cancel();
        await bloc.close();
        await streamController.close();

        expect(
          finalState,
          isA<Authenticated>(),
          reason:
              'After the fix: onAuthStateChanged emitting null must NOT '
              'override the Authenticated state set by a successful signIn. '
              'Navigation from /login to / should work correctly.',
        );
      },
    );
  });

  // -------------------------------------------------------------------------
  // TEST 4 – REGRESSION: GoRouter redirect must see Authenticated after
  //          signIn even if the auth stream fires null shortly after.
  // -------------------------------------------------------------------------
  group('REGRESSION: Router redirect sees correct state after sign-in', () {
    test(
      'bloc.state remains Authenticated when the router redirect fires '
      'after a null stream event',

      () async {
        final streamController = StreamController<UserEntity?>();

        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => streamController.stream);

        when(
          () => mockRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(fakeUser()));

        final bloc = AuthBloc(mockRepo);

        bloc.add(const SignInRequested('test@example.com', 'secret'));
        await Future.delayed(const Duration(milliseconds: 100));

        // Simulate onAuthStateChanged firing null (profile not found after retries)
        streamController.add(null);
        await Future.delayed(const Duration(milliseconds: 100));

        // Simulate: GoRouter redirect reads bloc.state here.
        // If it is Unauthenticated, redirect returns '/login' → screen stays.
        final stateSeenByRouter = bloc.state;

        await bloc.close();
        await streamController.close();

        expect(
          stateSeenByRouter,
          isA<Authenticated>(),
          reason:
              'After the fix: GoRouter reads getIt<AuthBloc>().state. '
              'A null stream event must not change Authenticated → Unauthenticated, '
              'so the redirect returns null and navigation to \'/\' proceeds.',
        );
      },
    );
  });

  // -------------------------------------------------------------------------
  // TEST 5 – AuthCheckRequested on initial launch
  // -------------------------------------------------------------------------
  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no current user',
      build: () {
        when(() => mockRepo.getCurrentUser())
            .thenAnswer((_) async => const Right(null));
        return AuthBloc(mockRepo);
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when session exists',
      build: () {
        when(() => mockRepo.getCurrentUser())
            .thenAnswer((_) async => Right(fakeUser()));
        return AuthBloc(mockRepo);
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
    );
  });
}
