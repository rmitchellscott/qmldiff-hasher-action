#!/bin/bash
# ENV: INPUT_QMD_HASH_RULES
# ENV: INPUT_DEST_REPO_NAME
# ENV: INPUT_REPO_ACCESS_TOKEN
# ENV: INPUT_COMMIT_MESSAGE (optional)

set -eo pipefail

git clone "https://a:$INPUT_REPO_ACCESS_TOKEN@github.com/$INPUT_DEST_REPO_NAME.git" /destrepo
IFS=';' HT_ENTRIES=($INPUT_QMD_HASH_RULES)
for entry in ${HT_ENTRIES[@]}
do
	IFS=',' FILEDECLS=($entry)
	HT=${FILEDECLS[0]}
	ROOT=${FILEDECLS[1]}
	for file in ${FILEDECLS[@]:2}
	do
        mkdir -p "$(dirname "/destrepo/$ROOT/$file")"
		cp "./$file" "/destrepo/$ROOT/$file"
		VERSION=$(grep "^VERSION " "/destrepo/$ROOT/$file" | awk '{print $2}') || true
		qmldiff hash-diffs "./$HT" "/destrepo/$ROOT/$file"
		[ -n "$VERSION" ] && sed -i "s/\[\[17607111715072197239\]\]/$VERSION/g" "/destrepo/$ROOT/$file"
	done
done
cd /destrepo

git config --global user.email "qmldiff-action@example.com"
git config --global user.name "QMLDiff Hasher Action Bot"

git add .

if [ -z "$(git diff --cached)" ]; then
	echo "No changes detected. Exiting."
	exit 0
fi

if [ -z "$INPUT_COMMIT_MESSAGE" ]; then
	COMMIT_MSG="Update hashed files - $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
else
	COMMIT_MSG="$INPUT_COMMIT_MESSAGE"
fi
git commit -m "$COMMIT_MSG"
git remote set-url origin "https://a:$INPUT_REPO_ACCESS_TOKEN@github.com/$INPUT_DEST_REPO_NAME.git"
git push origin $(git rev-parse --abbrev-ref HEAD)
