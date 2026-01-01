exec-ros() {
	# Usage: exec-ros <distro> /absolute/path/to/ros2_ws

	if [ -z "$1" ] || [ -z "$2" ]; then
	  echo "❌ Error: Please provide ROS 2 distro and the absolute path to your ROS 2 workspace."
	  echo "Usage: exec-ros <distro> /absolute/path/to/ros2_ws"
	  return 1
	fi

	DISTRO=$1
	ROS_WS=$2

	# Check if the path exists
	if [ ! -d "$ROS_WS" ]; then
	  echo "❌ Error: Directory '$ROS_WS' does not exist."
	  return 1
	fi

	# Allow X server connection (only if DISPLAY is set)
	if [ -n "$DISPLAY" ]; then
	  xhost +local:docker > /dev/null 2>&1
	fi

	# Get host user ID and group ID for matching user inside container
	HOST_UID=$(id -u)
	HOST_GID=$(id -g)

	# Run the container
    docker run -it --rm \
	  --net=host \
	  --device="/dev/video0" \
	  --env="DISPLAY=$DISPLAY" \
	  --env="QT_X11_NO_MITSHM=1" \
	  --env="LIBGL_ALWAYS_SOFTWARE=0" \
      --env="__NV_PRIME_RENDER_OFFLOAD=1" \
      --env="__GLX_VENDOR_LIBRARY_NAME=nvidia" \
      --runtime=nvidia \
      --gpus all \
	  -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	  --device=/dev/dri:/dev/dri \
	  -v "$ROS_WS:/home/user/ros_ws:rw" \
	  --workdir /home/user/ros_ws \
	  --user "$HOST_UID:$HOST_GID" \
	  --name "${DISTRO%%:*}" \
	  "$DISTRO" \
	  bash
}

dock() {
  if [ -z "$1" ]; then
    echo "Usage: dock <container_name>"
    return 1
  fi
  docker exec -it "$1" bash
}

_dock_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(docker ps --format '{{.Names}}')" -- "$cur") )
}

complete -F _dock_complete dock
