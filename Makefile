.DEFAULT_GOAL: default

.PHONY: default
default: generate

.PHONY: generate
generate:
	scripts/generate.sh

.PHONY: clean
clean:
	scripts/clean.sh

.PHONY: validate
validate: generate
	scripts/validate.sh
