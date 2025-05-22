This is a simple GitHub action for hashing QMLDiff files.

Usage example:

Create a file `.github/workflow/publish.yml` in your private repository, where you keep your unhashed QMD files with the following contents:

```
name: 'hash-files'
on: push
jobs:
    main:
        name: 'Update the public-facing repo'
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v3
            - uses: asivery/qmldiff-hasher-action@v1
              name: 'Run the action'
              with:
                qmd_hash_rules: 'hashtab-file,path-in-destrepo,file1.qmd,file2.qmd....;hashtab-file-2;path-in-destrepo-2,file1.qmd,file3.qmd'
                dest_repo_name: 'yourusername/yourpublicrepo'
                repo_access_token: 'github_pat_YOUR_PAT_GITHUB_TOKEN_WITH_PRIVILEGES_TO_EDIT_DESTREPO'
```

Don't forget to also add and commit the hashtab files themselves. They are not supplied by this action!

The `qmd_hash_rules` value consists of one or more hashtab-dependent entries separated with a semicolon. Every entry consists of the path of the hashtab, followed by where the files will be copied to in the dest repo, and then the list of files. All comma-separated.


