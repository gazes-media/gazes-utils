 # Check if all arguments are provided
 docker-run() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: docker-run <port> <container-name> <image>"
        return 1
    fi

    local port="$1"
    local container_name="$2"
    local image="$3"

    # Run the Docker container
    docker run -d -p "$port:$port" -e "PORT=$port" --name  --restart always "$container_name" "$image"
}

docker-run "$@"