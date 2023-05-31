import 'package:pmv/src/entities/dependency.dart';
import 'package:test/test.dart';

void main() {
  test('Test case multi file return true with one version in multiple file',
      () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          "version1",
          ["file1", "file2", "file3"],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, true);
  });

  test('Test case multi file return true with multiple version in 1 file', () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          "version1",
          ["file1"],
        ),
        DepVersion(
          "version3",
          ["file7"],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, true);
  });

  test('Test case multi file return false with only 1 version on 1 file', () {
    final fakeDependency = Dependency(
      namePub: 'name',
      versions: [
        DepVersion(
          "version1",
          ["file1"],
        ),
      ],
    );

    expect(fakeDependency.isMultiFile, false);
  });
}
