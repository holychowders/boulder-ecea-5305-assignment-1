# Step 10: Write a shell script finder-app/writer.sh as described below
#
#     Accepts the following arguments:
#       - the first argument is a full path to a file (including filename) on the filesystem, referred to below as writefile;
#       - the second argument is a text string which will be written within this file, referred to below as writestr
#
#     Creates a new file with name and path writefile with content writestr, overwriting any existing file and creating the path if it doesn’t exist.
#
#     Exits with value 1 error and print statements if any of the arguments above were not specified
#     Exits with value 1 and error print statement if the file could not be created.
#
#     Example: writer.sh /tmp/aesd/assignment1/sample.txt ios creates file /tmp/aesd/assignment1/sample.txt with content: ios
#

#!/bin/sh

set -e

writefile="$1"
writestr="$2"
argcount=$#

main() {
    handle_args

    # Create the containing path for WRITEFILE
    local containing_path="${writefile%/*}"
    [ "$containing_path" = "$writefile" ] && containing_path='.'
    if ! mkdir -p "$containing_path"; then
        printf '%s\n' "Error: WRITEFILE containing path could not be created: $containing_path"
        exit 1
    fi

    # Write WRITESTR into WRITEFILE
    if ! echo "$writestr" > "$writefile"; then
        printf '%s\n' "Error: WRITESTR '$writestr' could not be written into WRITEFILE '$writefile'"
        exit 1
    fi
}

handle_args() {
    if [ $argcount -eq 0 ]; then
        print_usage
        exit 0
    elif [ ! $argcount -eq 2 ]; then
        echo 'Error: This program takes two arguments (or zero for usage info)'
        print_usage
        exit 1
    fi

    if [ -z "$writefile" ]; then
        echo 'Error: WRITEFILE not specified'
        print_usage
        exit 1
    fi

    if [ -z "$writestr" ]; then
        echo 'Error: WRITESTR not specified'
        print_usage
        exit 1
    fi
}

print_usage() {
    echo 'Usage:'
    printf '%s\n' "  $0 WRITEFILE WRITESTR"

    echo 'Description:'
    echo '  Create a new file WRITEFILE containing WRITESTR'
    echo '  If the file already exists, it will be overwritten'

    echo 'Required Arguments:'
    echo '  WRITEFILE: Path of file to create'
    echo '  WRITESTR : String to write into new file'
}

main
