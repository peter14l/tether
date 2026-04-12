import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/heritage_cubit.dart';
import '../bloc/heritage_state.dart';

class HeritageCornerScreen extends StatelessWidget {
  final String circleId;
  const HeritageCornerScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HeritageCubit>()..loadItems(circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Heritage Corner', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocBuilder<HeritageCubit, HeritageState>(
          builder: (context, state) {
            if (state is HeritageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HeritageLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text('No family archives yet.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Placeholder(), // Image placeholder
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item.eraLabel ?? 'Unknown Era',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Mock upload
          },
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
