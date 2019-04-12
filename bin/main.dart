import 'dart:io';
import 'dart:convert';

import 'package:get_dart/get_dart.dart' as get_dart;

class DartMachine {
  final String name;

  final String platform;

  final String architecture;

  const DartMachine(this.name, this.platform, this.architecture);

  static const windowsX64 = DartMachine('Windows ia32', 'windows', 'ia32');

  static const windowsIA32 = DartMachine('Windows x64', 'windows', 'x64');

  static const linuxX64 = DartMachine('Linux ia32', 'linux', 'ia32');

  static const linuxIA32 = DartMachine('Linux x64', 'linux', 'x64');

  static const macX64 = DartMachine('Mac ia32', 'macos', 'ia32');

  static const macIA32 = DartMachine('Mac x64', 'windows', 'x64');

  String toString() => '$platform-$architecture';
}

String getUrl(String version,
    {bool isDev = false, DartMachine machine: DartMachine.linuxX64}) {
  String stable = isDev ? 'dev' : 'stable';
  return "https://storage.googleapis.com/dart-archive/channels/$stable/release/$version/sdk/dartsdk-$machine-release.zip";
}

class Dart {
  String version;

  bool isDev;

  DartMachine machine;
}

String parseVersion(String versionString) {
  if (!versionString.startsWith("Dart VM version: "))
    throw Exception("Invalid version string!");

  final parts = versionString.substring(17).split(" ");

  return parts.first;
}

main(List<String> arguments) async {
  String url = getUrl("2.2.0");
  print(url);

  final res = await Process.run("dart", ["--version"],
      stdoutEncoding: utf8, stderrEncoding: utf8, runInShell: true);

  if (res.exitCode != 0) throw Exception("dart executable not found!");

  print(parseVersion(res.stderr));
}
