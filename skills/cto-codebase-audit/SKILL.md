---
name: cto-codebase-audit
description: Audit engineering velocity, code quality, and team process by analyzing git history and repository activity.
---

# cto-codebase-audit

A structured workflow for analyzing a Git repository's recent activity to surface team velocity, code quality signals, bottleneck patterns, and actionable improvement recommendations — from a senior engineering leadership perspective.

## 1. Setup & Data Collection

### 1.1 Confirm Scope
Before running anything, confirm with the user:
- **Repo location**: path to local repo, or ask them to `cd` to it
- **Lookback window**: default is **14 days**; adjust if asked
- **Branches**: all branches with commits in the window, or a subset?
- **Team size**: approximate number of active contributors expected

### 1.2 Fetch & Sync All Branches

```bash
# Fetch all remote branches up to date
git fetch --all --prune

# List branches with commits in the past 14 days
git for-each-ref --sort=-committerdate refs/remotes/ \
  --format='%(refname:short) %(committerdate:relative)' \
  | awk '$2~/day|hour|minute|second/' | head -30
```

### 1.3 Extract Raw Commit Data

Run the following to get a structured log across all active branches:

```bash
# All commits across all branches, past 14 days, deduplicated
git log --all --since="14 days ago" \
  --pretty=format:'%H|%an|%ae|%ad|%s|%b' \
  --date=short \
  | sort -u -t'|' -k1,1
```

Save output to a temp file for analysis. Then collect diffs:

```bash
# Per-commit diff stats (files changed, insertions, deletions)
git log --all --since="14 days ago" \
  --pretty=format:'%H|%an|%ad' --date=short \
  --numstat \
  | tee /tmp/diff_stats.txt
```

## 2. Velocity Analysis

Compute and report the following metrics. See `references/metrics.md` for formulas and interpretation guidance.

| Metric | What it tells you |
|---|---|
| **Commits per dev per day** | Raw output signal |
| **Active days ratio** | Are people coding consistently or in bursts? |
| **Lines changed per commit** | Commit granularity — big blobs = risky |
| **PR/branch lifetime** | How long features sit before merge |
| **Merge frequency** | Integration health |
| **Commits per branch** | Feature scope discipline |

Flag if:
- Any developer has **0 commits** in the window → potential blocker or absence
- Avg commit size > **500 LOC** → likely not enough decomposition
- Branch age > **5 days** before any merge activity → integration risk

## 3. Rework & Churn Detection

This is the key signal for wasted effort and instability. Read `references/churn-analysis.md` for deeper patterns.

### 3.1 File Churn (hotspots)

```bash
# Files touched most frequently in the window
git log --all --since="14 days ago" --name-only --pretty=format: \
  | sort | uniq -c | sort -rn | head -20
```

Files appearing **5+ times** in 2 weeks are churn hotspots — likely unstable or over-contested.

### 3.2 Rework Signals in Commit Messages

Scan commit messages for rework language:

```bash
git log --all --since="14 days ago" --pretty=format:'%s' \
  | grep -iE 'fix|revert|redo|oops|again|retry|attempt|broken|hotfix|patch|workaround'
```

**Interpretation:**
- **> 30% of commits** contain rework language → serious process or quality issue
- **Revert commits** → features shipped before ready; insufficient review or testing
- **"hotfix" clusters** → reactive, not proactive quality culture

### 3.3 Back-and-Forth Pattern

Look for the same file being modified, then reverted, then modified again:

```bash
git log --all --since="14 days ago" --diff-filter=M --name-only --pretty=format:'%ad %s' \
  --date=short | grep -A1 'revert\|fix\|undo' | head -40
```

Flag any file that appears in a **modify → revert → modify** sequence within the window.

## 4. Code Quality Pillars

For each changed file in the window, assess against these pillars. Use `git diff` output and heuristics. Read `references/quality-rubric.md` for scoring guidance.

| Pillar | Key signals to look for |
|---|---|
| **Correctness** | Error handling absent, unchecked nulls, logic that doesn't match commit message intent |
| **Maintainability** | Functions > 50 lines, deeply nested logic (> 3 levels), no modularity |
| **Readability** | No comments on non-obvious code, inconsistent naming conventions, magic numbers |
| **Efficiency** | N+1 patterns, unindexed queries, synchronous blocking where async is needed |
| **Security** | Hardcoded secrets, unsanitized inputs, direct SQL string concat, missing auth checks |
| **Error Handling** | Bare `catch` blocks, silent failures, no logging |
| **Testability** | No tests added alongside new logic, test coverage clearly not updated |

Score each area **Red / Amber / Green** in the final report.

## 5. Commit Message Quality

Good commit messages are a leading indicator of team discipline and future maintainability.

Score each commit against this rubric:

- **Good**: Imperative mood, describes *what* and *why*, references ticket/issue if applicable. Example: `Fix race condition in payment processor (#341)`
- **Acceptable**: Vague but not misleading. Example: `Update auth service`
- **Poor**: One-word, past tense, or describes *what* without *why*. Example: `fixed`, `changes`, `wip`, `asdf`

```bash
# Show all commit messages for manual review
git log --all --since="14 days ago" --pretty=format:'%an | %ad | %s' --date=short
```

Report:
- % of commits rated Good / Acceptable / Poor
- Named examples of best and worst messages (without shaming individuals)

## 6. Team Dynamics Signals

Derive team health signals from the data — without needing 1:1s.

| Signal | How to detect |
|---|---|
| **Siloed contributors** | Files that only one person ever touches |
| **Bus factor risk** | Core files with single-author history |
| **Unbalanced load** | One dev with 5x the commits of others |
| **Knowledge concentration** | Same author on all high-churn files |
| **No peer review evidence** | All merges self-merged, no co-authors |

```bash
# Per-file author distribution
git log --all --since="14 days ago" --pretty=format:'%an' --name-only \
  | awk 'NF==1{author=$0} NF>1{print $0, author}' \
  | sort | uniq -c | sort -rn | head -30
```

## 7. Output Report Structure

Produce a structured written report. Tone: **direct, constructive, and leadership-ready** — this may go straight to a CTO or engineering board.

```
## Engineering Health Report — [Repo Name] — [Date Range]

### Executive Summary
2–3 sentences on the overall state: shipping velocity, quality risk level, and #1 priority action.

### Velocity
- Commits: X total, Y unique authors, Z avg per dev/day
- Active branches: N
- Avg branch lifetime: X days
- [Notable outliers]

### Rework & Churn
- Rework commit rate: X%
- Top 5 churn files: [list]
- Revert count: N
- [Back-and-forth incidents]

### Code Quality Scorecard
| Pillar | Score | Key Finding |
|---|---|---|
| Correctness | 🟡 Amber | ... |
| Maintainability | 🔴 Red | ... |
| ... | | |

### Commit Discipline
- Good: X% | Acceptable: Y% | Poor: Z%
- Best example: "..."
- Pattern to address: "..."

### Team Dynamics
- Bus factor risk: [files/areas]
- Load distribution: [balanced / skewed]
- Review culture signals: [present / absent]

### Bottlenecks Identified
Ranked list of the top 3–5 friction points slowing the team down, with evidence.

### Recommendations
For each bottleneck, one concrete, actionable recommendation:
1. **[Problem]** → [Action] — estimated effort: [Low/Med/High]
2. ...

### Conclusion
Overall rating: 🟢 Healthy / 🟡 Needs Attention / 🔴 At Risk
One paragraph summary and top priority for next sprint.
```

## 8. Tone & Delivery Guidelines

- **Be direct but not brutal.** Name problems clearly; don't bury them in qualifications.
- **Explain the *why*.** Don't just say "this file has high churn" — say what that implies.
- **Avoid naming individuals negatively.** Highlight patterns and systemic issues, not people.
- **Lead with what matters most.** Bury nitpicks. Surface blockers and risks first.
- **Give credit.** If velocity is strong or a module is well-structured, say so explicitly.
- **Be specific.** Vague feedback ("code could be cleaner") is worthless. Point to evidence.

## Reference Files

Load these as needed during analysis:

- `references/metrics.md` — Velocity metric formulas and benchmarks
- `references/churn-analysis.md` — Deep patterns for rework and instability detection  
- `references/quality-rubric.md` — Scoring guide for the 7 code quality pillars
