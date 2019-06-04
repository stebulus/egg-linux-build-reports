#!/bin/bash
set -euo pipefail
here=$(dirname "${BASH_SOURCE[0]}")
me=$(basename "${BASH_SOURCE[0]}")
report_dir=$1

tmp=$(mktemp -dt "$me".XXXXXXXX)
trap 'rm -rf "$tmp"' EXIT

"$here"/flatten "$report_dir" >"$tmp"/table
sed 1d "$tmp"/table >"$tmp"/table-data-only
head -n1 "$tmp"/table |
tr '\t/-' '\n__' |
awk -v tmp="$tmp" '
  BEGIN { print "create table build (" }
  NR > 1 { print "," }
  { print $0 " varchar" }
  END {
    print ");"
    print ".mode tabs"
    print ".import " tmp "/table-data-only build"
  }
  ' >"$tmp"/sql-script

sqlite3 -init "$tmp"/sql-script
