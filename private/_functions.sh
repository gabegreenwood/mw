
export check_for_program

export create_runtime_directory

find_bitlocker_device()
{
    device="$(lsblk -O | grep -i bitloc | awk '{print $3}')"
    sudo blkid $device > /dev/null
    if [ $? == 0 ]; then
        echo $device
        return 0 
    else
        echo "Error: unable to locate device at $filepath"
        return -1
    fi
}
export find_bitlocker_device
