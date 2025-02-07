.PHONY: test lint update-formulas

SCRIPTS := $(wildcard src/*)

# Detect OS for SHA256 calculation
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    SHA256 := shasum -a 256
    SED_I := sed -i ''
else
    SHA256 := sha256sum
    SED_I := sed -i
endif

test:
	@echo "Running tests..."
	@chmod +x test/*.test.sh
	@echo "Running git-get tests..."
	@SCRIPTDIR="$(PWD)/src" ./test/git-get.test.sh || exit 1
	@echo "Running git-autocommit tests..."
	@SCRIPTDIR="$(PWD)/src" ./test/git-autocommit.test.sh || exit 1
	@echo "Running git-branch-cleanup tests..."
	@SCRIPTDIR="$(PWD)/src" ./test/git-branch-cleanup.test.sh || exit 1
	@echo "All tests passed successfully!"

lint:
	@echo "Linting shell scripts..."
	@for script in $(SCRIPTS); do \
		shellcheck $$script; \
	done

update-formulas:
	@echo "Updating Homebrew formulas..."
	@for script in $(SCRIPTS); do \
		sha=$$($(SHA256) $$script | cut -d' ' -f1); \
		$(SED_I) "s/sha256 \".*\"/sha256 \"$$sha\"/" Formula/$$(basename $$script).rb; \
		echo "Updated $$script formula with SHA: $$sha"; \
	done