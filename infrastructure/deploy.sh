#!/usr/bin/env bash

aws cloudformation deploy --template-file templates/network.yaml --stack-name kubepreview-network
aws cloudformation deploy --template-file templates/sgs.yaml --stack-name kubepreview-sgs
aws cloudformation deploy --template-file templates/ec2.yaml --stack-name kubepreview-ec2
