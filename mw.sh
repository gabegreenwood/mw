#!/bin/bash

# Script to mount a Bitlocker encrypted Windows partition on a linux
# system by wrapping the dislocker utilitiy ( https://github.com/Aorimn/dislocker )

source config.sh

bash -c _mount_windows.sh

exit $?
