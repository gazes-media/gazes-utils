 # Check if all arguments are provided
 docker-run() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: docker-run <port> <container-name> <image>"
        return 1
    fi

    local port="$1"
    local container_name="$2"
    local image="$3"

    # Check if a container using this port already exists
    if docker ps --filter "publish=$port" --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "A container with the name $container_name and port $port already exists."
        return 1
    fi

    # Run the Docker container
    docker run -d -p "$port:$port" -e "PORT=$port" --name "$container_name" --restart always "$image"
}

docker-run "$@"
    
    # Run the Docker container
    docker run -d -p "$port:$port" -e "PORT=$port" --name  --restart always "$container_name" "$image"
}

docker-run "$@"