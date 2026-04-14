import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tether/core/utils/installer_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstallerSourceDetector', () {
    test('returns playStore when installer is com.android.vending', () async {
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

      final result = await InstallerSourceDetector.getInstallerSource();
      expect(result, InstallerSource.playStore);
    });

    test(
      'returns playStore when installer is com.google.android.feedback',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('com.oasis/installer'),
              (call) async {
                if (call.method == 'getInstaller') {
                  return 'com.google.android.feedback';
                }
                return null;
              },
            );

        final result = await InstallerSourceDetector.getInstallerSource();
        expect(result, InstallerSource.playStore);
      },
    );

    test(
      'returns apk when installer is com.google.android.packageinstaller',
      () async {
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

        final result = await InstallerSourceDetector.getInstallerSource();
        expect(result, InstallerSource.apk);
      },
    );

    test('returns apk when installer is unknown', () async {
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

      final result = await InstallerSourceDetector.getInstallerSource();
      expect(result, InstallerSource.apk);
    });

    test('returns unknown when channel throws', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.oasis/installer'),
            (call) async {
              throw Exception('Channel error');
            },
          );

      final result = await InstallerSourceDetector.getInstallerSource();
      expect(result, InstallerSource.unknown);
    });
  });

  group('InstallerSource enum', () {
    test('has correct values', () {
      expect(InstallerSource.values.length, 3);
      expect(InstallerSource.playStore.index, 0);
      expect(InstallerSource.apk.index, 1);
      expect(InstallerSource.unknown.index, 2);
    });
  });
}
