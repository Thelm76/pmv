import 'dart:io';

class FileHelper {
  FileHelper(String path) {
    _file = File(path);
  }

  late final File _file;
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
    final String padLeft = ''.padLeft(_indent);
    _file.writeAsStringSync(
      '$padLeft$message',
      mode: append ? FileMode.append : FileMode.write,
    );
  }
}
