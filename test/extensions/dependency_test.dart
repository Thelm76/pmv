import 'package:pmv/src/entities/dependency.dart';
import 'package:pmv/src/extensions/dependency.dart';
import 'package:test/test.dart';

void main() {
  const version1 = 'version1';
  const version2 = 'version2';

  test('Test update files on existing version', () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          version1,
          ['file1'],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, false);

    final result = fakeDependency.update(file: 'file4', version: version1);

    expect(result.isMultiFile, true);
    expect(result.namePub, fakeDependency.namePub);
    expect(result.versions.length, 1);
    expect(result.versions.first.version, version1);
    expect(result.versions.first.files.length, 2);
    expect(result.versions.first.files.contains('file4'), true);
  });

  test('Test update files on existing version with multiple version', () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          version1,
          ['file1'],
        ),
        DepVersion(
          version2,
          ['file2', 'file4'],
        ),
        DepVersion(
          'version 3',
          ['file3'],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, true);

    final result = fakeDependency.update(file: 'file4', version: version1);

    expect(result.isMultiFile, true);
    expect(result.namePub, fakeDependency.namePub);
    expect(result.versions.length, 3);

    final depVer = result.versions.firstWhere((dep) => dep.version == version1);
    expect(depVer.files.length, 2);
    expect(depVer.files.contains('file4'), true);
  });

  test('Test add version on update dependency', () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          version1,
          ['file1'],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, false);
    expect(fakeDependency.versions.length, 1);

    final result = fakeDependency.update(file: 'file4', version: version2);

    expect(result.isMultiFile, true);
    expect(result.namePub, fakeDependency.namePub);
    expect(result.versions.length, 2);

    final depVer2 =
        result.versions.firstWhere((dep) => dep.version == version2);
    expect(depVer2.files.length, 1);
    expect(depVer2.files.first, 'file4');
  });
}
