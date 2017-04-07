#!/bin/bash
USER_GROUP=InstanceUsers # change this to
yum install -y git
cd `mktemp -d`
git clone https://github.com/ehalpern/aws-ec2-ssh.git
sh aws-ec2-ssh/install.sh