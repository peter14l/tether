import 'dart:io';

void main() async {
  print('🚀 Tether MVP Setup starting...');

  print('\n📦 Fetching dependencies...');
  final pubGet = await Process.run('flutter', ['pub', 'get']);
  if (pubGet.exitCode != 0) {
    print('❌ flutter pub get failed: ${pubGet.stderr}');
    exit(1);
  }
  print('✅ Dependencies fetched.');

  print('\n🏗️ Running build_runner...');
  final buildRunner = await Process.run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs']);
  if (buildRunner.exitCode != 0) {
    print('❌ build_runner failed: ${buildRunner.stderr}');
    exit(1);
  }
  print('✅ Code generation complete.');

  print('\n🧹 Running analysis...');
  final analyze = await Process.run('flutter', ['analyze']);
  if (analyze.exitCode != 0) {
    print('⚠️ Analysis found issues (this is normal during development, but check them before pitching).');
  } else {
    print('✅ Analysis passed.');
  }

  print('\n✨ Setup complete! You are ready to develop Tether MVP.');
  print('Run the app with: flutter run');
}
