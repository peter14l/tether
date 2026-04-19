import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../injection_container.dart';
import '../../../mood/presentation/bloc/mood_cubit.dart';
import '../../../mood/presentation/bloc/mood_state.dart';
import '../../../mood/domain/entities/mood_status.dart';
import '../../../journal/presentation/bloc/journal_cubit.dart';
import '../../../journal/presentation/bloc/journal_state.dart';
import '../../../circles/presentation/bloc/circle_cubit.dart';
import '../../../circles/presentation/bloc/circle_state.dart';
import '../../../circles/domain/entities/circle_entity.dart';
import '../bloc/check_in_cubit.dart';
import '../bloc/check_in_state.dart';
import '../bloc/wellness_cubit.dart';
import '../bloc/wellness_state.dart';
import '../bloc/playlist_cubit.dart';
import '../../domain/entities/shared_playlist.dart';
import '../../../../core/theme/time_theme_cubit.dart';
import '../../../../core/theme/time_theme_state.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _opacityAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  CircleEntity? _selectedCircle;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: const Cubic(0.4, 0, 0.6, 1),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleSound(String url) async {
    if (_currentlyPlayingUrl == url) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingUrl = null;
      });
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentlyPlayingUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MoodCubit>()..loadMood()),
        BlocProvider(create: (context) => getIt<JournalCubit>()..loadEntries()),
        BlocProvider(create: (context) => getIt<CheckInCubit>()),
        BlocProvider(create: (context) => getIt<WellnessCubit>()),
        BlocProvider(create: (context) => getIt<PlaylistCubit>()),
        BlocProvider(create: (context) => getIt<CircleCubit>()..loadCircles()),
      ],
      child: BlocListener<CircleCubit, CircleState>(
        listener: (context, state) {
          if (state is CircleLoaded && state.circles.isNotEmpty && _selectedCircle == null) {
            setState(() {
              _selectedCircle = state.circles.first;
            });
            context.read<WellnessCubit>().loadStreaks(state.circles.first.id);
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: colorScheme.surface.withOpacity(0.01),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ColorFilter.mode(
                      colorScheme.surface.withOpacity(0.8),
                      BlendMode.srcOver,
                    ),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                title: Text(
                  'Wellness',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                actions: [
                  _CircleSelector(
                    selectedCircle: _selectedCircle,
                    onSelected: (circle) {
                      setState(() {
                        _selectedCircle = circle;
                      });
                      context.read<WellnessCubit>().loadStreaks(circle.id);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24, left: 8),
                    child: BlocBuilder<MoodCubit, MoodState>(
                      builder: (context, state) {
                        String emoji = '😊';
                        if (state is MoodLoaded) {
                          emoji = _getMoodEmoji(state.status.status);
                        }
                        return GestureDetector(
                          onTap: () => _showMoodSelection(context),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SquircleAvatar(
                                imageUrl: '',
                                size: 40,
                                borderColor: colorScheme.primary.withOpacity(0.2),
                                borderWidth: 2,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(emoji, style: const TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _BreathingSection(
                      animation: _breathingAnimation,
                      opacityAnimation: _opacityAnimation,
                      currentlyPlayingUrl: _currentlyPlayingUrl,
                      onToggleSound: _toggleSound,
                    ),
                    const SizedBox(height: 48),
                    const _MoodStatusBanner(),
                    const SizedBox(height: 64),
                    _DigitalHugSection(selectedCircle: _selectedCircle),
                    const SizedBox(height: 64),
                    _CheckInSection(selectedCircle: _selectedCircle),
                    const SizedBox(height: 64),
                    const _GratitudeJournal(),
                    const SizedBox(height: 64),
                    const _KindnessBadges(),
                    const SizedBox(height: 64),
                    const _QuietHours(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoodSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<MoodCubit>(),
        child: const _MoodSelectionSheet(),
      ),
    );
  }

  String _getMoodEmoji(MoodType type) {
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
}

class _CircleSelector extends StatelessWidget {
  final CircleEntity? selectedCircle;
  final Function(CircleEntity) onSelected;

  const _CircleSelector({this.selectedCircle, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleCubit, CircleState>(
      builder: (context, state) {
        if (state is CircleLoaded && state.circles.isNotEmpty) {
          return PopupMenuButton<CircleEntity>(
            initialValue: selectedCircle,
            onSelected: onSelected,
            icon: Icon(Icons.group_outlined, color: Theme.of(context).colorScheme.primary),
            itemBuilder: (context) => state.circles
                .map((c) => PopupMenuItem(value: c, child: Text(c.name)))
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _MoodSelectionSheet extends StatelessWidget {
  const _MoodSelectionSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text('How are you?', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: MoodType.values.length,
            itemBuilder: (context, index) {
              final type = MoodType.values[index];
              return InkWell(
                onTap: () {
                  context.read<MoodCubit>().updateMood(type);
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Text(_getEmoji(type), style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      _getLabel(type),
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
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
      case MoodType.needQuiet: return 'Quiet';
      case MoodType.anxious: return 'Anxious';
      case MoodType.wantToChat: return 'Chat';
      case MoodType.happy: return 'Happy';
      case MoodType.tired: return 'Tired';
      case MoodType.inMyHead: return 'Zen';
      case MoodType.openDoor: return 'Open';
    }
  }
}

class _MoodStatusBanner extends StatelessWidget {
  const _MoodStatusBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        if (state is MoodLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              opacity: 0.05,
              borderRadius: BorderRadius.circular(24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Feeling ${_getLabel(state.status.status)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _getLabel(MoodType type) {
    switch (type) {
      case MoodType.needQuiet: return 'Quiet';
      case MoodType.anxious: return 'Anxious';
      case MoodType.wantToChat: return 'Chatty';
      case MoodType.happy: return 'Happy';
      case MoodType.tired: return 'Tired';
      case MoodType.inMyHead: return 'Zen';
      case MoodType.openDoor: return 'Open';
    }
  }
}

class _BreathingSection extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> opacityAnimation;
  final String? currentlyPlayingUrl;
  final Function(String) onToggleSound;

  const _BreathingSection({
    required this.animation,
    required this.opacityAnimation,
    this.currentlyPlayingUrl,
    required this.onToggleSound,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultAmbientSounds = [
      {'name': 'Rain', 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'},
      {'name': 'Forest', 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'},
      {'name': 'Lo-Fi', 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'},
    ];

    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHighest.withOpacity(0.2),
            colorScheme.surface,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: opacityAnimation.value,
                    child: Container(
                      width: 260 * animation.value,
                      height: 260 * animation.value,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.15),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Breath',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: colorScheme.primary,
                  fontStyle: FontStyle.italic,
                  fontSize: 48,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              const WhisperText(
                'Breath in... and out',
                fontSize: 14,
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: defaultAmbientSounds.map((sound) {
                  final isSelected = currentlyPlayingUrl == sound['url'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _SoundChip(
                      label: sound['name']!,
                      isSelected: isSelected,
                      onTap: () => onToggleSound(sound['url']!),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoundChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SoundChip({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        opacity: isSelected ? 0.2 : 0.05,
        borderRadius: BorderRadius.circular(32),
        border: isSelected
            ? Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1.5)
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? Icons.pause : Icons.play_arrow, size: 14),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitalHugSection extends StatelessWidget {
  final CircleEntity? selectedCircle;
  const _DigitalHugSection({this.selectedCircle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () => _sendQuickHug(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 40,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.volunteer_activism_outlined,
                color: colorScheme.primary,
                size: 56,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Digital Hug',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        WhisperText(selectedCircle != null 
          ? 'Tap to send warmth to ${selectedCircle!.name}' 
          : 'Tap to send warmth to your circles'),
      ],
    );
  }

  void _sendQuickHug(BuildContext context) {
    if (selectedCircle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a circle first 🌸')),
      );
      return;
    }
    
    // In a real app, you'd pick a specific receiver. 
    // For this prototype, we send to the "Circle" as a whole or a mock receiver.
    context.read<WellnessCubit>().sendHug('mock_receiver_id', selectedCircle!.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending a digital hug to ${selectedCircle!.name}... 🤗'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _CheckInSection extends StatelessWidget {
  final CircleEntity? selectedCircle;
  const _CheckInSection({this.selectedCircle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BlocBuilder<CheckInCubit, CheckInState>(
        builder: (context, state) {
          final isSuccess = state is CheckInSuccess;
          return TetherCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const WhisperText('DAILY CHECK-IN'),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? "You're checked in! ✓" : 'Are you doing okay?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                if (!isSuccess)
                  TetherButton(
                    onPressed: () {
                      if (selectedCircle == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a circle first 🌸')),
                        );
                        return;
                      }
                      context.read<CheckInCubit>().submitCheckIn(selectedCircle!.id);
                    },
                    loading: state is CheckInLoading,
                    child: const Text('Check In'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GratitudeJournal extends StatelessWidget {
  const _GratitudeJournal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WhisperText('GRATITUDE JOURNAL'),
          const SizedBox(height: 24),
          BlocBuilder<JournalCubit, JournalState>(
            builder: (context, state) {
              if (state is JournalLoaded && state.entries.isNotEmpty) {
                return Column(
                  children: state.entries.take(2).map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _GratitudeEntry(
                      text: entry.content,
                      date: '${entry.date.day}/${entry.date.month}',
                    ),
                  )).toList(),
                );
              }
              return GlassPanel(
                padding: const EdgeInsets.all(32),
                opacity: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WhisperText('PROMPT'),
                    const SizedBox(height: 12),
                    Text(
                      'What made you smile today?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          TetherButton(
            onPressed: () => _showNewEntrySheet(context),
            style: TetherButtonStyle.secondary,
            child: const Text('Write Entry'),
          ),
        ],
      ),
    );
  }

  void _showNewEntrySheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(_).viewInsets.bottom),
        child: GlassPanel(
          padding: const EdgeInsets.all(32),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gratitude', style: Theme.of(_).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                maxLines: 5,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'I am grateful for...',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 24),
              TetherButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    context.read<JournalCubit>().addEntry(controller.text);
                    Navigator.pop(_);
                  }
                },
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GratitudeEntry extends StatelessWidget {
  final String text;
  final String date;
  const _GratitudeEntry({required this.text, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TetherCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhisperText(date),
              Icon(
                Icons.lock_outline,
                size: 16,
                color: colorScheme.onSurfaceVariant.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KindnessBadges extends StatelessWidget {
  const _KindnessBadges();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WhisperText('KINDNESS STREAK'),
          const SizedBox(height: 24),
          BlocBuilder<WellnessCubit, WellnessState>(
            builder: (context, state) {
              int count = 0;
              if (state is WellnessLoaded) {
                count = state.streaks.length;
              }
              return Row(
                children: [
                  Expanded(
                    child: GlassPanel(
                      padding: const EdgeInsets.all(24),
                      opacity: 0.05,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          WhisperText('$count Actions'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassPanel(
                      padding: const EdgeInsets.all(24),
                      opacity: 0.05,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              color: colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const WhisperText('Sunlight'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuietHours extends StatefulWidget {
  const _QuietHours();

  @override
  State<_QuietHours> createState() => _QuietHoursState();
}

class _QuietHoursState extends State<_QuietHours> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(
          _isEnabled ? Icons.nights_stay : Icons.nights_stay_outlined,
          color: _isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant.withOpacity(0.4),
          size: 32,
        ),
        const SizedBox(height: 16),
        WhisperText(
          _isEnabled ? 'Quiet Hours Active' : 'Quiet Hours',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Switch.adaptive(
          value: _isEnabled,
          onChanged: (val) {
            setState(() {
              _isEnabled = val;
            });
            // Update presence/quiet hours repository if needed
          },
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }
}
