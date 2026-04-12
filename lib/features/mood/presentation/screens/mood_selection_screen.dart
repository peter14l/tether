import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/mood_cubit.dart';
import '../bloc/mood_state.dart';
import '../../domain/entities/mood_status.dart';

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  final _labelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MoodCubit>()..loadMood(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('How are you feeling?', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocConsumer<MoodCubit, MoodState>(
          listener: (context, state) {
            if (state is MoodLoaded && _labelController.text.isEmpty) {
              _labelController.text = state.status.label ?? '';
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                      hintText: 'Add a custom label (optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: MoodType.values.length,
                    itemBuilder: (context, index) {
                      final type = MoodType.values[index];
                      final isSelected = state is MoodLoaded && state.status.status == type;
                      return _MoodCard(
                        type: type,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<MoodCubit>().updateMood(type, label: _labelController.text);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final MoodType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodCard({required this.type, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_getEmoji(type), style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(_getLabel(type), style: theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }

  String _getEmoji(MoodType type) {
    switch (type) {
      case MoodType.needQuiet: return '🤫';
      case MoodType.anxious: return '😰';
      case MoodType.wantToChat: return '💬';
      case MoodType.happy: return '😊';
      case MoodType.tired: return '😴';
      case MoodType.inMyHead: return '🌀';
      case MoodType.openDoor: return '🚪';
    }
  }

  String _getLabel(MoodType type) {
    switch (type) {
      case MoodType.needQuiet: return 'Need Quiet';
      case MoodType.anxious: return 'Anxious';
      case MoodType.wantToChat: return 'Want to Chat';
      case MoodType.happy: return 'Happy';
      case MoodType.tired: return 'Tired';
      case MoodType.inMyHead: return 'In My Head';
      case MoodType.openDoor: return 'Open Door';
    }
  }
}
