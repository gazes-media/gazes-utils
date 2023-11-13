$source_dir="/usr/local/bin/gazes"

if [ -z "$source_dir" ]; then
    echo "Error: source_dir is not set."
    return 1
fi
command = $1
shift
case $command in
    "update")
        git_update "$@"
        ;;
    *)
    echo "Error: $command is not a valid command."
esac

git_update(){
    # verify if they are more than 1 argument provided, if not return error
    if [ "$@" -ne 1 ]; then
        echo "Usage: gaze git update <commit-message>"
        return 1
    fi
    eval "$source_dir/git-utils/update.sh" "$@"
}