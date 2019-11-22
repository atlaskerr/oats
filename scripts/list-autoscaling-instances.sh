#!/bin/bash

aws autoscaling describe-auto-scaling-groups | jq \
	--arg group $1 \
	'.AutoScalingGroups[] | select(.AutoScalingGroupName == $group) |.Instances[].InstanceId'
