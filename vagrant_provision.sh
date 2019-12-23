#!/bin/bash

echo 'export PATH="/usr/local/go/bin:$PATH"' >> /root/.bashrc
echo 'export PATH="/usr/local/go/bin:$PATH"' >> /etc/profile
. /etc/profile


cd /vagrant
apt update
apt install -y build-essential curl vim docker-compose docker.io
usermod -aG docker vagrant


apt purge -y apparmor
rm -rf /usr/local/go
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.13.3.linux-amd64.tar.gz
go get golang.org/x/lint/golint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.21.0


curl -sL https://deb.nodesource.com/setup_13.x | bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get install -y nodejs yarn
npm install -g webpack webpack-cli webpack-dev-server copy-webpack-plugin
npm install --save-dev webpack webpack-cli webpack-dev-server copy-webpack-plugin
npm install webpack webpack-cli webpack-dev-server copy-webpack-plugin

