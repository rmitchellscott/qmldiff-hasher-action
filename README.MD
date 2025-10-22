This is a simple GitHub action for hashing QMLDiff files.

## Usage

Create a file `.github/workflow/publish.yml` in your private repository, where you keep your unhashed QMD files with the following contents:

```yaml
name: 'hash-files'
on: push
jobs:
    main:
        name: 'Update the public-facing repo'
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v3
            - uses: rmitchellscott/qmldiff-hasher-action@v1
              name: 'Run the action'
              with:
                qmd_hash_rules: 'hashtab-file,path-in-destrepo,file1.qmd,file2.qmd....;hashtab-file-2;path-in-destrepo-2,file1.qmd,file3.qmd'
                dest_repo_name: 'yourusername/yourpublicrepo'
                repo_access_token: 'github_pat_YOUR_PAT_GITHUB_TOKEN_WITH_PRIVILEGES_TO_EDIT_DESTREPO'
```

## Inputs

### `qmd_hash_rules` (required)
The QMD hashing rules. Format consists of one or more hashtab-dependent entries separated with a semicolon. Every entry consists of the path of the hashtab, followed by where the files will be copied to in the dest repo, and then the list of files. All comma-separated.

Example: `'hashtab-file,path-in-destrepo,file1.qmd,file2.qmd;hashtab-file-2,path-in-destrepo-2,file1.qmd,file3.qmd'`

### `dest_repo_name` (required)
The name of the destination, public repo (e.g., `user/repository`)

### `repo_access_token` (required)
The token to use when pushing to the public repo (e.g., a GitHub PAT with write permissions to the destination repo)

### `commit_message` (optional)
Custom commit message for the destination repo. If not provided, defaults to a timestamp-based message.

Examples:
```yaml
# Use a custom static message
commit_message: 'Update hashed QMD files'

# Use the commit message from the triggering commit
commit_message: ${{ github.event.head_commit.message }}

# Combine commit info
commit_message: 'Update from ${{ github.sha }}: ${{ github.event.head_commit.message }}'
```

## Notes

- Don't forget to also add and commit the hashtab files themselves. They are not supplied by this action!
