import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/circles/presentation/screens/circles_screen.dart';
import '../../features/circles/presentation/screens/create_circle_screen.dart';
import '../../features/messaging/presentation/screens/messaging_screen.dart';
import '../../features/messaging/presentation/screens/chat_screen.dart';
import '../../features/messaging/presentation/screens/new_message_screen.dart';
import '../../features/messaging/presentation/bloc/user_search_cubit.dart';
import '../../features/messaging/presentation/bloc/messaging_cubit.dart';
import '../../features/couples/presentation/screens/our_bubble_screen.dart';
import '../../features/family/presentation/screens/family_dashboard_screen.dart';
import '../../features/family/presentation/screens/heritage_corner_screen.dart';
import '../../features/family/presentation/screens/bedtime_stories_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/subscription_screen.dart';
import '../../features/monetization/presentation/screens/checkout_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../injection_container.dart';
import '../widgets/main_shell.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _AuthRefreshListenable(getIt<AuthBloc>()),
  redirect: (context, state) {
    final authState = getIt<AuthBloc>().state;
    final bool loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup' || state.matchedLocation == '/onboarding';

    debugPrint('AppRouter: Redirect check - location: ${state.matchedLocation}, authState: ${authState.runtimeType}');

    if (authState is Unauthenticated || authState is AuthInitial) {
      if (!loggingIn) {
        debugPrint('AppRouter: Redirecting to /onboarding');
        return '/onboarding';
      }
      return null;
    }

    if (authState is Authenticated) {
      if (loggingIn) {
        debugPrint('AppRouter: Redirecting to / (Authenticated)');
        return '/';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MessagingScreen(),
        ),
        GoRoute(
          path: '/circles',
          builder: (context, state) => const CirclesScreen(),
        ),
        GoRoute(
          path: '/messaging',
          name: 'messaging',
          builder: (context, state) => const MessagingScreen(),
        ),
        GoRoute(
          path: '/messaging/new',
          name: 'new_message',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<UserSearchCubit>(),
            child: const NewMessageScreen(),
          ),
        ),
        GoRoute(
          path: '/messaging/chat/:roomId',
          name: 'chat',
          builder: (context, state) {
            final roomId = state.pathParameters['roomId']!;
            final otherUserId = state.uri.queryParameters['otherUserId'];
            return BlocProvider(
              create: (context) => getIt<MessagingCubit>()..loadMessages(roomId),
              child: ChatScreen(roomId: roomId, otherUserId: otherUserId),
            );
          },
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
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
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
