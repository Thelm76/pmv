import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pmv/src/command/analyze.dart';
import 'package:pmv/src/command/apply.dart';
import 'package:pmv/src/command/upgrade.dart';
import 'package:pmv/src/version.dart';

class PMVCliCommandRunner extends CompletionCommandRunner<int> {
  PMVCliCommandRunner({
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        super(
          'pmv',
          'CLI tool for managing pubspec package version',
        ) {
    addCommand(AnalyzeSubPackageCommand(_logger));
    addCommand(ApplySubPackageCommand(_logger));
    addCommand(UpgradeRootPackageCommand(_logger));
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Prints the version of pmv.',
    );
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Noisy logging, including all shell commands executed.',
    );
  }

  @override
  void printUsage() => _logger.info(usage);

  final Logger _logger;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);

      if (topLevelResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }

      if (topLevelResults['version'] == true) {
        _logger.info(packageVersion);
        return ExitCode.success.code;
      } else {
        return await runCommand(topLevelResults) ?? ExitCode.success.code;
      }
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);

      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);

      return ExitCode.usage.code;
    }
  }
}
