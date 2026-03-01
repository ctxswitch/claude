CLAUDE_DIR := $(HOME)/.claude

.PHONY: install
install:
	@mkdir -p $(CLAUDE_DIR)/agents $(CLAUDE_DIR)/commands
	@install -m 644 agents/*.md $(CLAUDE_DIR)/agents/
	@install -m 644 commands/*.md $(CLAUDE_DIR)/commands/
	@echo "Installed agents and commands to $(CLAUDE_DIR)"
