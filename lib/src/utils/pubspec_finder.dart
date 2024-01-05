import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';

final _pubSpecGlob = Glob(join('.', '**', 'pubspec.yaml'));

class PubspecFinder {
  static Future<List<(PubSpec, Directory path)>> findAll(
      {List<String> ignorePaths = const ['.gitignore']}) async {
    final ignoreGlobs = <Glob>{};
    for (final ignorePath in ignorePaths) {
      final ignoreFile = File(ignorePath);
      for (final line in await ignoreFile.readAsLines()) {
        if (!line.startsWith('#') && line.isNotEmpty) {
          ignoreGlobs.add(
            Glob(
              line.replaceAll(RegExp(r'/$'), ''),
              recursive: true,
            ),
          );
        }
      }
    }

    final asyncPubSpecs = <Future<(PubSpec, Directory)>>[];
    for (final pubspec in _pubSpecGlob.listSync()) {
      final path = pubspec.path.replaceAll(RegExp(r'^(\./)*'), '');

      if (!ignoreGlobs.any((glob) => glob.matches(path))) {
        asyncPubSpecs.add(Future(
          () async => (await PubSpec.loadFile(path), pubspec.parent),
        ));
      }
    }

    return Future.wait(asyncPubSpecs);
  }
}
