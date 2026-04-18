.PHONY: skills-validate

skills-validate:
	@for dir in $$(ls -d skills/*/); do \
		subfolder=$$(basename $$dir); \
		echo "Validating $$subfolder..."; \
		uvx --from skills-ref agentskills validate $$dir; \
		echo ""; \
	done