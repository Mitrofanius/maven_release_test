#!/bin/bash
set -e

VERSION_INCREASE_TYPE=$1

if [ -z "$VERSION_INCREASE_TYPE" ]; then
  echo "Usage: $0 <patch|minor|major>"
  exit 1
fi


CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed 's/-SNAPSHOT//')
echo "Current development version: $CURRENT_VERSION"

IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"

case "$VERSION_INCREASE_TYPE" in
major)
 RELEASE_VERSION="$((major + 1)).0.0"
 NEXT_VERSION="$((major + 1)).0.1"
 ;;
minor)
 RELEASE_VERSION="${major}.$((minor + 1)).0"
 NEXT_VERSION="${major}.$((minor + 1)).1"
 ;;
patch)
 RELEASE_VERSION=$CURRENT_VERSION
 NEXT_VERSION="${major}.${minor}.$((patch + 1))"
 ;;
esac

echo "release_version=$RELEASE_VERSION" >> $GITHUB_OUTPUT
echo "next_version=$NEXT_VERSION" >> $GITHUB_OUTPUT
