import 'package:flutter/material.dart';
import '../../domain/entities/sos_alert.dart';

class SosAlertOverlay extends StatelessWidget {
  final SosAlertEntity alert;
  final VoidCallback onResolve;

  const SosAlertOverlay({super.key, required this.alert, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.9),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'SOS ALERT',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'From: ${alert.userId}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: onResolve,
              child: const Text('I am helping / Resolve'),
            ),
          ],
        ),
      ),
    );
  }
}
