#!/bin/bash

gazes_directory="/etc/gazes"

checkIfSudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script requires superuser privileges. Please run it with sudo."
        exit 1
    fi
}


gaze_update() {
  if [ -z "$gazes_directory" ]; then
    echo "Error: gazes_directory is not set."
    return 1
  fi

  echo "Updating gaze..."
  cd "$gazes_directory" || return
  sudo git config --global --add safe.directory /etc/gazes

  sudo git stash > /dev/null
  sudo git pull > /dev/null
  # remake the symlink
    rm /usr/local/bin/gazes
    ln -sf "$gazes_directory/gazes.sh" /usr/local/bin/gazes
  echo "Gaze has been updated."
  cd - > /dev/null || return
}


gaze_help() {
  echo "Usage: gazes <command>"
  echo "Commands:"
  echo "  update: update gaze"
  echo "  docker: docker utilities"
  echo "  git: git utilities"
  echo "  help: display this help message"
}

docker(){
    if [ -z "$gazes_directory" ]; then
        echo "Error: gazes_directory is not set."
        exit 1
    fi
    eval "$gazes_directory/docker-utils/docker.sh" "$@"
}

gaze_run(){
    # check if sudo
    checkIfSudo
    local sudo_check_result=$?

    if [ "$sudo_check_result" -ne 0 ]; then
        echo "Exiting script due to lack of superuser privileges."
        return "$sudo_check_result"
    fi

    if [ -z "$gazes_directory" ]; then
        echo "Error: gazes_directory is not set."
        exit 1
    fi
    eval "$gazes_directory/docker-utils/docker-run.sh" "$@"
}

gaze_git(){
    if [ -z "$gazes_directory" ]; then
        echo "Error: gazes_directory is not set."
        exit 1
    fi
    eval "$gazes_directory/git-utils/git.sh" "$@"
}
command=$1
# if they are no arguments provided, return help
if [ -z "$command" ]; then
    gaze_help
    exit 1
else 
    shift
fi
case $command in
    "update")
        gaze_update 
        ;;
    "docker")
        docker "$@"
        ;;
    "git")
        gaze_git "$@"
        ;;
    "help")
         gaze_help
        ;;
    *)
    if [ -z "$command" ]; then
        # No command provided
        :
    else
        echo "Error: $command is not a valid command."
    fi
        gaze_help
    ;;
esac