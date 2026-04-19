import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../injection_container.dart';
import '../bloc/bedtime_stories_cubit.dart';
import '../bloc/bedtime_stories_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class BedtimeStoriesScreen extends StatefulWidget {
  final String circleId;
  const BedtimeStoriesScreen({super.key, required this.circleId});

  @override
  State<BedtimeStoriesScreen> createState() => _BedtimeStoriesScreenState();
}

class _BedtimeStoriesScreenState extends State<BedtimeStoriesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingId;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playStory(String storyId, String url) async {
    if (_currentlyPlayingId == storyId) {
      await _audioPlayer.stop();
      setState(() => _currentlyPlayingId = null);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _currentlyPlayingId = storyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BedtimeStoriesCubit>()..loadStories(widget.circleId),
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
                  final isPlaying = _currentlyPlayingId == story.id;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isPlaying ? FluentIcons.stop_24_regular : FluentIcons.play_24_filled,
                        size: 40,
                        color: Colors.orange,
                      ),
                      title: Text(story.title ?? 'Untitled Story'),
                      subtitle: Text('${story.durationSecs} seconds'),
                      onTap: () {
                        // In a real app, you'd get a signed URL from Supabase
                        // For now, we'll assume the storagePath is accessible or handled by the cubit/repo
                        // Note: Supabase storage URLs usually need to be signed.
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () => _showRecordDialog(context),
            label: const Text('Record a Story'),
            icon: const Icon(FluentIcons.mic_24_regular),
          ),
        ),
      ),
    );
  }

  void _showRecordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _RecordStoryDialog(
        onSaved: (file, title, duration) {
          context.read<BedtimeStoriesCubit>().saveStory(
            circleId: widget.circleId,
            file: file,
            title: title,
            durationSecs: duration,
          );
        },
      ),
    );
  }
}

class _RecordStoryDialog extends StatefulWidget {
  final Function(File file, String title, int duration) onSaved;
  const _RecordStoryDialog({required this.onSaved});

  @override
  State<_RecordStoryDialog> createState() => _RecordStoryDialogState();
}

class _RecordStoryDialogState extends State<_RecordStoryDialog> {
  final _record = AudioRecorder();
  final _titleController = TextEditingController();
  bool _isRecording = false;
  DateTime? _startTime;
  String? _path;

  @override
  void dispose() {
    _record.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _record.hasPermission()) {
        final dir = await getTemporaryDirectory();
        _path = '${dir.path}/story_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _record.start(const RecordConfig(), path: _path!);
        setState(() {
          _isRecording = true;
          _startTime = DateTime.now();
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    final path = await _record.stop();
    final duration = DateTime.now().difference(_startTime!).inSeconds;
    
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Name your story'),
            content: TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'e.g. The Brave Little Toaster'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onSaved(File(path), _titleController.text, duration);
                  Navigator.pop(context); // Close name dialog
                  Navigator.pop(context); // Close record dialog
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record a Story'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Share a moment with the little ones.'),
          const SizedBox(height: 24),
          if (_isRecording)
            const Text('Recording...', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        if (!_isRecording)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ElevatedButton.icon(
          onPressed: _isRecording ? _stopRecording : _startRecording,
          icon: Icon(_isRecording ? FluentIcons.stop_24_regular : FluentIcons.mic_24_regular),
          label: Text(_isRecording ? 'Stop' : 'Start Recording'),
        ),
      ],
    );
  }
}
