 # Check if both arguments are provided
docker-clean() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: docker-clean <container-name> <new-image>"
        return 1
    fi

    local container_name="$1"
    local new_image="$2"

    # Get the image ID before removing the container
    local old_image_id=$(docker inspect -f '{{.Image}}' "$container_name")

    # Get the port mapping before removing the container
    local port_mapping=$(docker port "$container_name" | cut -d' ' -f3 | cut -d: -f2)

    # Stop and remove the existing container
    docker stop "$container_name" && docker rm "$container_name"

    # Pull the new image
    docker pull "$new_image"

    # Start a new container with the same name and the original port mapping
    if [ -n "$port_mapping" ]; then
        docker run -d -p "$port_mapping:$port_mapping" -e "PORT=$port_mapping" --restart always --name "$container_name" "$new_image"
    else
        echo "Unable to determine port mapping for the container."
    fi

    # Remove the old image
    if [ -n "$old_image_id" ]; then
        docker rmi "$old_image_id"
    else
        echo "Unable to determine the image ID for the old image."
    fi
}

docker-clean "$@"