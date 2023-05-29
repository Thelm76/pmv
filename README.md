# PMV

PMV is a CLI tool used to help manage package version in Dart projects with multiple packages (also known as mono-repos).

## Commands
- You have a command to analyse your project and extract all dependencies, the different version used and where they are used.
```dart
pmv analyse -o result.txt
```
- You have a command to apply a specific package version in all sub pubspec.
```dart
pmv apply -s pmv_pubspec.yaml
```

## Install
This tool is not already distribute on pub.dev but you can install with the following commands:
```dart
git clone "https://github.com/Chonli/pmv"
cd pmv
dart pub global activate --source path .
```

#### TODO
- Improve log trace (mason_logger ?)
- Add CI
- Add test
- Add option on package show in analyse command
- Add command to update package in root pubspec to last version.
