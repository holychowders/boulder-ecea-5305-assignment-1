# Step 9: Write a shell script finder-app/finder.sh as described below:
#   Accepts the following runtime arguments:
#     - the first argument is a path to a directory on the filesystem, referred to below as filesdir;
#     - the second argument is a text string which will be searched within these files, referred to below as searchstr
#   Exits with return value 1 error and print statements if any of the parameters above were not specified
#   Exits with return value 1 error and print statements if filesdir does not represent a directory on the filesystem
#   Prints a message "The number of files are X and the number of matching lines are Y" where:
#     - X is the number of files in the directory and all subdirectories and
#     - Y is the number of matching lines found in respective files, where a matching line refers to a line which contains searchstr
#       (and may also contain additional content).

#!/bin/sh
set -e

filesdir="$1"
searchstr="$2"
argcount=$#

main() {
    handle_args

    local filecount=$(find "$filesdir" -type f | wc -l)
    local matchcount=$(grep -ir "$searchstr" "$filesdir" | wc -l)

    #printf '%s\n' "Files: $filecount"
    #printf '%s\n' "Matches: $matchcount"
    printf '%s\n' "The number of files are $filecount and the number of matching lines are $matchcount"
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

    if [ -z "$filesdir" ]; then
        echo 'Error: FILESDIR not specified'
        print_usage
        exit 1
    elif [ ! -d "$filesdir" ]; then
        printf '%s\n' "Error: FILESDIR directory not found: $filesdir"
        exit 1
    fi

    if [ -z "$searchstr" ]; then
        echo 'Error: SEARCHSTR not specified'
        print_usage
        exit 1
    fi
}

print_usage() {
    echo 'Usage:'
    printf '%s\n' "  $0 FILESDIR SEARCHSTR"

    echo 'Description:'
    echo '  Search files within FILESDIR for SEARCHSTR'

    echo 'Required Arguments:'
    echo '  FILESDIR : Directory to search'
    echo '  SEARCHSTR: String to find within files'
}

main
