#!/bin/bash
# ENV: INPUT_QMD_HASH_RULES
# ENV: INPUT_DEST_REPO_NAME
# ENV: INPUT_REPO_ACCESS_TOKEN

set -eo pipefail

git clone "https://a:$INPUT_REPO_ACCESS_TOKEN@github.com/$INPUT_DEST_REPO_NAME.git" /destrepo
IFS=';' HT_ENTRIES=($INPUT_QMD_HASH_RULES)
for entry in ${HT_ENTRIES[@]}
do
	IFS=',' FILEDECLS=($entry)
	HT=${FILEDECLS[0]}
	ROOT=${FILEDECLS[1]}
	mkdir -p "/destrepo/$ROOT"
	for file in ${FILEDECLS[@]:2}
	do
		cp "./$file" "/destrepo/$ROOT/$file"
		qmldiff hash-diffs "./$HT" "/destrepo/$ROOT/$file"
	done
done
cd /destrepo

git config --global user.email "qmldiff-action@example.com"
git config --global user.name "QMLDiff Hasher Action Bot"

if [ -z "$(git diff)" ]; then
	echo "No changes detected. Exiting."
	exit 0
fi

git add .
git commit -m "Pull state from private repo"
git remote set-url origin "https://a:$INPUT_REPO_ACCESS_TOKEN@github.com/$INPUT_DEST_REPO_NAME.git"
git push origin $(git rev-parse --abbrev-ref HEAD)
