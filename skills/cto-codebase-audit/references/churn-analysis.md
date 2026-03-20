# Churn & Rework Analysis — Reference

## What is Churn?

Code churn = lines written then deleted (or heavily rewritten) within the same time window.
High churn ≠ bad (refactoring is healthy). High *unplanned* churn = wasted effort and instability.

---

## Churn Patterns & What They Mean

### Pattern 1: Hotspot Files
A file appears in 5+ commits in 2 weeks.

**Possible causes:**
- Core shared file with no clear ownership → coordinate with owner boundaries
- Unstable API or interface contract → needs a design decision, not more patches
- Bug magnet → the underlying design is wrong; patches won't fix it
- Active feature development → may be fine if tests are passing

**Action:** Diff the file from start to end of window. Is it converging (getting cleaner) or diverging (getting messier)?

---

### Pattern 2: High Rework Commit Rate (> 30%)

Commit messages containing: fix, revert, redo, oops, again, retry, attempt, broken, hotfix, patch, workaround

**Below 10%:** Healthy. Some fixes are always expected.
**10–20%:** Acceptable but worth watching.
**20–30%:** Process signal. Are PRs being reviewed before merge? Are specs clear before coding starts?
**> 30%:** Red flag. The team is shipping broken things and looping back. Root cause could be:
- Insufficient design upfront
- No or weak automated tests
- Unclear requirements / changing specs mid-sprint
- Code review happening too late (or not at all)

---

### Pattern 3: Revert Commits

A `git revert` means something was shipped, broke something, and had to be undone.

**1–2 reverts in 2 weeks:** Fine. Stuff happens.
**3–5 reverts:** Investigate what's being reverted. Is it the same area of the codebase?
**> 5 reverts:** The team is using production as a testing environment. Serious.

---

### Pattern 4: Modify → Revert → Modify Sequence

When the same file goes through: change → revert → change again within days.

This means the team couldn't agree on direction, or shipped something prematurely, reversed, then tried again.

**Single incident:** Acceptable.
**Recurring on same file:** The design of that component is contested or unclear. Needs an explicit decision, not more code.

---

### Pattern 5: Churn Concentrated on One Author

If 80%+ of churn is from one person, it could mean:
- That person is doing exploratory/spike work (fine if intentional)
- That person is struggling and iterating a lot without getting unstuck
- That person is the only one who touches that area (bus factor + quality risk)

---

## Healthy vs. Unhealthy Churn

| Type | Example | Verdict |
|---|---|---|
| Planned refactor | Rename + restructure module | ✅ Healthy |
| Test improvement | Add edge case coverage | ✅ Healthy |
| Spec-driven iteration | API response format changed mid-sprint | 🟡 Process issue |
| Bug fix loop | Fix → broke something → fix again | 🔴 Quality issue |
| Revert-heavy shipping | Ship, revert, re-ship in 48h | 🔴 Testing/review issue |
