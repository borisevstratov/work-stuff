# work-stuff

This repository contains a collection of specialized agent skills designed to enhance productivity and automate common engineering workflows.

## Skills

- **Agent Specs Write**
  ```bash
  npx skills add borisevstratov/work-stuff/skills/agent-specs-write
  ```
- **Agent Memory Save**
  ```bash
  npx skills add borisevstratov/work-stuff/skills/agent-memory-save
  ```
- **Generate Changelog**
  ```bash
  npx skills add borisevstratov/work-stuff/skills/generate-changelog
  ```
- **CTO Codebase Audit**
  ```bash
  npx skills add borisevstratov/work-stuff/skills/cto-codebase-audit
  ```
- **Make Release**
  ```bash
  npx skills add borisevstratov/work-stuff/skills/make-release
  ```

## Reference

### [Prompts](PROMPTS.md)
- [Git Usage](PROMPTS.md#git-usage)
- [MCP Usage](PROMPTS.md#mcp-usage)

### [Commands](COMMANDS.md)
- [Git branches cleanup](COMMANDS.md#git-branches-cleanup)

## Context Routing

Inspired by [bgreenwell/dotagents](https://github.com/bgreenwell/dotagents).

```text
.
├── AGENTS.md             # Entry point & router (Required)
└── .agents/              # Recommended context directory
    ├── rules/            # Invariant behavioral guidelines
    │   ├── coding.md     # e.g. "No `any` types"
    │   └── comms.md      # e.g. "Be concise"
    ├── context/          # Static reference data (read-only)
    │   ├── schema.sql    # Database structure
    │   └── api.ts        # API interfaces
    ├── logs/             # Agent activity logs & audit trails
    │   └── session_1.md
    ├── memory/           # Persistent project knowledge (read/write)
    │   ├── decisions.md  # ADRs (why we chose X over Y)
    │   └── user.md       # Learned user preferences
    ├── personas/         # Specialized agent profiles
    │   └── qa.md         # e.g. "QA Engineer" hat
    ├── skills/           # Executable capabilities (agentskills.io compliant)
    │   └── database-migration/
    │       ├── SKILL.md
    │       └── scripts/
    │           └── migrate.sh
    └── specs/            # Current task requirements
        └── feature_x.md
```

