#!/bin/bash

MOTD_FILE="/etc/motd.d/00-updates"

# Check, if the motd.d exists
DIRNAME=$(dirname "${MOTD_FILE}")

if [[ ! -d "${DIRNAME}" ]]; then
    mkdir -p "${DIRNAME}"
fi

# Execute checkupdates
UPDATES=$(export PACMAN_COLOR=1; checkupdates)

if [[ -n "$UPDATES" ]]; then
    echo "Folgende Pakete können aktualisiert werden:" > "$MOTD_FILE"
    echo "$UPDATES" >> "$MOTD_FILE"
else
    # If no updates are available clear the file
    > "$MOTD_FILE"
fi
