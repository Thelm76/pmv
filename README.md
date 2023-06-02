# PMV

[![CI](https://github.com/Chonli/pmv/actions/workflows/publish_test.yaml/badge.svg)](https://github.com/Chonli/pmv/actions/workflows/publish_test.yaml)  [![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

---

PMV is a CLI tool used to help manage package version in Dart projects with multiple packages (also known as mono-repos). With PMV you can analyze you projet dependency and apply a reference version quickly. 

## Commands
- You have a command to analyze your project and extract all dependencies, the different version used and where they are used.
```dart
pmv analyze -o result.txt
```
- You have a command to apply a reference pubspec package version in all sub pubspec.
```dart
pmv apply -s pmv_pubspec.yaml
```

- You have a command to upgrade package of reference pubspec at last version.
```dart
pmv upgrade -s pmv_pubspec.yaml
```

#### TODO
- Add test
