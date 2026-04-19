import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class MoodOrbRow extends StatefulWidget {
  const MoodOrbRow({super.key});

  @override
  State<MoodOrbRow> createState() => _MoodOrbRowState();
}

class _MoodOrbRowState extends State<MoodOrbRow> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _moods = [
    {'label': '😌 Calm', 'color': const Color(0xFF7EB8D4)},
    {'label': '😊 Happy', 'color': const Color(0xFFF0A832)},
    {'label': '😐 Okay', 'color': const Color(0xFFA89880)},
    {'label': '😔 Low', 'color': const Color(0xFFC2527A)},
    {'label': '😤 Stressed', 'color': const Color(0xFFE87B5A)},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: List.generate(_moods.length, (index) {
          final isSelected = _selectedIndex == index;
          final mood = _moods[index];
          
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mood['color'] as Color,
                    ),
                  )
                      .animate(target: isSelected ? 1 : 0)
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.12, 1.12),
                        duration: 300.ms,
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 12),
                  Text(
                    mood['label'] as String,
                    style: LinenEmberTheme.caption(color: mood['color'] as Color)
                        .copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
