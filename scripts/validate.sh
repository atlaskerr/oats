#!/bin/bash

set -e
set -o pipefail

# validate cloudformation templates with cf-lint.
for i in $(find -name template.yaml); do
	cfn-lint $i
done
