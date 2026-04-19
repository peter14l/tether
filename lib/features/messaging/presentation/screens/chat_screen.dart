import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../bloc/messaging_cubit.dart';
import '../bloc/messaging_state.dart';
import '../../domain/entities/message_entity.dart';

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
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) =>
          getIt<MessagingCubit>()
            ..loadMessages(widget.otherUserId, circleId: widget.circleId),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CustomScrollView(
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
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorScheme.primary,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          'Tether',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: SquircleAvatar(
                              imageUrl:
                                  'https://ui-avatars.com/api/?name=${widget.otherUserId}&background=6366f1&color=fff',
                              size: 40,
                              borderColor: colorScheme.primary.withOpacity(0.2),
                              borderWidth: 2,
                            ),
                          ),
                        ],
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver: BlocBuilder<MessagingCubit, MessagingState>(
                          builder: (context, state) {
                            if (state is MessagingLoading) {
                              return const SliverFillRemaining(
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            if (state is MessagingError) {
                              return SliverFillRemaining(
                                child: Center(child: Text(state.message)),
                              );
                            }
                            if (state is MessagingLoaded) {
                              if (state.messages.isEmpty) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: WhisperText('No reflections yet...'),
                                  ),
                                );
                              }
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final message = state.messages[index];
                                    final isMe = message.senderId != widget.otherUserId;
                                    final time =
                                        "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}";

                                    if (message.contentType == 'voice') {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 24),
                                        child: _buildVoiceNotePlayer(context, message),
                                      );
                                    }

                                    if (isMe) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 24),
                                        child: _buildSenderBubble(
                                          context,
                                          message.contentText ?? '',
                                          time,
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 24),
                                        child: _buildReceiverBubble(
                                          context,
                                          message.contentText ?? '',
                                          time,
                                        ),
                                      );
                                    }
                                  },
                                  childCount: state.messages.length,
                                ),
                              );
                            }
                            return const SliverToBoxAdapter(child: SizedBox.shrink());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInputBar(context),
              ],
            ),
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.12),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 8),
            WhisperText(time),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderBubble(BuildContext context, String text, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 8),
            WhisperText(time),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceNotePlayer(BuildContext context, MessageEntity message) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMe = message.senderId != widget.otherUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GlassPanel(
        padding: EdgeInsets.zero,
        opacity: 0.1,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SquircleAvatar(
                imageUrl:
                    'https://ui-avatars.com/api/?name=${message.senderId}&background=6366f1&color=fff',
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled_outlined,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(12, (index) {
                              return Container(
                                width: 3,
                                height: 12 + (index % 4) * 8.0,
                                decoration: BoxDecoration(
                                  color: index < 7
                                      ? colorScheme.primary
                                      : colorScheme.outlineVariant.withOpacity(
                                          0.3,
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const WhisperText('🎙️ Voice note'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.8),
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.12),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isSlowChat = !_isSlowChat),
                child: GlassPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  opacity: _isSlowChat ? 0.15 : 0.05,
                  borderRadius: BorderRadius.circular(20),
                  border: _isSlowChat
                      ? Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 1.5,
                        )
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isSlowChat
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant.withOpacity(0.4),
                          shape: BoxShape.circle,
                          boxShadow: _isSlowChat
                              ? [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      WhisperText(
                        'SLOW CHAT MODE',
                        color: _isSlowChat ? colorScheme.primary : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Builder(builder: (context) {
                return Row(
                  children: [
                    GlassPanel(
                      padding: const EdgeInsets.all(10),
                      opacity: 0.05,
                      borderRadius: BorderRadius.circular(32),
                      child: Icon(
                        Icons.mic_none_outlined,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a reflection...',
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TetherButton(
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          context.read<MessagingCubit>().sendMessage(
                                receiverId: widget.otherUserId,
                                circleId: widget.circleId,
                                contentType: 'text',
                                contentText: _messageController.text.trim(),
                              );
                          _messageController.clear();
                        }
                      },
                      width: 52,
                      height: 52,
                      child: const Icon(Icons.send_rounded, size: 24),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnonymousVent extends StatelessWidget {
  const _AnonymousVent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.tertiary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(48 * 0.35),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.tertiary.withOpacity(0.2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Someone in your Circle 🌫️',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const WhisperText('Fades in 24hrs'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '"Sometimes I feel like I\'m shouting into a void, but today, the silence felt warm."',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurface.withOpacity(0.85),
              height: 1.6,
            ),
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
      padding: EdgeInsets.zero,
      opacity: 0.1,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 4,
              width: 120,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WhisperText('ONE-WAY POST'),
                    WhisperText(
                      'Fades in 10s',
                      color: colorScheme.primary.withOpacity(0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'The light through the window at 4 PM is the only thing I need right now.',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                    height: 1.5,
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

class _LetterArrival extends StatelessWidget {
  const _LetterArrival();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        TetherCard(
          padding: EdgeInsets.zero,
          width: 240,
          height: 140,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.tertiary, colorScheme.primary],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.tertiary.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: GlassPanel(
                padding: const EdgeInsets.all(12),
                opacity: 0.2,
                borderRadius: BorderRadius.circular(32),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: colorScheme.onPrimary,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'A letter arrived for you.',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'From Julian',
          style: theme.textTheme.displaySmall?.copyWith(
            color: colorScheme.primary,
            fontStyle: FontStyle.italic,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 40),
        TetherButton(
          onPressed: () {},
          style: TetherButtonStyle.secondary,
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.mail_outline, size: 18),
              SizedBox(width: 12),
              Text('Open slowly'),
            ],
          ),
        ),
      ],
    );
  }
}
