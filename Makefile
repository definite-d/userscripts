# Makefile for userscripts repository
# Regenerates scripts/README.md table from script metadata

SCRIPTS_DIR := scripts
README := README.md
SCRIPTS_README := $(SCRIPTS_DIR)/README.md
GITHUB_USER := definite-d
REPO := userscripts
BRANCH := main

# Colors for output
BLUE := \033[36m
GREEN := \033[32m
RESET := \033[0m

.PHONY: all readme help clean

all: readme

help:
	@echo "Available targets:"
	@echo "  $(BLUE)make readme$(RESET)  - Regenerate scripts/README.md table from metadata"
	@echo "  $(BLUE)make help$(RESET)    - Show this help message"

readme:
	@echo "$(GREEN)Generating scripts/README.md table...$(RESET)"
	@bash -c ' \
		SCRIPTS="$(SCRIPTS_DIR)"; \
		README="$(SCRIPTS_README)"; \
		USER="$(GITHUB_USER)"; \
		REPO="$(REPO)"; \
		BRANCH="$(BRANCH)"; \
		\
		# Create temp file for new scripts README \
		TABLE_FILE=$$(mktemp); \
		\
		# Write header \
		echo "# Available Scripts" >> $$TABLE_FILE; \
		echo "" >> $$TABLE_FILE; \
		\
		# Write table header \
		echo "| Name | Version | Description | Direct Install | GreasyFork | OpenUserJS |" >> $$TABLE_FILE; \
		echo "|------|---------|-------------|----------------|------------|------------|" >> $$TABLE_FILE; \
		\
		# Process each script file \
		for script in $$SCRIPTS/*.user.js; do \
			[ -f "$$script" ] || continue; \
			\
			# Extract metadata using grep \
			NAME=$$(grep -oP "(?<=@name\\s{1,10}).*" "$$script" | head -1 | sed "s/^[[:space:]]*//"); \
			VERSION=$$(grep -oP "(?<=@version\\s{1,10}).*" "$$script" | head -1 | sed "s/^[[:space:]]*//"); \
			DESCRIPTION=$$(grep -oP "(?<=@description\\s{1,10}).*" "$$script" | head -1 | sed "s/^[[:space:]]*//"); \
			\
			# Skip if missing essential metadata \
			if [ -z "$$NAME" ] || [ -z "$$VERSION" ] || [ -z "$$DESCRIPTION" ]; then \
				echo "$(BLUE)Skipping $$(basename $$script) - missing metadata$(RESET)"; \
				continue; \
			fi; \
			\
			# Get filename for links \
			FILENAME=$$(basename "$$script"); \
			\
			# Create install links \
			RAW_URL="https://raw.githubusercontent.com/$$USER/$$REPO/$$BRANCH/$$SCRIPTS/$$FILENAME"; \
			DIRECT_LINK="[Install]($$RAW_URL)"; \
			\
			# Create GreasyFork link (slugified name) \
			NAME_SLUG=$$(echo "$$NAME" | tr "[:upper:]" "[:lower:]" | sed "s/ /-/g" | sed "s/[^a-z0-9-]//g"); \
			GREASYFORK_LINK="[GreasyFork](https://greasyfork.org/scripts/XXXXXX-$$NAME_SLUG)"; \
			\
			# Create OpenUserJS link \
			OUJS_NAME=$$(echo "$$NAME" | sed "s/ /_/g"); \
			OPENUSERJS_LINK="[OpenUserJS](https://openuserjs.org/scripts/$$USER/$$OUJS_NAME)"; \
			\
			# Truncate description if too long \
			if [ "$${#DESCRIPTION}" -gt 60 ]; then \
				DESCRIPTION="$${DESCRIPTION:0:57}..."; \
			fi; \
			\
			# Add to table \
			echo "| $$NAME | $$VERSION | $$DESCRIPTION | $$DIRECT_LINK | $$GREASYFORK_LINK | $$OPENUSERJS_LINK |" >> $$TABLE_FILE; \
		done; \
		\
		# Add notes section \
		echo "" >> $$TABLE_FILE; \
		echo "## Notes" >> $$TABLE_FILE; \
		echo "" >> $$TABLE_FILE; \
		echo "- **Direct Install**: Click to install directly from GitHub (requires Tampermonkey/Greasemonkey)" >> $$TABLE_FILE; \
		echo "- **GreasyFork**: Links will be updated with actual script IDs once published" >> $$TABLE_FILE; \
		echo "- **OpenUserJS**: Links will be updated with actual script IDs once published" >> $$TABLE_FILE; \
		\
		# Write to scripts README (replace entirely) \
		cat $$TABLE_FILE > "$$README"; \
		\
		# Cleanup \
		rm -f $$TABLE_FILE; \
		\
		echo "$(GREEN)scripts/README.md updated successfully!$(RESET)"; \
	'

# Check if scripts need table regeneration
check:
	@echo "Checking if README needs regeneration..."
	@bash -c ' \
		for script in $(SCRIPTS_DIR)/*.user.js; do \
			if [ "$$script" -nt "$(SCRIPTS_README)" ]; then \
				echo "$(BLUE)$$(basename $$script)$(RESET) is newer than scripts/README.md"; \
				echo "Run $(GREEN)make readme$(RESET) to update"; \
				exit 0; \
			fi; \
		done; \
		echo "$(GREEN)scripts/README.md is up to date$(RESET)"; \
	'
