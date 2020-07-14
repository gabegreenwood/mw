# We need to determine the UUID of the bitlocker partition
# NOTE: CURRENT IMPLEMENTATION DOES NOT SUPPORT MORE THAN ONE
# BITLOCKER ENCRYPTED PARTITION ON A MACHINE

device="$(lsblk -O | grep -i bitloc | awk '{print $3}')"
check_device $device
exitcode=$?
if [ $exitcode == 0 ]; then
    BITLOCKER_PARTITION=$device
    echo "Using bitlocker partion found on partition $device"
else
    echo "Unable to locate bitlocker partition on this machine. Aborting process."
    exit $exitcode
fi

exit 0
