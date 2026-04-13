import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/circles/presentation/screens/circles_screen.dart';
import '../../features/circles/presentation/screens/create_circle_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/messaging/presentation/screens/messaging_screen.dart';
import '../../features/messaging/presentation/screens/chat_screen.dart';
import '../../features/mood/presentation/screens/mood_selection_screen.dart';
import '../../features/journal/presentation/screens/journal_screen.dart';
import '../../features/journal/presentation/screens/reflection_wall_screen.dart';
import '../../features/wellness/presentation/screens/breathing_room_screen.dart';
import '../../features/couples/presentation/screens/our_bubble_screen.dart';
import '../../features/family/presentation/screens/family_dashboard_screen.dart';
import '../../features/family/presentation/screens/heritage_corner_screen.dart';
import '../../features/family/presentation/screens/bedtime_stories_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/monetization/presentation/screens/checkout_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../injection_container.dart';
import '../widgets/main_shell.dart';
import '../widgets/biometric_guard.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _AuthRefreshListenable(getIt<AuthBloc>()),
  redirect: (context, state) {
    final authState = getIt<AuthBloc>().state;
    final bool loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (authState is Unauthenticated || authState is AuthInitial) {
      return loggingIn ? null : '/login';
    }

    if (authState is Authenticated) {
      if (loggingIn) return '/';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CirclesScreen(),
        ),
        GoRoute(
          path: '/feed/:circleId',
          builder: (context, state) {
            final circleId = state.pathParameters['circleId']!;
            return FeedScreen(circleId: circleId);
          },
        ),
        GoRoute(
          path: '/messaging',
          builder: (context, state) => const MessagingScreen(),
        ),
        GoRoute(
          path: '/breathing',
          builder: (context, state) => const BreathingRoomScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/circles/create',
      builder: (context, state) => const CreateCircleScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/messaging/chat/:circleId/:otherUserId',
      builder: (context, state) {
        final circleId = state.pathParameters['circleId']!;
        final otherUserId = state.pathParameters['otherUserId']!;
        return ChatScreen(circleId: circleId, otherUserId: otherUserId);
      },
    ),
    GoRoute(
      path: '/mood',
      builder: (context, state) => const MoodSelectionScreen(),
    ),
    GoRoute(
      path: '/journal',
      builder: (context, state) => const BiometricGuard(
        child: JournalScreen(),
      ),
    ),
    GoRoute(
      path: '/reflection',
      builder: (context, state) => const BiometricGuard(
        child: ReflectionWallScreen(),
      ),
    ),
    GoRoute(
      path: '/bubble/:circleId',
      builder: (context, state) {
        final circleId = state.pathParameters['circleId']!;
        return OurBubbleScreen(circleId: circleId);
      },
    ),
    GoRoute(
      path: '/family/:circleId',
      builder: (context, state) {
        final circleId = state.pathParameters['circleId']!;
        return FamilyDashboardScreen(circleId: circleId);
      },
    ),
    GoRoute(
      path: '/family/:circleId/heritage',
      builder: (context, state) {
        final circleId = state.pathParameters['circleId']!;
        return HeritageCornerScreen(circleId: circleId);
      },
    ),
    GoRoute(
      path: '/family/:circleId/stories',
      builder: (context, state) {
        final circleId = state.pathParameters['circleId']!;
        return BedtimeStoriesScreen(circleId: circleId);
      },
    ),
  ],
);

class _AuthRefreshListenable extends ChangeNotifier {
  late final StreamSubscription _subscription;

  _AuthRefreshListenable(AuthBloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
