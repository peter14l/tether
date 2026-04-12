import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/bedtime_stories_cubit.dart';
import '../bloc/bedtime_stories_state.dart';

class BedtimeStoriesScreen extends StatelessWidget {
  final String circleId;
  const BedtimeStoriesScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BedtimeStoriesCubit>()..loadStories(circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bedtime Stories', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocBuilder<BedtimeStoriesCubit, BedtimeStoriesState>(
          builder: (context, state) {
            if (state is BedtimeStoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BedtimeStoriesLoaded) {
              if (state.stories.isEmpty) {
                return const Center(child: Text('No recorded stories yet. Record one for the kids.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.stories.length,
                itemBuilder: (context, index) {
                  final story = state.stories[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_fill, size: 40, color: Colors.orange),
                      title: Text(story.title ?? 'Untitled Story'),
                      subtitle: Text('${story.durationSecs} seconds'),
                      onTap: () {
                        // Mock playback
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Mock recording
          },
          label: const Text('Record a Story'),
          icon: const Icon(Icons.mic),
        ),
      ),
    );
  }
}
