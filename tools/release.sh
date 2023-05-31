#!/bin/bash -e

# Script to automatic update release version number before publish.

if ! [ -d .git ]; then 
  printf "\nError: not in root of repo"; 
  exit
fi

if [ -z "$1" ]
  then
    echo "No argument supplied, enter new version number"
fi

version=$1
#update version in pubspec.yaml
sed -i '' "s/^version: .*/version: $version/" pubspec.yaml
#update version in version.dart
dart run build_runner build --delete-conflicting-outputs

#generate changelog 
changelog_cli generate --start `git describe --tags --abbrev=0` --printer markdown