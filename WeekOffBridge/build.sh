#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

NAME=WeekOffBridge
OUT=build
APP="$OUT/$NAME.app"

swift build -c release --scratch-path "$OUT"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Resources/Info.plist "$APP/Contents/Info.plist"
cp "$OUT/release/$NAME" "$APP/Contents/MacOS/$NAME"
codesign --force --sign - "$APP"

echo "built $APP"
