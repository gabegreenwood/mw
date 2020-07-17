#!/usr/bin/bash

# Don't allow superuser to run this script
if [ "$EUID" -eq 0 ]; then
  echo "Please do not invoke this script with root priviliges."
  exit -1
fi

RUNTIME_ROOT_DIR=`pwd`
# load configuration
source config.sh

# Exit if the decrypted filesystem is already mounted to our taret directory
if [ "`df -Th | grep fuseblk | grep $TARGET_MOUNT`" ]; then
    echo "fuseblk partition is already mounted at $TARGET_MOUNT"
    echo "Please check the contents of $TARGET_MOUNT; it should contain your data..."
    exit -2
fi

# Check for missing dependencies
$EXEC_SHELL _handle_dependencies.sh
exit_code=$?
if [ $exit_code < 0 ]; then
    echo "Aborting process early due to missing dependencies."
    exit $ret
fi

# Identify the bitlocker device ID
#TODO: ADD SUPPORT FOR MULTIPLE BITLOCKER PARTITIONS
BITLOCKER_PARTITION=$(find_bitlocker_device)
if [ $? -eq 0 ]; then
    export BITLOCKER_PARTITION
else
    echo 'Error: unable to locate bitlocker partition'
fi

# Create runtime directories if they are missing
$EXEC_SHELL _create_runtime_directories.sh
if [ $exit_code < 0 ]; then
    echo "Error creating runtime directories. Aborting"
    exit $exit_code
fi

# execute the main program
$EXEC_SHELL _mount_windows.sh
exit_code=$?
    if [ $exit_code -ne 0 ]; then
        exit $exit_code
    fi
fi

# return successfully if no errors were encountered
exit 0
