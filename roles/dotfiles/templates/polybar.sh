#!/bin/bash

#
# Script to launch polybar on multiple monitors.
# It sets env var MONITOR that is used in polybar config.
# This script is used in i3 config as a launcher.

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done
