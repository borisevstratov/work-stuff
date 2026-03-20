# Code Quality Rubric — Reference

Score each pillar: 🟢 Green / 🟡 Amber / 🔴 Red

---

## 1. Correctness

**Green:** Code does what the commit message claims. Error paths are handled. No obvious logic bugs in the diff.

**Amber:** Code achieves main path but edge cases are skipped. Error handling is partial. Some assumptions are unchecked.

**Red:** Logic doesn't match stated intent. Unchecked nulls or off-by-one errors visible in diff. No error handling. Previous bugs re-introduced.

**What to look for in diffs:**
- Is the happy path implemented correctly?
- Are there `if err != nil` / `try-catch` / null checks where data could be missing?
- Does the change handle concurrency if relevant (race conditions, shared state)?
- Are return values checked?

---

## 2. Maintainability

**Green:** Functions are focused and short (< 30 lines typical). Modules have clear responsibilities. New code follows existing patterns.

**Amber:** Some functions are long or do multiple things. Mild duplication. Could be refactored but not urgent.

**Red:** God functions (> 100 lines). Deep nesting (> 4 levels). Copy-paste across files. No modularity. New code adds to existing mess rather than cleaning it.

**What to look for:**
- Function/method length in the diff
- Is complexity being added to an already-complex area?
- Are there repeated blocks that should be extracted?
- Does the new code have a single clear responsibility?

---

## 3. Readability

**Green:** Non-obvious logic is commented. Naming is clear and consistent. Formatting matches project style. No magic numbers.

**Amber:** Mostly readable but some confusing variable names or missing comments on tricky sections.

**Red:** No comments anywhere complex code was added. Inconsistent naming. Magic numbers. Formatting that violates the project's conventions.

**What to look for:**
- Are there unexplained numeric or string constants? (`if status == 3` vs `if status == STATUS_PENDING`)
- Do function/variable names describe what they do?
- Is there a style guide? Are the diffs consistent with it?

---

## 4. Efficiency

**Green:** No obvious performance issues. Queries are scoped. Loops are appropriate. Async used where needed.

**Amber:** A few inefficiencies but not blocking. Minor N+1 patterns. Synchronous call that could be async but isn't critical path.

**Red:** N+1 queries in a loop. Missing indexes on queried fields. Blocking the event loop. Loading entire datasets into memory for filtering.

**What to look for:**
- Queries inside loops
- Fetching more data than needed
- Missing pagination on list endpoints
- Synchronous I/O in async contexts

---

## 5. Security

**Green:** Inputs are validated and sanitized. No secrets in code. Auth/authz checks present where needed. Parameterized queries used.

**Amber:** Minor gaps — e.g., input validation present but incomplete, or an endpoint that probably should have a permission check but it's low-risk.

**Red:** Hardcoded API keys, passwords, or tokens. SQL/command injection risk (string concat into queries). Missing auth checks on sensitive endpoints. User-supplied data rendered without escaping.

**What to look for:**
- Any string that looks like a key or password in the diff
- Raw SQL string construction: `"SELECT * FROM users WHERE id=" + userId`
- `eval()` or `exec()` on user input
- Endpoints added without middleware that enforces authentication
- User input rendered into HTML without escaping

---

## 6. Error Handling

**Green:** Errors are caught, logged, and surfaced appropriately. Failure modes are explicit. No silent failures.

**Amber:** Some errors caught but not all. Logging present but inconsistent.

**Red:** Bare `catch {}` with no logging or re-throw. Promises without `.catch()`. Functions that can fail silently and callers won't know.

**What to look for:**
- Empty catch blocks
- `Promise` calls without error handling
- Functions that return `null` or `undefined` on failure with no indication to caller
- No logging on failure paths

---

## 7. Testability

**Green:** New logic is accompanied by new or updated tests. Tests cover happy path and at least one error/edge case.

**Amber:** Tests exist but are shallow (only happy path). Or tests were not updated alongside changed behavior.

**Red:** New logic added with zero tests. Existing tests broken by the change and not fixed. No tests in the repo at all for this area.

**What to look for:**
- Did the diff include a test file? If not, was it warranted?
- Do the tests actually exercise the new code path?
- Are there tests that now fail silently because behavior changed but tests weren't updated?

---

## Overall Quality Rating

Combine pillar scores:

- All Green or mostly Green → 🟢 **Healthy codebase**
- 1–2 Reds, rest Amber/Green → 🟡 **Needs Attention** (specific areas to fix)
- 3+ Reds → 🔴 **At Risk** (systematic quality issues; needs dedicated engineering sprint)
