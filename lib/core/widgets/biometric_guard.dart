import 'package:flutter/material.dart';
import '../security/biometric_service.dart';
import '../../injection_container.dart';
import 'tether_button.dart';

class BiometricGuard extends StatefulWidget {
  final Widget child;
  final String localizedReason;

  const BiometricGuard({
    super.key,
    required this.child,
    this.localizedReason = 'Please authenticate to access this safe space.',
  });

  @override
  State<BiometricGuard> createState() => _BiometricGuardState();
}

class _BiometricGuardState extends State<BiometricGuard> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final biometricService = getIt<IBiometricService>();
    final isAvailable = await biometricService.isAvailable();

    if (!isAvailable) {
      if (mounted) {
        setState(() {
          _isAuthenticated = true; // Fallback if no biometrics available
          _isLoading = false;
        });
      }
      return;
    }

    final didAuthenticate = await biometricService.authenticate(
      localizedReason: widget.localizedReason,
    );

    if (mounted) {
      setState(() {
        _isAuthenticated = didAuthenticate;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                'Authentication Required',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TetherButton(
                onPressed: _authenticate,
                child: const Text('Try Again'),
              ),
              const SizedBox(height: 16),
              TetherButton(
                style: TetherButtonStyle.secondary,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
