import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/couple_bubble_cubit.dart';
import '../bloc/couple_bubble_state.dart';
import '../widgets/interaction_animations.dart';

class OurBubbleScreen extends StatefulWidget {
  final String circleId;
  const OurBubbleScreen({super.key, required this.circleId});

  @override
  State<OurBubbleScreen> createState() => _OurBubbleScreenState();
}

class _OurBubbleScreenState extends State<OurBubbleScreen> {
  bool _showHug = false;
  bool _showHeart = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoupleBubbleCubit>()..loadBubble(widget.circleId),
      child: BlocListener<CoupleBubbleCubit, CoupleBubbleState>(
        listener: (context, state) {
          if (state is InteractionReceived) {
            if (state.interaction is dynamic && state.interaction.runtimeType.toString().contains('Hug')) {
              setState(() => _showHug = true);
              Future.delayed(const Duration(seconds: 2), () => setState(() => _showHug = false));
            } else {
              setState(() => _showHeart = true);
              Future.delayed(const Duration(seconds: 1), () => setState(() => _showHeart = false));
            }
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFE0B2), Color(0xFFF5F0E8)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Our Bubble', style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 16),
                        const Text('A quiet space for us.', style: TextStyle(letterSpacing: 1.5)),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _InteractionButton(
                              icon: Icons.favorite,
                              label: 'Heartbeat',
                              onTap: () {
                                context.read<CoupleBubbleCubit>().sendHeartbeat('mock_receiver');
                                setState(() => _showHeart = true);
                                Future.delayed(const Duration(seconds: 1), () => setState(() => _showHeart = false));
                              },
                            ),
                            const SizedBox(width: 40),
                            _InteractionButton(
                              icon: Icons.front_hand,
                              label: 'Digital Hug',
                              onTap: () {
                                context.read<CoupleBubbleCubit>().sendDigitalHug(widget.circleId, 'mock_receiver');
                                setState(() => _showHug = true);
                                Future.delayed(const Duration(seconds: 2), () => setState(() => _showHug = false));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_showHug) const Center(child: DigitalHugAnimation()),
                  if (_showHeart) const Center(child: HeartbeatAnimation()),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InteractionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 5),
              ],
            ),
            child: Icon(icon, size: 32, color: Colors.orange.shade800),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
