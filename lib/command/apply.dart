import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:pubspec/pubspec.dart';

class ApplySubPackageCommand extends Command<void> {
  ApplySubPackageCommand() {
    argParser.addOption(
      'source',
      abbr: 's',
      help: 'The path of the source file (pmv_pubspec.yaml by default).',
      defaultsTo: './pmv_pubspec.yaml',
    );
  }

  @override
  String get name => 'apply';

  @override
  String get description =>
      'Apply package version specify in pmv_pubspec.yaml in sub pubspec';

  @override
  String get invocation => 'pmv apply -s ./pmv_pubspec.yaml';

  @override
  Future<void> run() async {
    final rootFile = argResults?['source'] as String;

    //Read the root pubspec
    final rootPubSpec = await PubSpec.loadFile(rootFile);

    //Apply version to sub pubspec
    final pubspecFiles = Glob(join('.', '**', 'pubspec.yaml'));
    for (final entity in pubspecFiles.listSync()) {
      final pubSpec = await PubSpec.loadFile(entity.path);

      rootPubSpec.dependencies.forEach((key, rootDep) {
        if (pubSpec.dependencies.containsKey(key)) {
          pubSpec.dependencies.update(
            key,
            (_) => rootDep,
          );
        }
      });

      rootPubSpec.devDependencies.forEach((key, rootDep) {
        if (pubSpec.devDependencies.containsKey(key)) {
          pubSpec.devDependencies.update(
            key,
            (_) => rootDep,
          );
        }
      });

      rootPubSpec.dependencyOverrides.forEach((key, rootDep) {
        if (pubSpec.dependencyOverrides.containsKey(key)) {
          pubSpec.dependencyOverrides.update(
            key,
            (_) => rootDep,
          );
        }
      });

      //Update yaml file
      pubSpec.save(entity.parent);
    }
  }
}
