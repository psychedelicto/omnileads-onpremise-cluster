#!/bin/bash

PREREQ_SCRIPT=digital_ocean_prereq.sh
REPO=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
BRANCH=develop


yum install git -y
git clone $REPO
cd omnileads-onpremise-cluster
git checkout $BRANCH
cd omlapp

chmod +x $PREREQ_SCRIPT
./$PREREQ_SCRIPT

reboot
