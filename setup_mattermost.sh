#!/bin/bash

cd /vagrant/mattermost-webapp
make build
#make clean
#make build

cd /vagrant/mattermost-server
#make run-server
make run
# wait for it to complete

