gazes_directory="/usr/local/bin/gazes"

checkIfSudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script requires superuser privileges. Please run it with sudo."
        return 1
    else
        return 0
    fi
}


gaze_update() {
  if [ -z "$gazes_directory" ]; then
    echo "Error: gazes_directory is not set."
    return 1
  fi

  echo "Updating gaze..."
  cd "$gazes_directory" || return
  git pull > /dev/null
  echo "Gaze has been updated."
  mv "$gazes_directory/gazes.sh" "$gazes_directory/../gazes.sh"
  source ~/.bashrc
  cd - > /dev/null || return
}


gaze_help() {
  echo "Usage: gaze <command>"
  echo "Commands:"
  echo "  update: update gaze"
  echo "  clean: clean docker containers"
  echo "  help: display this help message"
}

gaze_clean(){
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
    eval $gazes_directory/docker-utils/docker-clean.sh "$@"
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
    eval $gazes_directory/docker-utils/docker-run.sh "$@"
}

gaze_git(){
    if [ -z "$gazes_directory" ]; then
        echo "Error: gazes_directory is not set."
        exit 1
    fi
    eval $gazes_directory/git-utils/git.sh "$@"
}

gaze_docker_install(){
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
    eval $gazes_directory/docker-utils/docker-install.sh "$@"
}

command=$1
# if they are no arguments provided, return help
if [ -z "$command" ]; then
    gaze_help
    return 1
else 
    shift
fi
case $command in
    "update")
        gaze_update 
        ;;
    "run")
        gaze_run "$@"
        ;;
    "clean")
        gaze_clean "$@"
        ;;
    "docker-install")
        gaze_docker_install
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