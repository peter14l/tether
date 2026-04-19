import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/onboarding_overlay.dart';
import '../bloc/messaging_cubit.dart';
import '../bloc/messaging_state.dart';
import '../../domain/entities/message_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String? otherUserId; // Optional for 1:1, used for metadata if room info not loaded

  const ChatScreen({
    super.key,
    required this.roomId,
    this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final GlobalKey _chatThreadKey = GlobalKey();
  final GlobalKey _voiceNoteKey = GlobalKey();
  final GlobalKey _threadHeaderKey = GlobalKey();

  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_chat_onboarding') ?? false;
    if (!hasSeen && mounted) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_chat_onboarding', true);
    if (mounted) {
      setState(() {
        _showOverlay = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // 1. Chat Feed
          Positioned.fill(
            child: BlocBuilder<MessagingCubit, MessagingState>(
              builder: (context, state) {
                if (state is MessagingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MessagingError) {
                  return Center(child: Text(state.message));
                }
                if (state is MessagingLoaded) {
                  return ListView.builder(
                    key: _chatThreadKey,
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 140, 20, 120),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.senderId != widget.otherUserId; // Simple check for now
                      
                      return _buildMessageBubble(context, message, isMe);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // 2. Floating Headers (3 Opaque Containers)
          _buildFloatingHeaders(context),

          // 3. Integrated Input Bar
          _buildIntegratedInputBar(context),

          if (_showOverlay)
            FeatureOnboardingOverlay(
              steps: [
                OnboardingStep(
                  targetKey: _chatThreadKey,
                  title: 'Private by Default',
                  body: "Messages in Tether carry no read receipts by default. No blue ticks. No pressure to respond the moment you've read something. Reply when you're ready.",
                ),
                OnboardingStep(
                  targetKey: _voiceNoteKey,
                  title: 'Record a Voice Note',
                  body: "Hold the mic icon to record. When sent, your voice appears as a living waveform — the other person can see the rhythm of your voice before they even press play.",
                ),
                OnboardingStep(
                  targetKey: _threadHeaderKey,
                  title: 'Context Always Visible',
                  body: "This conversation lives inside a Circle. Every message here is encrypted and only accessible to the members of that specific Circle — no one else.",
                ),
              ],
              onComplete: _markOnboardingComplete,
              onSkip: _markOnboardingComplete,
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeaders(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top + 16;

    return Positioned(
      top: topPadding,
      left: 20,
      right: 20,
      child: Row(
        key: _threadHeaderKey,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Control
          _buildFloatingContainer(
            onTap: () => Navigator.pop(context),
            child: const Icon(FluentIcons.chevron_left_24_regular, size: 28),
            isCircle: true,
          ),

          // Identity Pillar
          _buildFloatingContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SquircleAvatar(
                  imageUrl: 'https://ui-avatars.com/api/?name=${widget.otherUserId}&background=6750A4&color=fff',
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Julian', // Replace with real name
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            isPill: true,
          ),

          // Utility Control
          _buildFloatingContainer(
            onTap: () {}, // More options
            child: const Icon(FluentIcons.more_vertical_24_regular, size: 24),
            isCircle: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingContainer({
    required Widget child,
    VoidCallback? onTap,
    bool isCircle = false,
    bool isPill = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isCircle 
          ? const EdgeInsets.all(12) 
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(isCircle ? 100 : 32),
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, MessageEntity message, bool isMe) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.messageType == 'text')
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isMe 
                  ? colorScheme.primary 
                  : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isMe ? 24 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 24),
                ),
              ),
              child: Text(
                message.encryptedText ?? '[Encrypted]',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                ),
              ),
            )
          else
            _buildMediaPreview(context, message, isMe),
          
          const SizedBox(height: 4),
          WhisperText(
            "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}",
            fontSize: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context, MessageEntity message, bool isMe) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          // If expired
          if (message.isExpired)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.history_24_regular, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  WhisperText('Media Expired'),
                ],
              ),
            )
          else
            const Center(child: CircularProgressIndicator()), // TODO: Lazy load decrypted media
          
          // Media Type Icon
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                message.messageType == 'image' ? FluentIcons.image_24_regular : 
                message.messageType == 'video' ? FluentIcons.video_24_regular : FluentIcons.document_24_regular,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegratedInputBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Positioned(
      bottom: bottomPadding,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Attachment Button (Nested)
            IconButton(
              key: _voiceNoteKey,
              onPressed: _pickMedia,
              icon: Icon(FluentIcons.add_circle_24_regular, color: colorScheme.primary, size: 28),
            ),
            
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),

            // Send Button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(FluentIcons.arrow_up_24_regular, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<MessagingCubit>().sendMessage(
        roomId: widget.roomId,
        messageType: 'text',
        contentText: _messageController.text.trim(),
      );
      _messageController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<MessagingCubit>().sendMediaMessage(
        roomId: widget.roomId,
        messageType: 'image',
        file: File(image.path),
      );
    }
  }
}
