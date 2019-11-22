#!/bin/bash

INSTANCES=$(aws autoscaling describe-auto-scaling-groups | jq -r --arg group $1 '.AutoScalingGroups[] | select(.AutoScalingGroupName == $group) |.Instances[].InstanceId')
for i in $INSTANCES; do
	aws ec2 create-tags --resources "$i" --tags Key=$2,Value=$3
done
