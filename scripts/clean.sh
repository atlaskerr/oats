#!/bin/bash

shopt -s globstar

# remove runway
rm -f runway.yaml

# remove stacker configs.
for i in $(find -name stacker.yaml); do
	rm $i
done

# remove cloudformation templates
for i in $(find -name template.yaml); do
	rm $i
done
