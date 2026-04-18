---
name: agent-specs-write
description: >
  Use this skill when asked to generate a technical specification for a feature or architectural change.
  Triggers include: "create a spec", "generate technical specification", "write a design doc",
  "architectural change plan", "feature specification", "design a new feature",
  "write a RFC", "create a technical proposal".
---

# Technical Specification Generation Skill

This skill provides a structured workflow for generating high-quality technical specifications for features or architectural changes, ensuring alignment and approval before implementation.

---

## 1. Scope & Constraints

- **Documentation Only**: This skill is strictly for generating Markdown (`.md`) specifications. **DO NOT** implement any code or logic beyond the documentation itself.
- **Approval Required**: The user **MUST** review and approve the specification before any implementation begins.

---

## 2. Specification Template & Location

- **Template**: Use the structure defined in `skills/agent-specs-write/assets/SPEC_TEMPLATE.md`.
- **Location**: Save all specifications in `.agents/specs/` using the naming convention `YYYY-MM-DD_feature-name.md`.

---

## 3. Context & Content Requirements

Ensure the specification includes:
- **Architecture Details**: High-level design and component interactions.
- **API Surface**: Detailed specification of interfaces, endpoints, or utility functions.
- **Data Models**: Definitions for database schemas or core interfaces, including **JSDoc types**.
- **Logic Flows**: Step-by-step execution paths for primary use cases.

---

## 4. Workflow

1. **Gather Requirements**: Analyze the feature or change request.
2. **Generate Specification**: Create the `.md` file in `.agents/specs/` following the [the template](references/SPEC_TEMPLATE.md) and naming convention.
3. **Submit for Review**: Present the generated specification to the user and explicitly request their approval.
4. **Wait for Approval**: Do not proceed with implementation until the user has reviewed and approved the specification.
