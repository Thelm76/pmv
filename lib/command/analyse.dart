import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:pmv/entities/dependency.dart';
import 'package:pmv/extensions/dependency.dart';
import 'package:pmv/file.dart';
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
  String get invocation => 'pmv analyse -o ./result.txt';

  @override
  Future<void> run() async {
    final output = argResults?['output'] as String;
    Map<String, Dependency> allDependencies = {};
    Map<String, Dependency> allDevDependencies = {};
    Map<String, Dependency> allOverrideDependencies = {};

    // Analyse dependencies
    final pubspecFiles = Glob(join('.', '**', 'pubspec.yaml'));
    for (final entity in pubspecFiles.listSync()) {
      final pubSpec = await PubSpec.loadFile(entity.path);
      final projectName = pubSpec.name ?? 'unknow';

      allDependencies = _analysePubFile(
        projectName: projectName,
        pubSpecDep: pubSpec.dependencies,
        old: allDependencies,
      );
      allDevDependencies = _analysePubFile(
          projectName: projectName,
          pubSpecDep: pubSpec.devDependencies,
          old: allDevDependencies);
      allOverrideDependencies = _analysePubFile(
        projectName: projectName,
        pubSpecDep: pubSpec.dependencyOverrides,
        old: allOverrideDependencies,
      );
    }

    // Write repport
    final file = FileHelper(output);
    file.write(message: 'Analyse of ${DateTime.now()}\n', append: false);
    file.write(
      message: '\ndependencies:\n',
    );

    await _writeReport(file, allDependencies);
    file.write(
      message: '\ndev_dependencies:\n',
    );
    await _writeReport(file, allDevDependencies);
    file.write(
      message: '\noverrides_dependencies:\n',
    );
    await _writeReport(file, allOverrideDependencies);
  }

  Map<String, Dependency> _analysePubFile({
    required String projectName,
    required Map<String, DependencyReference> pubSpecDep,
    Map<String, Dependency>? old,
  }) {
    // load pubSpec
    final dependencies = old ?? <String, Dependency>{};

    pubSpecDep.forEach((key, DependencyReference value) {
      if (value is! PathReference &&
          value is! SdkReference &&
          value is! GitReference) {
        final version = value.toString();
        dependencies.update(
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

    return dependencies;
  }

  Future<void> _writeReport(
    FileHelper file,
    Map<String, Dependency> dependencies,
  ) async {
    file.startSection();
    dependencies.forEach((key, value) {
      file.write(
        message: '$key:\n',
      );

      file.startSection();

      for (var e in value.versions) {
        file.write(
          message: '${e.version} #${e.files.toString()}\n',
        );
      }
      file.endSection();
    });
    file.endSection();
  }
}

// afficher un résultat avec les differences, les en commun





