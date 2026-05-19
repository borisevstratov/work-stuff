## Git branches cleanup

Add an alias:

```
git config --global alias.cleanup '!git fetch -p && git remote update origin --prune && bunx git-removed-branches --prune --force'
```

Now you can just run:

```bash
git cleanup
```

## Update npm packages

```bash
npx -y npm-check-updates --format group --interactive --packageManager npm
bunx -y npm-check-updates --format group --interactive --packageManager bun
```

You can make aliases for that

```bash
alias ncu='npx -y npm-check-updates --format group --interactive --packageManager npm'
alias bcu='bunx -y npm-check-updates --format group --interactive --packageManager bun'
```