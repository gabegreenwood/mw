# install source code files
# create `mw` command via symlink from /usr/local/bin
# or equivalent source directory in user's PATH
sudo mkdir /usr/src/mw
sudo rsync -acp ./*.sh /usr/src/mw
sudo ln -s /usr/src/mw/mw.sh /usr/local/bin/mw
sudo chmod 755 /usr/local/bin/mw

# Create runtime directories
if [ ! -d $LOCKER_DIRECTORY ]; then
    echo "Creating directory $LOCKER_DIRECTORY"
    mkdir $LOCKER_DIRECTORY
    chown $LOGNAME:$LOGNAME $LOCKER_DIRECTORY
    chmod 750 $LOCKER_DIRECTORY
fi
if [ ! -d $FUSE_TARGET ]; then
    echo "Creating directory $FUSE_TARGET"
    mkdir $FUSE_TARGET
    chown $LOGNAME:$LOGNAME $FUSE_TARGET
    chmod 750 $FUSE_TARGET
fi
if [ ! -d $TARGET_MOUNT ]; then
    echo "Creating directory $TARGET_MOUNT"
    mkdir $TARGET_MOUNT
    chown $LOGNAME:$LOGNAME $TARGET_MOUNT
    chmod 750 $TARGET_MOUNT
fi

exit 0