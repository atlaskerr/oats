#!/bin/bash

aws ec2 describe-instances | jq '.Reservations[].Instances[] | select(.Tags[].Key == "aws:autoscaling:groupName") | .InstanceId'
