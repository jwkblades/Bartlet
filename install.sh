#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    # user is not root, installing into the user's home directory
    mkdir ~/.bartlet_plugins
    cp -r ./src/* ~/.bartlet_plugins
else
    # user is root, installing into /etc
    cp -r ./src/Bartlet.sh ./etc/
    mkdir /etc/bartlet_plugins
    cp -r ./src/StandardSuite /etc/bartlet_plugins/
fi
