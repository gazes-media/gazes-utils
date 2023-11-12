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
    
    # Get environment variables before removing the container 
    local env_variables=$(docker exec "$container_name" env | cut -d= -f1)

    local start_new_container=docker run -d --restart always --name "$container_name" $(for env_var in $env_variables; do echo "-e $env_var=$(docker exec "$container_name" printenv "$env_var")"; done)

    # Stop and remove the existing container
    docker stop "$container_name" && docker rm "$container_name"

    # Pull the new image
    docker pull "$new_image"

    # Start a new container with the same name and the original port mapping
    if [ -n "$port_mapping" ]; then
        start_new_container="$start_new_container -p $port_mapping:$port_mapping -e PORT=$port_mapping"
    fi

    start_new_container="$start_new_container $new_image"
    # start the new container
    eval "$start_new_container"

    local new_image_id=$(docker inspect -f '{{.Image}}' "$container_name")
    # Remove the old image
    if [ -n "$old_image_id" ]; then
        if [ "$old_image_id" != "$new_image_id" ]; then
        # if they are other containers using the old image, it won't be removed
            if docker ps -a --filter "ancestor=$old_image_id" --format '{{.Names}}' | grep -q "^$container_name$"; then
                echo "The old image is still in use by other containers so it won't be removed."
            else
                docker rmi "$old_image_id"
            fi
        fi
    else
        echo "Unable to determine the image ID for the old image."
    fi
}

docker-clean "$@"