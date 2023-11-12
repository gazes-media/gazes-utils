#!/bin/bash

# Get the current directory
current_dir=$(pwd)

# Check if the setup is already configured in .bashrc
if grep -q "gazes_directory=$current_dir" ~/.bashrc && grep -q "source $current_dir/load.sh" ~/.bashrc; then
    echo "Setup is already configured in .bashrc. No changes needed."
else
    # Remove old lines if they exist
    sed -i "/gazes_directory=/d" ~/.bashrc
    sed -i "/source $current_dir\/load.sh/d" ~/.bashrc

    # Add new lines
    echo "Adding the load script to your .bashrc file"
    echo "gazes_directory=$current_dir" >> ~/.bashrc
    echo "source $current_dir/load.sh" >> ~/.bashrc
    echo "Done"
fi

# Execute source ~/.bashrc
echo "Executing source ~/.bashrc"
source ~/.bashrc
echo "Done"
echo "You can now use each command loaded by the load script"
