import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/journal_cubit.dart';
import '../bloc/journal_state.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<JournalCubit>()..loadEntries(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gratitude Journal', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: "What are you grateful for today?",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<JournalCubit, JournalState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: const Icon(Icons.check_circle, size: 32),
                        onPressed: () {
                          if (_contentController.text.isNotEmpty) {
                            context.read<JournalCubit>().addEntry(_contentController.text);
                            _contentController.clear();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<JournalCubit, JournalState>(
                builder: (context, state) {
                  if (state is JournalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is JournalLoaded) {
                    if (state.entries.isEmpty) {
                      return const Center(child: Text('No entries yet. Start with one small thing.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.entries.length,
                      itemBuilder: (context, index) {
                        final entry = state.entries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is JournalError) {
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
