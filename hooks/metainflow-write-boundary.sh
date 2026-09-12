#!/bin/sh
set -eu
target=${1:-}
[ -n "$target" ] || exit 2
target=$(python3 -c 'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' "$target")
runtime=$(python3 -c 'import os; print(os.path.realpath(os.path.expanduser("~/.metainflow")))')
workspace=$(python3 -c 'import os; print(os.path.realpath(os.path.expanduser("~/MetaInFlow")))')
case "$target" in
  "$runtime"|"$runtime"/*|"$workspace"|"$workspace"/*) exit 0 ;;
  *) exit 1 ;;
esac
