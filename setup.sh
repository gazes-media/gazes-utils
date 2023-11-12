current_dir=$(pwd)
echo "Adding the load script to your .bashrc file"
echo "gazes_directory=$current_dir" >> ~/.bashrc
echo "source $current_dir/load.sh" >> ~/.bashrc
echo "Done"
echo "Executing source ~/.bashrc"
source ~/.bashrc
echo "Done"
echo "You can now use each commands loaded by the load script"