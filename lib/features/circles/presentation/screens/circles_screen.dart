import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/circle_cubit.dart';
import '../bloc/circle_state.dart';

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CircleCubit>()..loadCircles(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Circles', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocBuilder<CircleCubit, CircleState>(
          builder: (context, state) {
            if (state is CircleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CircleLoaded) {
              if (state.circles.isEmpty) {
                return const Center(child: Text('You are not in any circles yet.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.circles.length,
                itemBuilder: (context, index) {
                  final circle = state.circles[index];
                  return Card(
                    child: ListTile(
                      title: Text(circle.name, style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Text(circle.circleType),
                      onTap: () => context.push('/feed/${circle.id}'),
                    ),
                  );
                },
              );
            } else if (state is CircleError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/circles/create'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
