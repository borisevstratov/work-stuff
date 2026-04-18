---
name: agent-memory-save
description: Persist long-term knowledge, architecture decisions, and user preferences to the project's memory.
---

# agent-memory-save

This skill allows agents to persist what they've learned about user preferences or the project's history into a long-term memory store. This ensures that important context and decisions are preserved across different chat sessions.

## When to use

- After significant architecture decisions have been made (e.g., ADRs).
- When a user expresses a preference that should be remembered for future interactions.
- When you want to summarize and save the key outcomes or knowledge gained during the current session.
- Triggered by requests like "save this to memory", "remember my preference for X", or "update our architecture decisions".

## Instructions

1. **Analyze and Compact:** Review the current chat session to identify key knowledge, decisions, or user preferences that warrant long-term persistence. Compact this information into a concise, structured format (e.g., Markdown).
2. **Determine Target File:**
    - If the user specified a specific `.md` file, use that as the target.
    - Otherwise, default to the `.agents/memory/` directory.
    - Use `decisions.md` for architecture decision records (ADRs).
    - Use `user.md` for learned user preferences.
    - If neither fits, create a descriptive new file in `.agents/memory/`.
3. **Verify/Create Directory:** Ensure the `.agents/memory/` directory exists. If not, create it using the `bash` tool.
4. **Update Memory:**
    - **Read First:** Use the `read` tool to check if the target file already exists and to understand its current content and structure.
    - **Edit or Write:** If the file exists, use the `edit` tool to append or update the information, maintaining the existing style (e.g., headers, lists). If the file does not exist, use the `write` tool to create it with a clear, descriptive header and the compacted information.
5. **Memory Structure Example:**
```
.
└── .agents/              # Recommended context directory
    ├── memory/           # Persistent project knowledge (read/write)
    │   ├── decisions.md  # ADRs (why we chose X over Y)
    │   └── user.md       # Learned user preferences
```

6. **ADR Content Example:**
// .agents/memory/decisions.md
```markdown
# Architecture decision records

## 001. Use PostgreSQL
Status: Accepted
Date: 2023-10-27

We chose PostgreSQL for its reliability and JSONB support.
```
