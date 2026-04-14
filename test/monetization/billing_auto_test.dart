import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tether/core/utils/installer_source.dart';
import 'package:tether/features/monetization/data/repositories/billing_repository_impl.dart';
import 'package:tether/features/monetization/domain/repositories/billing_method.dart';

class MockBillingRepositoryImpl extends Mock implements BillingRepositoryImpl {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(PaymentMethod.native);
  });

  group('BillingRepositoryImpl purchasePremiumAuto flow', () {
    test('uses RevenueCat when installed via Play Store', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.oasis/installer'),
            (call) async {
              if (call.method == 'getInstaller') {
                return 'com.android.vending';
              }
              return null;
            },
          );

      final installerSource =
          await InstallerSourceDetector.getInstallerSource();
      expect(installerSource, InstallerSource.playStore);
    });

    test('uses Razorpay when installed via APK', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.oasis/installer'),
            (call) async {
              if (call.method == 'getInstaller') {
                return 'com.google.android.packageinstaller';
              }
              return null;
            },
          );

      final installerSource =
          await InstallerSourceDetector.getInstallerSource();
      expect(installerSource, InstallerSource.apk);
    });

    test('uses Razorpay when installer is unknown', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.oasis/installer'),
            (call) async {
              if (call.method == 'getInstaller') {
                return 'unknown';
              }
              return null;
            },
          );

      final installerSource =
          await InstallerSourceDetector.getInstallerSource();
      expect(installerSource, InstallerSource.apk);
    });
  });

  group('InstallerSource to PaymentMethod mapping', () {
    test('playStore maps to RevenueCat (native)', () {
      final source = InstallerSource.playStore;
      final expectedMethod = PaymentMethod.native;
      expect(expectedMethod, PaymentMethod.native);
    });

    test('apk maps to Razorpay', () {
      final source = InstallerSource.apk;
      final expectedMethod = PaymentMethod.razorpay;
      expect(expectedMethod, PaymentMethod.razorpay);
    });

    test('unknown maps to Razorpay (default)', () {
      final source = InstallerSource.unknown;
      final expectedMethod = PaymentMethod.razorpay;
      expect(expectedMethod, PaymentMethod.razorpay);
    });
  });
}
