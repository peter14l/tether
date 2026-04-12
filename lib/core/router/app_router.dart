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

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CirclesScreen(),
    ),
    GoRoute(
      path: '/circles/create',
      builder: (context, state) => const CreateCircleScreen(),
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
      builder: (context, state) => const JournalScreen(),
    ),
    GoRoute(
      path: '/reflection',
      builder: (context, state) => const ReflectionWallScreen(),
    ),
    GoRoute(
      path: '/breathing',
      builder: (context, state) => const BreathingRoomScreen(),
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
    GoRoute(
      path: '/login',
      builder: (context, state) => const PlaceholderScreen(title: 'Login'),
    ),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen Placeholder'),
      ),
    );
  }
}
