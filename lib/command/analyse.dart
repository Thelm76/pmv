import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';

class AnalyseSubPackageCommand extends Command<void> {
  AnalyseSubPackageCommand() {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The path of the output file.',
      defaultsTo: './packages.yaml',
    );
  }

  @override
  String get name => 'analyse';

  @override
  String get description => 'Analyse package version in sub pubspec';

  @override
  String get invocation => 'analyse -o ./result.txt';

  @override
  Future<void> run() async {
    final output = argResults?['output'] as String;

    final pubspecFiles = Glob(join('.', '**', 'pubspec.yaml'));
    for (final entity in pubspecFiles.listSync()) {
      await _analysePubFile(path: entity.path);
    }
  }
}

Future<void> _analysePubFile({required String path}) async {
  print(path);
}
