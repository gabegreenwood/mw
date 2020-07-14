
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
    dir=$1
    if [ ! -d $dir ]; then
        echo "Creating directory $dir"
        mkdir $dir
        chown $LOGNAME:$LOGNAME $dir
        chmod 750 $dir
        return 0
    else
        echo "Requirement satisfied: $dir already exists"
        return -1
    fi
}

check_device()
{
    if [ $# -ne 1 ]; then
        echo "Error: read_device_path() accepts one and only one argument"
        return -1
    fi
    filepath=$1
    info=$blkid $filepath
    if [ $? == 0 ]; then
        return 0
    else
        echo "Error: unable to locate device at $filepath"
        return -1
    fi
}