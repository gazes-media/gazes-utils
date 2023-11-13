# Check if both arguments are provided
docker_clean() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: gaze clean <container-name> <new-image>"
        return 1
    fi

    local container_name="$1"
    local new_image="$2"

    # Check if the container exists
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "Error: The container $container_name does not exist."
        return 1
    fi

    # Get the image ID before removing the container
    local old_image_id=$(docker inspect -f '{{.Config.Image}}' "$container_name")


    # Get the port mapping before removing the container
    local port_mapping=$(docker port "$container_name" | cut -d' ' -f3 | cut -d: -f2)
    
    # Get environment variables before removing the container 
    local env_variables=$(docker exec "$container_name" env | cut -d= -f1)

    local image_already_pulled=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$new_image$")

    local env_to_add=""
    for env_var in $env_variables; do
        env_value=$(docker exec "$container_name" printenv "$env_var")
        env_to_add+=" -e '$env_var=$env_value'"
    done
    local start_new_container="docker run -d --restart always --name $container_name $env_to_add"

    # Stop and remove the existing container
    docker stop "$container_name" > /dev/null && docker rm "$container_name" > /dev/null
    echo "The container $container_name has been stopped and removed."

    if [ -n "$old_image_id" ]; then
        if [ "$(diff <(echo "$old_image_id") <(echo "$new_image"))" != "" ]; then
        # if they are other containers using the old image, it won't be removed
            if docker ps -a --filter "ancestor=$old_image_id" --format '{{.Names}}' | grep -q "^$container_name$"; then
                echo "The old image is still in use by other containers so it won't be removed."
            else
                docker rmi "$old_image_id" > /dev/null
            fi
            
            if [ -z "$image_already_pulled" ]; then
                docker pull "$new_image" > /dev/null
            fi
        else
            echo "The old image is the same as the new image so it won't be removed."
        fi
    else
        echo "Unable to determine the image ID for the old image."
    fi

    # Start a new container with the same name and the original port mapping
    if [ -n "$port_mapping" ]; then
        start_new_container="$start_new_container -p $port_mapping:$port_mapping -e PORT=$port_mapping"
    fi

    start_new_container="$start_new_container $new_image"
    # start the new container
    local docker_id=$(eval "$start_new_container")
    echo "The new container $container_name has been started with the id $docker_id."

}

docker_clean "$@"