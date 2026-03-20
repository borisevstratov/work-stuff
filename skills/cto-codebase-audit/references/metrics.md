# Velocity Metrics — Reference

## Formulas

### Commits Per Dev Per Day
```
total_commits / unique_authors / days_in_window
```
**Benchmarks:**
- < 0.5 → Very low. Likely blocked, context-switching, or heavy PR review overhead.
- 0.5–1.5 → Normal for teams doing meaningful feature work with review cycles.
- 1.5–3 → High velocity. Healthy if commit size is small; concerning if commits are huge.
- > 3 → Either excellent decomposition or chaotic thrash. Dig into commit sizes.

### Active Days Ratio
```
days_with_at_least_one_commit / total_working_days_in_window
```
**Benchmarks:**
- < 0.4 → Burst coding pattern — long gaps, then floods. Risky for integration.
- 0.4–0.7 → Moderate consistency.
- > 0.7 → Good flow state. Team is shipping incrementally.

### Avg Lines Changed Per Commit
```
(total_insertions + total_deletions) / total_commits
```
**Benchmarks:**
- < 50 LOC → Excellent granularity. Easy to review and revert.
- 50–200 LOC → Acceptable for feature work.
- 200–500 LOC → Getting large. Risk of review fatigue.
- > 500 LOC → Red flag. Hard to review, easy to miss bugs, hard to revert.

### Branch Lifetime
```
date_of_last_commit_on_branch - date_of_first_commit_on_branch
```
**Benchmarks:**
- < 1 day → Same-day ships. Fine for hotfixes; concerning as a pattern for features.
- 1–3 days → Healthy feature cadence.
- 3–7 days → Acceptable.
- > 7 days → Long-lived branch. Merge conflict risk increases. Why is it open so long?

### Merge Frequency
```
total_merges / days_in_window
```
**Benchmarks:**
- < 0.5/day → Integration is infrequent. Risk of divergence.
- 1–2/day → Healthy continuous integration.
- > 3/day → High-frequency shipping. Great if tests are solid.

---

## Interpreting Outliers

**One dev with 3x average commits:**
Could mean: star performer, OR scope dumping on one person, OR others are blocked.
Action: Cross-check with branch and file distribution.

**Zero commits from expected contributor:**
Could mean: on leave, blocked waiting for review, deep in design/planning, or disengaged.
Action: Note without assuming — surface as a question for the team lead.

**Spike then silence:**
Could mean: deadline crunch followed by burnout, or a branch that merged and dev rotated off.
Action: Look at branch lifecycle to confirm.
