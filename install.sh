echo "\nRUNTIME_ROOT_DIR=`pwd`" >> ./config.s

# install source code files
# create `mw` command via symlink from /usr/local/bin
# or equivalent source directory in user's PATH
echo "Creating symlink to executable"
sudo ln -s ./mw.sh $BIN_PATH/mw
sudo chmod 755 $BIN_PATH/mw


exit $?