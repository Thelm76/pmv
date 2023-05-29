import 'package:collection/collection.dart';
import 'package:pmv/entities/dependency.dart';

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
