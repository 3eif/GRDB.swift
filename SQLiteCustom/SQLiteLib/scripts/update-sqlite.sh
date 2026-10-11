#!/bin/sh

# Regenerates sqlite3.c and sqlite3.h from an SQLite canonical source release.
#
# Usage: scripts/update-sqlite.sh <year> <version-number> <check-in>
#
# Take the three values from the release's page under
# https://www.sqlite.org/releaselog/: the year of its date, its version number
# in download form (3.53.4 is 3530400), and the hash in its SQLITE_SOURCE_ID.
# For example:
#
#   scripts/update-sqlite.sh 2026 3530400 bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc
#
# The amalgamation published on sqlite.org cannot honor
# SQLITE_ENABLE_UPDATE_DELETE_LIMIT, which SQLiteLib.xcconfig sets, because
# that option changes the generated parser. This script generates a parser
# with SQLITE_UDL_CAPABLE_PARSER, so the compile-time option decides.

set -eu

if [ "$#" -ne 3 ]; then
    echo "usage: $0 <year> <version-number> <check-in>" >&2
    exit 64
fi

year="$1"
version="$2"
expected_checkin="$3"
destination="$(cd "$(dirname "$0")/.." && pwd)"
archive="sqlite-src-${version}.zip"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

echo "Downloading ${archive}"
curl --fail --silent --show-error --location \
    --output "${work}/${archive}" "https://www.sqlite.org/${year}/${archive}"
unzip -q "${work}/${archive}" -d "$work"
source_dir="${work}/sqlite-src-${version}"

mkdir "${work}/build"
cd "${work}/build"

echo "Generating the amalgamation"
"${source_dir}/configure" --disable-tcl >configure.log
make sqlite3.c OPTS=-DSQLITE_UDL_CAPABLE_PARSER >make.log

# src-verify hashes every file listed in the release manifest and prints the
# check-in that the manifest itself hashes to, followed by any altered files.
verification="$(./src-verify -x "$source_dir" | sed '/^$/d')"
if [ "$verification" != "$expected_checkin" ]; then
    echo "error: the sources do not match check-in ${expected_checkin}:" >&2
    echo "$verification" >&2
    exit 1
fi

if ! grep -q '^#define SQLITE_UDL_CAPABLE_PARSER 1$' sqlite3.c; then
    echo "error: the generated parser does not support SQLITE_ENABLE_UPDATE_DELETE_LIMIT" >&2
    exit 1
fi

cp sqlite3.c sqlite3.h "$destination/"
echo "Updated ${destination}/sqlite3.c and sqlite3.h to $(sed -n 's/^#define SQLITE_VERSION  *"\(.*\)"$/\1/p' sqlite3.h)"
