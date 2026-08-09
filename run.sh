#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$DIR/bin/release/ygopro" -C "$DIR" "$@"