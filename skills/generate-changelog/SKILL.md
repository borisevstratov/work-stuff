---
name: generate-changelog
description: Automatically create user-facing changelogs based on git history and commit categorization.
---

# generate-changelog

This skill automates the creation of user-facing changelogs by analyzing git history and transforming technical details into readable release notes.

## When to use

Use this skill when:
- The user asks to generate or update a changelog.
- A new release or version is being prepared.
- You need to summarize recent changes for human consumption.

## Instructions

1. **Analyze Git History**: Use `git log` to retrieve recent commits since the last release or within a specified range.
2. **Categorize Changes**: Group commits into categories such as "Features", "Bug Fixes", "Performance", "Documentation", etc.
3. **Draft Release Notes**: Transform technical commit messages into clear, customer-friendly descriptions. Avoid jargon and focus on the value provided to the user.
4. **Update CHANGELOG.md**: Append or update the `CHANGELOG.md` file with the drafted notes, ensuring consistent formatting and versioning.
5. **Verify**: Review the generated changelog for accuracy and clarity before finalizing.
