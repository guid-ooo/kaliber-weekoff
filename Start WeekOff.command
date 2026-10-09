#!/bin/zsh
cd "$(dirname "$0")"

APP="WeekOffBridge/build/WeekOffBridge.app"

if [[ ! -d "$APP" ]]; then
  echo "Bridge-app bouwen..."
  WeekOffBridge/build.sh || {
    osascript -e 'display alert "Bridge bouwen mislukt" message "Open Terminal en typ: xcode-select --install"'
    exit 1
  }
fi

open "WeekOff.key"
open "WeekOff/WeekOff.qlab5"
open "$APP"

echo "WeekOff gestart: Keynote, QLab en de bridge."
echo "De bridge draait in de menubalk (het ruit-icoon)."
echo "Kies daar de juiste presentatie. Dit venster mag dicht."
