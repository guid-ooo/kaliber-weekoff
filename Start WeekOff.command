#!/bin/zsh
cd "$(dirname "$0")"

if ! command -v python3 >/dev/null; then
  osascript -e 'display alert "Python ontbreekt" message "Open Terminal en typ: xcode-select --install"'
  exit 1
fi

open "WeekOff.key"
open "WeekOff/WeekOff.qlab5"

echo "Wachten tot Keynote de presentatie geopend heeft..."
until osascript -e 'tell application "Keynote" to count of documents' 2>/dev/null | grep -qv '^0$'; do
  sleep 1
done

clear
echo "=============================================="
echo "  WeekOff bridge draait (Keynote -> QLab)."
echo "  Sluit dit venster om te stoppen."
echo "=============================================="
echo

exec python3 assets/keynote_dmx_bridge.py
