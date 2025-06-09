#!/bin/sh

DEST="$HOME/.local/share/man/man99"

mkdir -p "$DEST"
cp -u "./man99/"* "$DEST"
mandb "$HOME/.local/share/man"
echo "Kick'N'Vim manpages installed to $DEST"

