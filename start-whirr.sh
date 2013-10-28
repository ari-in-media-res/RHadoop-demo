#!/bin/bash
echo "Starting Whirr Script..."
export WHIRR_PROVIDER=aws-ec2
export AWS_ACCESS_KEY_ID=AKIAI7P7BDL6GMK47FNQ
export AWS_SECRET_ACCESS_KEY=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

whirr launch-cluster --config hadoop-ec2.properties
whirr run-script --script install-r+packages.sh --config hadoop-ec2.properties
~/.whirr/hadoop-ec2/hadoop-proxy.sh
