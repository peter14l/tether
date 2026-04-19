import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/sos_alert.dart';
import '../../../../core/widgets/tether_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class SosAlertOverlay extends StatelessWidget {
  final SosAlertEntity alert;
  final VoidCallback onResolve;
  final String? senderPhone;

  const SosAlertOverlay({
    super.key,
    required this.alert,
    required this.onResolve,
    this.senderPhone,
  });

  Future<void> _launchMaps() async {
    if (alert.lat != null && alert.lng != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${alert.lat},${alert.lng}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  Future<void> _callSender() async {
    if (senderPhone != null) {
      final url = 'tel:$senderPhone';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade900.withOpacity(0.95),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.warning_24_regular, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'SOS ALERT',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'User needs immediate help.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
            ),
            if (alert.lat != null && alert.lng != null) ...[
              const SizedBox(height: 32),
              TetherButton(
                onPressed: _launchMaps,
                isFullWidth: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade900,
                child: const Text('View Live Location'),
              ),
            ],
            if (senderPhone != null) ...[
              const SizedBox(height: 16),
              TetherButton(
                onPressed: _callSender,
                isFullWidth: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade900,
                child: const Text('Call Sender'),
              ),
            ],
            const SizedBox(height: 48),
            TetherButton(
              onPressed: onResolve,
              style: TetherButtonStyle.secondary,
              isFullWidth: true,
              child: const Text('I am helping / Resolve', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
