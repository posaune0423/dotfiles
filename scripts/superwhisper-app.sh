#!/bin/sh
# Query, quit, and launch the Superwhisper app.
#
# A running Superwhisper keeps its settings in memory and writes them back to
# settings/settings.json, so a file written while it runs is overwritten with
# its stale state. superwhisper-settings.sh and install.sh stop it through this
# script before they write, and start it again afterwards. Tests replace this
# script through SUPERWHISPER_APP_CTL.
set -eu

BUNDLE_ID="com.superduper.superwhisper"
PROCESS="superwhisper"

running() {
  pgrep -x "$PROCESS" > /dev/null 2>&1
}

case "${1:-}" in
  running)
    running
    ;;
  quit)
    running || exit 0
    osascript -e "tell application id \"$BUNDLE_ID\" to quit" > /dev/null
    # The app saves its settings while it quits; wait until it has exited.
    tries=0
    while running; do
      tries=$((tries + 1))
      if [ "$tries" -gt 40 ]; then
        echo "superwhisper-app: Superwhisper did not quit within 10 seconds" >&2
        exit 1
      fi
      sleep 0.25
    done
    ;;
  launch)
    open -g -b "$BUNDLE_ID"
    ;;
  *)
    echo "Usage: superwhisper-app.sh running|quit|launch" >&2
    exit 2
    ;;
esac
