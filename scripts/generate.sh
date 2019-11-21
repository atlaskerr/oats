#!/bin/bash

set -e
set -o pipefail

# generate runway YAML config.
jsonnet runway.libsonnet | yq read - >runway.yaml

# generate stacker YAML configs.
for i in $(find -name stacker.libsonnet); do
	jsonnet $i | yq read - >"$(dirname $i)/stacker.yaml"
done

# generate cloudformation YAML templates.
for i in $(find -name template.libsonnet); do
	jsonnet $i | yq read - >"$(dirname $i)/template.yaml"
done
