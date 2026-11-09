#!/usr/bin/env bash
# Run from any directory: bash tool/check.sh
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test
