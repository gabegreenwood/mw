echo '***************************************************************************' 
echo 'Installing `mw` (a.k.a. Mount Windows) utility'
echo '***************************************************************************' 

# Source globals
source ./config.sh
source ./private/_config.sh
source ./private/_functions.sh

# Create runtime directory if necessary
if [ ! -d "$RUNTIME_ROOT_DIR" ]; then
    echo "Creating runtime directory at $RUNTIME_ROOT_DIR"
    sudo mkdir -p $RUNTIME_ROOT_DIR
else
    echo "Runtime directory found at $RUNTIME_ROOT_DIR"
fi

# Make sure runtime dir has the right permissions
echo "Checking that user permissions for $RUNTIME_ROOT_DIR are correct"
sudo chown $USER:$USER $RUNTIME_ROOT_DIR
sudo chmod 750 $RUNTIME_ROOT_DIR

# Copy files to runtime directory
echo "Copying files to runtime directory"
sudo rsync -auc --delete "./" "$RUNTIME_ROOT_DIR/"

# create `mw` command via symlink from /usr/local/bin
# or equivalent source directory in user's PATH
if [ -e "$BIN_PATH/mw" ]; then
    echo "Removing old symlink at $BIN_PATH/mw"
    sudo unlink $BIN_PATH/mw
fi
echo "Creating new symlink to executable at $BIN_PATH/mw"
sudo ln -s $RUNTIME_ROOT_DIR/mw.sh $BIN_PATH/mw
sudo chmod 750 $BIN_PATH/mw

if [ $? -eq 0 ]; then
    echo 'Windows Bitlocker decryption scripts have been installed'
    echo 'Please use command `mw` to run program'
    exit 0
else
    echo "Error: unable to complete installation"
    exit -1
fi    
