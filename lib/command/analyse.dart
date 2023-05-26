import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';

class AnalyseSubPackageCommand extends Command<void> {
  AnalyseSubPackageCommand() {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The path of the output file.',
      defaultsTo: './analyse.txt',
    );
  }

  @override
  String get name => 'analyse';

  @override
  String get description => 'Analyse package version in sub pubspec';

  @override
  String get invocation => 'analyse -o ./result.txt';

  final allDependencies = <String, Dependency>{};
  final allDevDependencies = <String, Dependency>{};
  final allOverrideDependencies = <String, Dependency>{};

  @override
  Future<void> run() async {
    final output = argResults?['output'] as String;

    final pubspecFiles = Glob(join('.', '**', 'pubspec.yaml'));
    for (final entity in pubspecFiles.listSync()) {
      await _analysePubFile(path: entity.path);
    }

    await _writeReport(output);
  }

  Future<void> _analysePubFile({required String path}) async {
    // load pubSpec
    final pubSpec = await PubSpec.loadFile(path);
    final projectName = pubSpec.name ?? 'unknow';

    pubSpec.dependencies.forEach((key, DependencyReference value) {
      if (value is! PathReference &&
          value is! SdkReference &&
          value is! GitReference) {
        final version = value.toString();
        allDependencies.update(
          key,
          (old) => old.update(file: projectName, version: version),
          ifAbsent: () => Dependency(
            namePub: key,
            versions: [
              DepVersion(
                version,
                [projectName],
              )
            ],
          ),
        );
      }
    });
  }

  Future<void> _writeReport(String filePath) async {
    final file = File(filePath);
    file.writeAsStringSync('Analyse of ${DateTime.now()}\n');

    allDependencies.forEach((key, value) {
      print('$key:');
      file.writeAsStringSync(
        '$key:\n',
        mode: FileMode.append,
      );

      for (var e in value.versions) {
        file.writeAsStringSync(
          '  ${e.version} #${e.files.toString()}\n',
          mode: FileMode.append,
        );
        print('  ${e.version} #${e.files.toString()}');
      }
    });
  }
}

// afficher un résultat avec les differences, les en commun

class Dependency {
  Dependency({
    required this.namePub,
    required this.versions,
  });

  final String namePub;
  final List<DepVersion> versions;
}

class DepVersion {
  DepVersion(this.version, this.files);

  final String version;
  final List<String> files;
}

extension DependencyExtension on Dependency {
  Dependency update({
    required String file,
    required String version,
  }) {
    final tmpVersion = versions.firstWhereOrNull((v) => v.version == version);

    if (tmpVersion != null) {
      return Dependency(
        namePub: namePub,
        versions: [
          ...versions..remove(tmpVersion),
          tmpVersion..files.add(file),
        ],
      );
    } else {
      return Dependency(
        namePub: namePub,
        versions: [
          ...versions,
          DepVersion(version, [file]),
        ],
      );
    }
  }
}
