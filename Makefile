############################
#╔════════════════════════╗#
#║ DEFAULT CONFIGURATION  ║#
#╚════════════════════════╝#
############################
.PHONY: help build deploy
.SILENT:

.DEFAULT_GOAL = help
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
SERVICES := $(wildcard src/services/*)
OS := linux darwin
ARCH := amd64 arm64
$(eval $(ARGS):;@:)
$(eval GWD=$(shell git rev-parse --show-toplevel 2>/dev/null || pwd))
$(shell git config core.hooksPath $(GWD)/.github/hooks 2>/dev/null || true)

help: #Pour générer automatiquement l'aide ## Display all commands available
	$(eval PADDING=$(shell grep -x -E '^[a-zA-Z_-]+:.*?##[\s]?.*$$' Makefile | awk '{ print length($$1)-1 }' | sort -n | tail -n 1))
	clear
	echo '╔──────────────────────────────────────────────────╗'
	echo '║ ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗  ║'
	echo '║ ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗ ║'
	echo '║ ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝ ║'
	echo '║ ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗ ║'
	echo '║ ██║  ██║███████╗███████╗██║     ███████╗██║  ██║ ║'
	echo '║ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝ ║'
	echo '╟──────────────────────────────────────────────────╝'
	@grep -E '^[a-zA-Z_-]+:.*?##[\s]?.*$$' Makefile | awk 'BEGIN {FS = ":.*?##"}; {gsub(/(^ +| +$$)/, "", $$2);printf "╟─[ \033[36m%-$(PADDING)s\033[0m %s\n", $$1, "] "$$2}'
	echo '╚──────────────────────────────────────────────────>'
	echo ''

build-all: clean build-windows build-linux build-darwin

clean:
	rm -rf build/bin

build-windows:
	wails build -nsis -platform windows/arm64,windows/amd64

build-linux:
	wails build -platform linux/arm64,linux/amd64

build-darwin:
	wails build -platform darwin/arm64,darwin/amd64

build:
	wails build
	open build/bin/ssm-gui.app

dev:
	wails dev