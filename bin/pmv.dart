import 'package:pmv/src/command_runner.dart';

Future<void> main(List<String> args) async {
  await PMVCliCommandRunner().run(args);
}
