## Git branches cleanup

Add an alias:

```
git config --global alias.cleanup'!git fetch -p && git remote update origin --prune && bunx git-removed-branches --prune --force'
```

Now you can just run:

```bash
git cleanup
```