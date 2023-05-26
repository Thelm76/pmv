import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pmv/command/analyse.dart';

void main(List<String> args) {
  final bool verbose = args.contains('-v') || args.contains('--verbose');

  final CommandRunner<void> runner = CommandRunner<void>(
      'pmv', 'CLI tool for managing pubspec package version')
    ..addCommand(AnalyseSubPackageCommand())
    ..argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Noisy logging, including all shell commands executed.',
    );

  runner.run(args).catchError((dynamic error, StackTrace stackTrace) {
    if (error is UsageException) {
      print(
        error.message,
      );
      exit(64);
    } else {
      print(error);
      throw error as Object;
    }
  });
}
