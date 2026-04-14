import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum InstallerSource { playStore, apk, unknown }

class InstallerSourceDetector {
  static const _channel = MethodChannel('com.oasis/installer');

  static Future<InstallerSource> getInstallerSource() async {
    try {
      final String? installer = await _channel.invokeMethod('getInstaller');
      if (installer == null) return InstallerSource.unknown;

      switch (installer.toLowerCase()) {
        case 'com.android.vending':
        case 'com.google.android.feedback':
        case 'com.google.android.apps.installovert':
          return InstallerSource.playStore;
        case 'com.google.android.packageinstaller':
        case 'com.android.packageinstaller':
        case 'unknown':
          return InstallerSource.apk;
        default:
          return InstallerSource.apk;
      }
    } catch (e) {
      debugPrint('InstallerSource detection error: $e');
      return InstallerSource.unknown;
    }
  }
}
