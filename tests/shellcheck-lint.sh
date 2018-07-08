#!/bin/bash -e

# shellcheck disable=SC1090
source "$(dirname "$0")"/../scripts/resources.sh

for arg; do
  echo "-path ./$arg -prune -o"
  FOLDERSTOPRUNE="-path ./$arg -prune -o $FOLDERSTOPRUNE"
done

# shellcheck disable=SC2086
if find . $FOLDERSTOPRUNE -name '*.sh' -print0 | xargs -n1 -0 shellcheck -x -s bash; then
    test_passed "$0"
else
    test_failed "$0"
fi
