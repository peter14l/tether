import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../bloc/messaging_cubit.dart';
import '../bloc/messaging_state.dart';

class ChatScreen extends StatefulWidget {
  final String circleId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.circleId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool _isSlowChat = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<MessagingCubit>()..loadMessages(widget.otherUserId, circleId: widget.circleId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Tether',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAcJfry8HNWQrKeOk3f7p1H6nXJVmr1ZuBaPuuQXb6xi1iWm--PQLHvBqYu-wupO1_AaoL5WuZnYmsB8fgR5PQyJTHRhZExAB3lAs8SWp-7Y_1Ee5KH_9IgoW8VJzA1YhE2We0IiZEnGfpX5gMr79hJEEW5epeymvaojqgoWJjSJS1ppFbgwsYzb1tC-LwTioHI2Zp2QLm94SLFGcZO0gVUbbbc8YRlcgIHnrowbrHheLQNhzTlF6kbD49F-skJeOgfb9LTP6ISQxGJ',
                size: 40,
                borderColor: colorScheme.primary.withOpacity(0.2),
                borderWidth: 2,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagingCubit, MessagingState>(
                builder: (context, state) {
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildReceiverBubble(
                        context,
                        'I was thinking about that letter you sent. It really moved me.',
                        '10:42 AM',
                      ),
                      const SizedBox(height: 16),
                      _buildVoiceNotePlayer(context),
                      const SizedBox(height: 16),
                      _buildSenderBubble(
                        context,
                        "I'm so glad. It took me a long time to find the right words.",
                        '10:45 AM',
                      ),
                      const SizedBox(height: 48),
                      const _AnonymousVent(),
                      const SizedBox(height: 24),
                      const _OneWayPost(),
                      const SizedBox(height: 48),
                      const _LetterArrival(),
                    ],
                  );
                },
              ),
            ),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverBubble(BuildContext context, String text, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.15),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            WhisperText(time, fontSize: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderBubble(BuildContext context, String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2D1E28),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            WhisperText(time, fontSize: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceNotePlayer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: colorScheme.primary,
                    child: Icon(Icons.mic, size: 10, color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.play_arrow, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(10, (index) {
                            return Container(
                              width: 3,
                              height: 10 + (index % 3) * 10.0,
                              decoration: BoxDecoration(
                                color: index < 6 ? colorScheme.primary : colorScheme.outline,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const WhisperText('🎙️ Voice note · 0:42', fontSize: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isSlowChat = !_isSlowChat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const WhisperText('SLOW CHAT MODE', uppercase: true, fontSize: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a reflection...',
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnonymousVent extends StatelessWidget {
  const _AnonymousVent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colorScheme.tertiary, colorScheme.secondary]),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Someone in your Circle 🌫️', style: TextStyle(fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const WhisperText('Fades in 24hrs', fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '"Sometimes I feel like I\'m shouting into a void, but today, the silence felt warm."',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _OneWayPost extends StatelessWidget {
  const _OneWayPost();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GlassPanel(
      opacity: 0.1,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 4,
              width: 100,
              color: colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WhisperText('ONE-WAY POST', uppercase: true, color: Colors.orange),
                    WhisperText('This will fade in 10s', color: colorScheme.primary.withOpacity(0.8)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'The light through the window at 4 PM is the only thing I need right now.',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterArrival extends StatelessWidget {
  const _LetterArrival();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [colorScheme.tertiary, colorScheme.primary]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
          ),
          child: Center(
            child: CircleAvatar(
              backgroundColor: const Color(0xFF8A1A1E),
              child: Icon(Icons.workspace_premium, color: colorScheme.tertiary),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('A letter arrived for you.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('From Julian', style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.primary)),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.mail),
          label: const Text('Open slowly'),
        ),
      ],
    );
  }
}
