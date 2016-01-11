#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo "We need root permissions to install."
    exit 1
fi

cp -r ./src/* ./etc/
