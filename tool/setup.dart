import 'dart:io';
Future<void> main() async {
  final root = Directory.current;
  if (!File('pubspec.yaml').existsSync()) { stderr.writeln('Run from the project folder.'); exit(1); }
  // Generate platform boilerplate using the locally installed Flutter version.
  // flutter create preserves existing source files without --overwrite.
  var result = await Process.run('flutter', ['create', '--platforms=android,web', '--project-name', 'post_reader_favorites', '--org', 'com.example', '--no-pub', '.'], runInShell: true);
  stdout.write(result.stdout); stderr.write(result.stderr);
  if(result.exitCode != 0) exit(result.exitCode);
  final manifest = File('${root.path}/android/app/src/main/AndroidManifest.xml');
  var xml = manifest.readAsStringSync();
  if(!xml.contains('android.permission.INTERNET')) {
    xml = xml.replaceFirst('<application', '<uses-permission android:name="android.permission.INTERNET" />\n    <application');
  }
  xml = xml.replaceAll('android:label="post_reader_favorites"', 'android:label="Post Reader &amp; Favorites"');
  manifest.writeAsStringSync(xml);
  // Remove only Flutter's generated counter-app test; keep project tests.
  final sample = File('test/widget_test.dart');
  if(sample.existsSync() && sample.readAsStringSync().contains('Counter increments smoke test')) sample.deleteSync();
  for(final args in [['pub', 'get'], ['analyze'], ['test']]) {
    result = await Process.run('flutter', args, runInShell: true);
    stdout.write(result.stdout); stderr.write(result.stderr);
    if(result.exitCode != 0) exit(result.exitCode);
  }
  stdout.writeln('Setup complete. Start your emulator, then run flutter run.');
}
