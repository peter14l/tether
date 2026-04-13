import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/tether_text_field.dart';
import '../bloc/reflection_cubit.dart';
import '../bloc/reflection_state.dart';

class ReflectionWallScreen extends StatefulWidget {
  const ReflectionWallScreen({super.key});

  @override
  State<ReflectionWallScreen> createState() => _ReflectionWallScreenState();
}

class _ReflectionWallScreenState extends State<ReflectionWallScreen> {
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReflectionCubit>()..loadReflections(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reflection Wall', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TetherTextField(
                      controller: _contentController,
                      maxLines: 3,
                      hintText: "What's on your mind? (Completely private)",
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<ReflectionCubit, ReflectionState>(
                    builder: (context, state) {
                      return TetherButton(
                        width: 60,
                        height: 60,
                        tooltip: 'Add reflection',
                        semanticsLabel: 'Add Reflection Button',
                        onPressed: () {
                          if (_contentController.text.isNotEmpty) {
                            context.read<ReflectionCubit>().addReflection(_contentController.text);
                            _contentController.clear();
                          }
                        },
                        child: const Icon(Icons.send, size: 24),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ReflectionCubit, ReflectionState>(
                builder: (context, state) {
                  if (state is ReflectionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReflectionLoaded) {
                    if (state.reflections.isEmpty) {
                      return const Center(child: Text('Your wall is empty. Start writing.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.reflections.length,
                      itemBuilder: (context, index) {
                        final reflection = state.reflections[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TetherCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reflection.content,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${reflection.createdAt.day}/${reflection.createdAt.month}/${reflection.createdAt.year}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ReflectionError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

