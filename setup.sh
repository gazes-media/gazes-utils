#!/bin/bash

# Get the current directory
current_dir=$(pwd)

# Directory for storing gazes scripts and service
source_dir="/etc/gazes"

# Name of the source script
source_script="gazes.sh"

# Check if the setup is already configured in PATH
if ! grep -q "$source_dir" <<< "$PATH"; then
    # Add the directory to PATH
    export PATH="$PATH:$source_dir"
fi

# Remove old setup
if [ -d "$source_dir" ]; then
    echo "Removing old setup from $source_dir"
    sudo rm -r "$source_dir"
    echo "Done"
fi

# Copy the source script to the source directory
echo "Copying the source script to $source_dir"
chmod +x -R "$current_dir"
# Copy the whole gazes directory to /etc/gazes
sudo cp -r "$current_dir" "$source_dir"
echo "Done"

# Making the source script executable
echo "Making the source script executable"
sudo ln -sf "$source_dir/$source_script" /usr/local/bin/gazes 

sudo chown nobody:nogroup /etc/gazes 