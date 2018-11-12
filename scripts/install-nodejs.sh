#!/bin/bash -e

# Version 8 is the current LTS release
# No need to install if environment is nodejs in travis
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
