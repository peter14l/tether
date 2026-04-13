import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/tether_text_field.dart';
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
                    child: TetherTextField(
                      controller: _contentController,
                      hintText: "What are you grateful for today?",
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<JournalCubit, JournalState>(
                    builder: (context, state) {
                      return TetherButton(
                        width: 60,
                        height: 60,
                        tooltip: 'Save gratitude entry',
                        semanticsLabel: 'Save Entry Button',
                        onPressed: () {
                          if (_contentController.text.isNotEmpty) {
                            context.read<JournalCubit>().addEntry(_contentController.text);
                            _contentController.clear();
                          }
                        },
                        child: const Icon(Icons.check_circle, size: 28),
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TetherCard(
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

