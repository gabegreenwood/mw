#!/usr/bin/bash

# Don't allow superuser to run this script
if [ "$EUID" -eq 0 ]; then
  echo "Please do not invoke this script with root priviliges."
  exit -1
fi

if [ "$1" == "--uninstall" ]; then
    source ./uninstall.sh
    exit $?
fi

# load configuration
source ./config.sh
if [ ! "$RUNTIME_ROOT_DIR" ]; then
    echo "Error: unable to source configuration file."
    echo "Please make sure you run this script from the correct root directory."
    exit -8
fi
cd $RUNTIME_ROOT_DIR
source ./config.sh
source ./private/_config.sh
source ./private/_functions.sh
export check_for_program validate_dependencies create_runtime_directory find_bitlocker_device

# Exit if the decrypted filesystem is already mounted to our taret directory
if [ "`df -Th | grep fuseblk | grep $TARGET_MOUNT`" ]; then
    echo "fuseblk partition is already mounted at $TARGET_MOUNT"
    echo "Please check the contents of $TARGET_MOUNT; it should contain your data..."
    exit -2
fi

# Check for missing dependencies
./private/_handle_dependencies.sh
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Aborting process early due to missing dependencies."
    exit $exit_code
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
./private/_create_runtime_directories.sh
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error creating runtime directories. Aborting"
    exit $exit_code
fi

# Create the encrypted file creating the bitlocker keys
# (if not already found on system)
if [ ! -f $BITLOCKER_KEYFILE ]; then
    ./private/_generate_protected_keyfile.sh
    exitcode=$?
    if [ $exitcode -ne 0 ]; then exit $exitcode; fi
fi

# Decrypt and mount the bitlocker partition
./private/_mount_windows.sh
exit_code=$?
if [ $exit_code -ne 0 ]; then
    exit $exit_code
fi

# return successfully if no errors were encountered
exit 0
