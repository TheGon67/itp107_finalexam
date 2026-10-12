#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v flutter >/dev/null || { echo 'Install Flutter and add flutter/bin to PATH first.'; exit 1; }
dart tool/setup.dart
