---
name: make-release
description: >
  Runs the full release pipeline for npm projects using CalVer versioning. ONLY
  triggers when the user types the exact slash command `/make-release`. Do NOT
  trigger for general changelog questions, version inquiries, or casual mentions
  of releasing. When `/make-release` is issued: reads git history since the last
  release, determines whether this is a major (new year/month) or patch bump,
  runs `npm version` with the computed CalVer string, and prepends a new
  business-oriented entry to CHANGELOG.md.
---

# make-release

Full release pipeline for npm projects versioned with CalVer.

**Trigger:** Only the exact user command `/make-release`. Ignore all other phrasings.

---

## CalVer Format

```
YYYY.M.PATCH
```

- `YYYY` — full year (e.g. `2026`)
- `M` — month without leading zero (e.g. `4`, not `04`)
- `PATCH` — incrementing integer starting at `0`, resets to `0` on new month/year

**Examples:** `2026.3.0`, `2026.3.1`, `2026.4.0`

---

## Step 1 — Preflight checks

```bash
# Must be an npm project
[ -f package.json ] || { echo "NO_PACKAGE_JSON"; exit 1; }

# Must be a git repo with a clean working tree
git rev-parse --show-toplevel 2>/dev/null || { echo "NOT_GIT_REPO"; exit 1; }
git diff --quiet && git diff --cached --quiet || echo "DIRTY_WORKING_TREE"

# Current version in package.json
node -p "require('./package.json').version"

# Last git tag
git tag --sort=-version:refname | head -5
```

If `NO_PACKAGE_JSON` → abort and tell the user this skill is for npm projects only.  
If `NOT_GIT_REPO` → abort and ask for the correct directory.  
If `DIRTY_WORKING_TREE` → warn the user and ask whether to proceed anyway.

---

## Step 2 — Determine the new CalVer version

```bash
# Today's date parts
YEAR=$(date +%Y)
MONTH=$(date +%-m)   # no leading zero

# Current version from package.json
CURRENT=$(node -p "require('./package.json').version")
# e.g. "2026.3.1"

CUR_YEAR=$(echo $CURRENT | cut -d. -f1)
CUR_MONTH=$(echo $CURRENT | cut -d. -f2)
CUR_PATCH=$(echo $CURRENT | cut -d. -f3)
```

**Version bump logic:**

| Condition | Result |
|-----------|--------|
| Current year/month differ from today | New `YYYY.M.0` — **major bump** |
| Same year and month | Increment patch: `YYYY.M.(PATCH+1)` — **patch bump** |

Compute and display the proposed version before doing anything else.

---

## Step 3 — Analyze changes since last release

```bash
LAST_TAG=$(git tag --sort=-version:refname | head -1)

if [ -n "$LAST_TAG" ]; then
  git log "$LAST_TAG"..HEAD --pretty=format:"%s|%b" --no-merges
else
  # First release — include all commits
  git log --pretty=format:"%s|%b" --no-merges
fi
```

Also check for file-level changes to understand scope:

```bash
git diff "$LAST_TAG"..HEAD --stat 2>/dev/null | tail -5
```

---

## Step 4 — Write business-oriented changelog entries

This is the most important step. Think like a **product manager**, not a developer.

**Rules:**
- Write for the **end user or business stakeholder**, not the engineer
- Describe **outcomes and capabilities**, not implementation
- Omit: refactors, dependency bumps, test changes, CI tweaks, formatting — unless they have user-visible impact
- Group related commits into a single coherent bullet
- Use plain language; no jargon, no file names, no function names
- Start each bullet with a past-tense verb: *Added, Fixed, Improved, Removed, Enabled*

**Transformation examples:**

| Raw commit | Business entry |
|------------|----------------|
| `fix: null ptr deref in UserAuthService.validateToken()` | Fixed a crash that occurred during login when a session expired |
| `feat: add CSV export to /reports endpoint` | Added CSV export to the Reports page |
| `perf: lazy-load chart components on dashboard` | Improved dashboard load speed |
| `refactor: split UserService into auth + profile modules` | *(omit — no user-visible change)* |
| `chore: bump lodash 4.17.20 -> 4.17.21` | *(omit — unless it fixed a security vuln)* |

Categorize entries into sections (only include sections that have entries):

```
### Added
### Improved  
### Fixed
### Removed
```

---

## Step 5 — Show the release plan and confirm

Present a clear summary **before making any changes**:

```
📦 Release Plan
───────────────────────────────
Current version : 2026.3.1
New version     : 2026.4.0  (new month — major bump)
Commits analyzed: 14  (9 user-facing, 5 omitted)

### Added
- Added bulk CSV export to the Reports dashboard
- Enabled email notifications for order status changes

### Fixed
- Fixed a crash during login when the session had expired
- Fixed incorrect totals on the monthly summary report

───────────────────────────────
Proceed with release? (yes / adjust entries / cancel)
```

Wait for explicit confirmation before continuing.

---

## Step 6 — Execute the release

Only after the user confirms:

```bash
# 1. Bump version in package.json (and package-lock.json if present)
#    --no-git-tag-version because we'll tag manually after the changelog is written
npm version <NEW_VERSION> --no-git-tag-version

# 2. Write CHANGELOG.md
# Prepend the new entry below the top-level header, preserving all prior content
```

**CHANGELOG.md format:**

```markdown
# Changelog

## [2026.4.0] - 2026-04-01

### Added
- Added bulk CSV export to the Reports dashboard
- Enabled email notifications for order status changes

### Fixed
- Fixed a crash during login when the session had expired
- Fixed incorrect totals on the monthly summary report

---

## [2026.3.1] - 2026-03-15
...existing entries preserved exactly...
```

Write strategy:
- If `CHANGELOG.md` exists: read it, insert the new block immediately after the `# Changelog` heading, write the file back
- If it doesn't exist: create it with just the new block and the heading

```bash
# 3. Stage both changed files
git add package.json package-lock.json CHANGELOG.md

# 4. Commit
git commit -m "chore: release <NEW_VERSION>"

# 5. Tag
git tag <NEW_VERSION>
```

---

## Step 7 — Report completion

```
✅ Released 2026.4.0
   • package.json updated
   • CHANGELOG.md updated (4 entries)
   • Git commit: chore: release 2026.4.0
   • Git tag: 2026.4.0

Next: git push && git push --tags
```

Remind the user to push the commit and tags if they haven't set up automatic pushing.

---

## Edge Cases

| Situation | Behavior |
|-----------|----------|
| No prior tags | Treat all commits as the first release; version = `YYYY.M.0` |
| No user-facing commits | Warn: "No user-visible changes found. Still release?" |
| `package-lock.json` absent | Skip staging it; proceed normally |
| Version in package.json is not CalVer | Warn and confirm before overwriting |
| First release ever | Create CHANGELOG.md fresh; version = current `YYYY.M.0` |
