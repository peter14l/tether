import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

abstract class IBiometricService {
  Future<bool> isAvailable();
  Future<bool> authenticate({required String localizedReason});
}

@LazySingleton(as: IBiometricService)
class BiometricService implements IBiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (_) {
      // In production, we'd log this through ITelemetryService
      return false;
    } catch (_) {
      return false;
    }
  }
}
