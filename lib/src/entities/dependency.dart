class Dependency {
  Dependency({
    required this.namePub,
    required this.versions,
  });

  final String namePub;
  final List<DepVersion> versions;
}

class DepVersion {
  DepVersion(this.version, this.files);

  final String version;
  final List<String> files;
}
