source_dir="/etc/gazes"
command=$1

docker_run(){
    # Verify if alls arguments are passed correctly
    if [ "$#" -lt 2 ]; then
        echo "Usage: gazes docker run <port> <container-name> <image> [-e <env-var>=<env-value>]"
        return 1
    fi
    
    eval "$source_dir/docker-utils/docker-run.sh" "$@"
}

docker_clean(){
    # Verify if alls arguments are passed correctly
    if [ "$#" -ne 2 ]; then
        echo "Usage: gazes docker clean <container-name> <new-image>"
        return 1
    fi
    
    eval "$source_dir/docker-utils/docker-clean.sh" "$@"
}

docker_install(){
    eval "$source_dir/docker-utils/docker-install.sh"
}

docker_help(){
    echo "Usage: gazes docker <command>"
    echo "Commands:"
    echo "  run <port> <container-name> <image> [-e <env-var>=<env-value>]"
    echo "  clean <container-name> <new-image>"
    echo "  install"
}

case $command in
    "run")
        shift
        docker_run "$@"
        ;;
    "clean")
        shift
        docker_clean "$@"
        ;;
    "install")
        docker_install
        ;;
    *)
        docker_help
        ;;
esac