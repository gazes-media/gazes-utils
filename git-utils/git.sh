source_dir="/etc/gazes"
command=$1

git_update(){
    echo "$@"
    # verify if there are any arguments
    if [ -z "$1" ]; then
        echo "correct use is git update <commit message>"
        return 1
    fi
    eval "$source_dir/git-utils/update.sh" "$@"
}

git_help(){
    echo "Usage: git <command>"
    echo "Commands:"
    echo "  update <commit message> - commits and pushes the changes to GitHub"
    echo "  help - prints this message"
}

if [ -z "$command" ]; then
    git_help
    exit 1
else
    shift
fi
case $command in
    "update")
        git_update "$@"
        ;;
    "help")
        git_help
        ;;
    *)
    echo "Error: $command is not a valid command."
esac

