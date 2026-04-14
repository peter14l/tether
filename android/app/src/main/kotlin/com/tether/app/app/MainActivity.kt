package com.tether.app.app

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = MethodChannel(flutterEngine.dartExecutor, "com.oasis/installer")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstaller" -> {
                    val installer = packageManager.getInstallerPackageName(packageName)
                    result.success(installer)
                }
                else -> result.notImplemented()
            }
        }
    }
}
