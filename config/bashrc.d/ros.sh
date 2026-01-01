alias cb='colcon build'
alias cb-cpp='colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --no-warn-unused-cli'
alias si='source install/setup.bash'
alias rosh='source ~/Projects/ros2/distro/humble/install/setup.bash'

fsh() {
	rosh 
	si
}

sdistro() {
	local distro="$1" # Distro name
	"source $HOME/Projects/ros2/distro/$distro/install/setup.bash"
}


