class Dependency {
  Dependency({
    required this.namePub,
    required this.versions,
  });

  final String namePub;
  final List<DepVersion> versions;

  bool get isMultiFile =>
      versions.length > 1 ||
      versions.any(
        (dep) => dep.files.length > 1,
      );
}

class DepVersion {
  DepVersion(this.version, this.files);

  final String version;
  final List<String> files;
}
