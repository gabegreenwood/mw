source ./config.sh

echo "RUNTIME_ROOT_DIR=`pwd`" >> ./private/_config.sh

# install source code files
# create `mw` command via symlink from /usr/local/bin
# or equivalent source directory in user's PATH
echo "Creating symlink to executable"
sudo ln -s `pwd`/mw.sh $BIN_PATH/mw

exit $?
