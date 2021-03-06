#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    # user is not root, installing into the user's home directory
    if [[ ! -d ~/.bartlet_plugins ]]; then
        mkdir ~/.bartlet_plugins
    fi
    cp -r ./src/* ~/.bartlet_plugins
else
    # user is root, installing into /etc
    cp -r ./src/Bartlet.sh /etc/
    if [[ ! -d /etc/bartlet_plugins ]]; then
        mkdir /etc/bartlet_plugins
    fi
    cp -r ./src/StandardSuite /etc/bartlet_plugins/
fi
