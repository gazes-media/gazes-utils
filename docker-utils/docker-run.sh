
 # Check if all arguments are provided
 docker-run() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: gaze run <port> <container-name> <image> [ -e <env-var> -e <env-var> ... ]"
        return 1
    fi

    local port="$1"
    local container_name="$2"
    local image="$3"
    # parse every -e argument
    local envs=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e)
                # Check if there is a subsequent argument
                if [[ $# -lt 2 ]]; then
                    echo "Error: Missing argument for -e option."
                    exit 1
                fi

                # Add the argument to the array
                envs+=("$2")
                shift 2
                ;;
            *)
                # Ignore other options or arguments
                shift
                ;;
        esac
    done

   local env_to_add=""
    for env_var in "${envs[@]}"; do
         env_to_add+=" -e $env_var"
    done

    # Check if a container using this port already exists
    if sudo docker ps --filter "publish=$port" --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "A container with the name $container_name and port $port already exists."
        return 1
    fi

    # Run the Docker container
    sudo docker run -d -p "$port:$port" -e "PORT=$port" --name "$container_name" $env_to_add --restart always "$image" > /dev/null
    echo "The container $container_name has been started."
}

docker-run "$@"