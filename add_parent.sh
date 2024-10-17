#!/bin/bash
# add a parent commit to the specified commit, ideal
# for establishing the other parent of a squashed merge
# lifted from https://stackoverflow.com/a/41243690/2860309

# usage: ./add_parent.sh TARGET_COMMIT_ID NEW_PARENT_COMMIT_ID

set -ex

target_commit=$1
additional_parent=$2

git replace --graft $target_commit \
    $(git show --pretty=%P $target_commit | head -n1) \
    $additional_parent
