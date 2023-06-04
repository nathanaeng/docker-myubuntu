#!/bin/bash
IMAGE_NAME=ubuntu-custom
CONTAINER_NAME=myubuntu
USER_NAME=myubuntu
USER_PASSWORD=myubuntu
ALIAS=ubuntu

DIR=$(pwd)

NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

define() { IFS=$'\n' read -r -d '' "${1}" || true; }

description="Run a custom ubuntu container"

usage_text=""
define usage_text <<'EOF'
USAGE:
    ./cs2110docker.sh [start|delete|-h|--help]

OPTIONS:
    start
            Start a new container. This is the default if no options
            are provided.
    stop
            Stop a running container.
    delete
            Stop and delete any existing container.
    -h, --help
            Show this help text.
EOF

print_help() {
  >&2 echo -e "$description\n\n$usage_text"
}

print_usage() {
  >&2 echo "$usage_text"
}

action=""
if [ $# -eq 0 ]; then
  action="start"
elif [ $# -eq 1 ]; then
  case "$1" in
    start)
      action="start"
      ;;
    stop)
      action="stop"
      ;;
    delete)
      action="delete"
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      >&2 echo "Error: unrecognized argument: $1"
      >&2 echo ""
      print_usage
      exit 1
      ;;
  esac
elif [ $# -gt 1 ]; then
  >&2 echo "Error: too many arguments"
  >&2 echo ""
  print_usage
  exit 1
fi

# Stop container
if [ "$action" = "stop" ]; then
  docker stop ${CONTAINER_NAME}
  echo -e "${GREEN}Successfully stopped $CONTAINER_NAME${NC}"
  exit 0
fi

# Stop and delete container
if [ "$action" = "delete" ]; then
  docker stop ${CONTAINER_NAME} && docker rm -f ${CONTAINER_NAME}
  echo -e "${GREEN}Successfully deleted $CONTAINER_NAME${NC}"
  exit 0
fi

# Check for Docker
if ! docker -v >/dev/null; then
  >&2 echo "ERROR: Docker not found. Please install Docker before running this script."
  exit 1
fi

if ! docker container ls >/dev/null; then
  >&2 echo "ERROR: Docker is not currently running. Please start Docker before running this script."
  exit 1
fi

# Add alias to .zshrc and set DIR
if [[ $(grep "alias $ALIAS" ~/.zshrc 2> /dev/null) == "" ]]; then
  echo alias $ALIAS="$DIR/startup.sh" >> ~/.zshrc
else
  DIR=$(grep "alias $ALIAS" ~/.zshrc)
  DIR=${DIR#*=}
  DIR=${DIR%/startup.sh}
fi

# Build image
docker build -t ${IMAGE_NAME} --build-arg USER_NAME="$USER_NAME" --build-arg USER_PASSWORD="$USER_PASSWORD" "$DIR"

# Create container if it doesn't exist
# Mounts current directory to docker container at /home/$USER_NAME/host/
{
if [ ! "$(docker ps -a -q -f name=${CONTAINER_NAME})" ]; then
  echo -e "${GREEN}Creating docker container...${NC}"
  docker run -v "$DIR:/home/$USER_NAME/host/" -dit --platform linux/amd64 --name ${CONTAINER_NAME} ${IMAGE_NAME} > /dev/null 2>&1
fi
} || {
  echo -e "${RED}Failed to create container. Exiting script.${NC}"
  exit 1
}

# Start container and attach to terminal
echo -e "${GREEN}Starting container...${NC}"
docker start ${CONTAINER_NAME} && docker attach ${CONTAINER_NAME}