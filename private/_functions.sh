
# Check for program using `which` command.
# Note: this will tell you to install `which` if it's missing
check_for_program ()
{
    if [ $# -ne 1]; then
        echo "ERROR: $0 expects 1 and only 1 argument"
        return -2
    fi
    prog=$1
    which $prog 2>&1 
    if [ $? -ne 0 ]; then
        echo "ERROR: executable $prog not found"
        return -1
    fi
    return 0
}

validate_dependencies()
{
    progs="$@"
    errors=0
    for program in $progs; do
        check_for_program $program
        if [ $? == -1 ]; then
            ((++$errors))
        fi
    done
    return $errors
}

create_runtime_directory()
{
    if [ $# -ne 1]; then
        echo "ERROR: $0 expects 1 and only 1 argument"
        return -2
    fi
    minimum=0
    dir=$1
    if [ ! -d $dir ]; then
        echo "Creating directory $dir"
        mkdir $dir
        ret=$?
        minimum=$(($minimum - $ret))
        chown $LOGNAME:$LOGNAME $dir
        ret=$?
        minimum=$(($minimum - $ret))
        chmod 750 $dir
        ret=$?
        minimum=$(($minimum - $ret))
    fi
    return $minimum
}

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