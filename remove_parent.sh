#!/bin/bash
# add a parent commit to the specified commit, ideal
# for establishing the other parent of a squashed merge
# lifted from https://stackoverflow.com/a/41243690/2860309

# usage: ./add_parent.sh TARGET_COMMIT_ID REMOVE_PARENT_COMMIT_ID

set -ex

target_commit=$1
parent_to_remove=$2

echo "Removing parent ${parent_to_remove} from ${target_commit}..."

# Get the current parents of the target commit
current_parents=$(git show --pretty=%P -s $target_commit)

# Remove the additional_parent from the list of parents
new_parents=$(echo $current_parents | sed "s/$parent_to_remove//g" | tr -s ' ')

echo "new parents: $new_parents"

git replace --graft $target_commit $new_parents

# Push the replaced commit to the origin
echo "Pushing the replaced commit to the origin..."
git push origin +refs/replace/${target_commit}

# Verify the replacement
echo "Verifying the replacement..."
git log --pretty=format:'%H %P' -n 1 ${target_commit}

echo "Parent removal and push completed successfully."

echo "Other users should run the following command to update their local clones:"
echo "git fetch origin 'refs/replace/*:refs/replace/*'"
