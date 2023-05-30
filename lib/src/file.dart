import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

class FileHelper {
  FileHelper(String path, this._logger) {
    _file = File(path);
  }

  late final File _file;
  final Logger? _logger;
  int _indent = 0;

  void startSection() {
    _indent++;
  }

  void endSection() {
    _indent--;
  }

  void resetSection() {
    _indent = 0;
  }

  void write({
    required String message,
    bool append = true,
  }) {
    final padLeft = ''.padLeft(_indent);
    final fullMessage = '$padLeft$message';
    _file.writeAsStringSync(
      fullMessage,
      mode: append ? FileMode.append : FileMode.write,
    );
    _logger?.detail(fullMessage);
  }
}
