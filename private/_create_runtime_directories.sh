# Create runtime directories

create_runtime_directory()
{
    if [ $# -ne 1 ]; then
        echo "ERROR: $0 expects 1 and only 1 argument"
        exit -2
    fi
    exitcode=0
    dir=$1
    if [ ! -d $dir ]; then
        echo "Creating directory $dir"
        sudo mkdir $dir
        ret=$?
        exitcode=$(($exitcode - $ret))
        sudo chown $LOGNAME:$LOGNAME $dir
        ret=$?
        exitcode=$(($exitcode - $ret))
        sudo chmod 750 $dir
        ret=$?
        exitcode=$(($exitcode - $ret))
    fi
    if [ $exitcode -ne 0 ]; then
        exit $exitcode
    fi
}

if [ -d $LOCKER_DIRECTORY ]; then
    echo "Using directory $LOCKER_DIRECTORY to store decryption socket"
 else
    create_runtime_directory $LOCKER_DIRECTORY
fi
if [ -e $FUSE_TARGET ]; then
    echo "Using directory $FUSE_TARGET to serve as mountpoint for dislocker decryption object"
else
    create_runtime_directory $FUSE_TARGET
fi
if [ -d $TARGET_MOUNT ]; then
    echo "Using directory $TARGET_MOUNT as target mount point for decrypted Windows filesystem"
else
    create_runtime_directory $TARGET_MOUNT
fi

exit 0
