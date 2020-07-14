# Create runtime directories

minimum=0

if [ ! -d $LOCKER_DIRECTORY ]; then
    echo "Creating directory $LOCKER_DIRECTORY"
    create_runtime_directory $LOCKER_DIRECTORY
    ret=$?
    minimum=$(($minimum - $ret))
fi
if [ ! -d $FUSE_TARGET ]; then
    echo "Creating directory $FUSE_TARGET"
    create_runtime_directory $FUSE_TARGET
    ret=$?
    minimum=$(($minimum - $ret))
fi
if [ ! -d $TARGET_MOUNT ]; then
    echo "Creating directory $TARGET_MOUNT"
    create_runtime_directory $TARGET_MOUNT
    ret=$?
    minimum=$(($minimum - $ret))
fi

exit $minimum
