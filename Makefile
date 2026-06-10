# agr-launchpad — convenience targets. Run `make help` for the list.
.DEFAULT_GOAL := help
SHELL := /bin/sh

.PHONY: help setup install-plugins jupyter list-packs use-pack unuse-pack new-pack

help: ## Show this help
	@echo "agr-launchpad — targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN{FS=":.*?## "}{printf "  %-16s %s\n", $$1, $$2}'
	@echo
	@echo "Pack usage:  make use-pack name=ml   |   make new-pack name=ios"

setup: ## Print first-time setup steps (plugins, .env, gsd, markitdown)
	@sh scripts/setup.sh

install-plugins: ## Install all six base plugins via the Claude Code CLI
	@sh scripts/install-plugins.sh

jupyter: ## Start a local Jupyter kernel for the jupyter MCP (needs uv + jupyter)
	@sh scripts/jupyter.sh

list-packs: ## List available and installed packs
	@sh scripts/use-pack.sh --list

use-pack: ## Install a pack:   make use-pack name=<pack>
	@test -n "$(name)" || { echo "usage: make use-pack name=<pack>"; exit 1; }
	@sh scripts/use-pack.sh "$(name)"

unuse-pack: ## Remove a pack:    make unuse-pack name=<pack>
	@test -n "$(name)" || { echo "usage: make unuse-pack name=<pack>"; exit 1; }
	@sh scripts/use-pack.sh --remove "$(name)"

new-pack: ## Scaffold a pack:  make new-pack name=<pack>
	@test -n "$(name)" || { echo "usage: make new-pack name=<pack>"; exit 1; }
	@sh scripts/new-pack.sh "$(name)"
