#!/bin/bash

# Constants
VERSION="1.0.0"

# Global variables
declare -A write_dict

function print_help()
{
    echo -e " This tool provides comprehensive management of the project image packages, enabling you to build,"
    echo -e " push and pull images from container registries (ghcr.io),"
    echo -e " deploy images to remote servers and list available Docker images."
    echo -e " Version: $VERSION \n"
    echo -e " Instructions:"
    echo -e "   1. Set up your GITHUB_USERNAME and GITHUB_TOKEN in the .env file."
    echo -e "   2. Run the script with the desired command and options."
    echo -e "   3. Use the command 'package help' to see all available commands and options.\n"
    echo -e " USAGE:"
	echo -e "   package <command> [<args=value>]\n"
	echo -e " COMMANDS:"
    echo -e "   build [options]  - Build image from Dockerfile."
    echo -e "   push [options]   - Push image to container registry."
    echo -e "   pull [options]   - Pull image from container registry."
    echo -e "   deploy [options] - Deploy image to remote server."
    echo -e "   list             - List all related images."
    echo -e "   version          - Returns the tool version."
	echo -e "   help             - Print this help.\n"
	echo -e " OPTIONS:"
	echo -e "   -i, --image      - The docker image name (stream_consumer)."
    echo -e "   -t, --tag        - The docker image tag (latest)."
    echo -e "   -f, --file       - The file path to the Dockerfile (Dockerfile)."
    echo -e "   -r, --registry   - The container registry (ghcr.io)."
    echo -e "   -o, --organization The organization name (digitalcomtech)."
    echo -e "   -s, --stage      - The the build stage(dev, prod)."
    echo -e "   -h, --host       - The remote server for deployment.\n"
    echo -e " EXAMPLES:"
	echo -e "   To list all the project images:"
    echo -e "     package list"
    echo -e "   To build an image:"
    echo -e "     package build --image=stream_consumer --tag=latest --file=Dockerfile"
    echo -e "   To push an image to a registry:"
    echo -e "     package push --image=stream_consumer --tag=latest --registry=ghcr.io"
    echo -e "   To pull an image from a registry:"
    echo -e "     package pull --image=stream_consumer --tag=latest --registry=ghcr.io"
    echo -e "   To deploy an image to a remote server:"
    echo -e "     package deploy --image=stream_consumer --tag=latest --registry=ghcr.io --server=remote_server"
    echo -e "   To remove an image from a registry:"
    echo -e "     package remove --image=stream_consumer --tag=latest --registry=ghcr.io\n"
	exit 0
}

function print_error()
{
    echo '"Missing or invalid option"'
	exit 95
}

function set_defaults()
{
    # Set default values for the dictionary

    DEFAULT_FILE="./koda/domains/tracking/live/build/Dockerfile.${write_dict['image']}"
    write_dict["image"]=${write_dict["image"]:-"stream_consumer"}
    write_dict["tag"]=${write_dict["tag"]:-"dev"}
    write_dict["file"]=${write_dict["file"]:-"$DEFAULT_FILE"}
    write_dict["registry"]=${write_dict["registry"]:-"ghcr.io"}
    write_dict["organization"]=${write_dict["organization"]:-"digitalcomtech"}
    write_dict["stage"]=${write_dict["stage"]:-"dev"}
    write_dict["host"]=${write_dict["host"]:-"localhost"}
}

function login() {
    # Load environment variables from .env file if it exists
    if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    fi

    # Check if required environment variables are set
    REQUIRED_VARS=("GITHUB_USERNAME" "GITHUB_TOKEN")
    for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Environment variable '$var' is not set."
        exit 1
    fi
    done

    echo "Logging into GitHub Container Registry (GHCR)."
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "${GITHUB_USERNAME}" --password-stdin
    if [ $? -ne 0 ]; then
        echo "Error: GHCR.io login failed."
        exit 1
    fi

    echo "GHCR login successful!"
}

# Call getopt to validate the provided input
# $@ is all command line parameters passed to the script
# -o is for short options like -v
# -l is for long options with double dash like --version
# the comma separates different long options
# -a is for long options with single dash like -version
function parse_options()
{
	shift
	options=$(getopt -l "image:,tag:,file:,registry:,organization:,stage:,host:" -o "i:t:f:r:o:s:h" -a -- "$@" 2> /dev/null)
	[ $? -ne 0 ] && print_error
	# set --:
	# If no arguments follow this option, then the positional parameters are unset. Otherwise, the positional parameters
	# are set to the arguments, even if some of them begin with a ‘-’.
	# shitf is used to get the next position in args
	eval set -- "$options"
	while true; do
		case "$1" in
            -i|--image)
                shift;
                write_dict["image"]=$1
                ;;
			-t|--tag)
                shift;
                write_dict["tag"]=$1
                ;;
            -f|--file)
                shift;
                write_dict["file"]=$1
                ;;
            -r|--registry)
                shift;
                write_dict["registry"]=$1
                ;;
            -o|--organization)
                shift;
                write_dict["organization"]=$1
                ;;
            -s|--stage)
                shift;
                write_dict["stage"]=$1
                ;;
            -h|--host)
                shift;
                write_dict["host"]=$1
                ;;
            --)
                shift;
                break
                ;;

		esac
		shift
	done
}

# Validate arguments
if ([ $# -eq 0 ] || [ -z $1 ])
then
    echo "Missing command or invalid argument"
    print_help
    exit 1
fi

option=$(echo $1 | tr '[:upper:]' '[:lower:]')
case "$option" in
    list)
        # List all project docker images
        docker images | grep -E "ghcr.io/digitalcomtech|docker.io/digitalcomtech|digitalcomtech" | awk '{print $1":"$2}' | sort -u
        ;;

    build)
        [ $# -lt 2 ] && print_error
        parse_options "$@"

        # Set default values if not provided
        set_defaults

        # Login into registry
        login

        FULL_IMAGE_NAME="${write_dict['registry']}/${write_dict['organization']}/${write_dict['image']}:${write_dict['tag']}"

        # Build the image
        docker buildx build \
        --file ${write_dict["file"]} \
        --target ${write_dict['stage']} \
        --output type=docker \
        --tag $FULL_IMAGE_NAME \
        koda/domains/tracking/live/${write_dict['image']}

        if [ $? -ne 0 ]; then
            echo "Error building image"
            exit 1
        fi

        echo -e "Image build success: $FULL_IMAGE_NAME"
        ;;

    push)
        [ $# -lt 2 ] && print_error
        parse_options "$@"

        # Set default values if not provided
        set_defaults

        # Login into registry
        login

        # Push image to registry
        FULL_IMAGE_NAME="${write_dict['registry']}/${write_dict['organization']}/${write_dict['image']}:${write_dict['tag']}"

        echo "Pushing $FULL_IMAGE_NAME to registry..."

        docker push "$FULL_IMAGE_NAME"

        if [ $? -ne 0 ]; then
            echo "Error: Docker push failed."
            exit 1
        fi

        echo "$FULL_IMAGE_NAME  successfully!"
        ;;

    pull)
        [ $# -lt 2 ] && print_error
        parse_options "$@"

        # Set default values if not provided
        set_defaults

        # Login into registry
        login

        # Pull image from registry
        FULL_IMAGE_NAME="${write_dict['registry']}/${write_dict['organization']}/${write_dict['image']}:${write_dict['tag']}"

        echo "Pulling $FULL_IMAGE_NAME from registry..."

        docker pull "$FULL_IMAGE_NAME"

        if [ $? -ne 0 ]; then
            echo "Error: Docker pull failed."
            exit 1
        fi

        echo "Image $FULL_IMAGE_NAME pulled successfully!"
        ;;

    deploy)
        [ $# -lt 2 ] && print_error
        parse_options "$@"

        # Set default values if not provided
        set_defaults

        # 1. Save the image to a tar file
        FULL_IMAGE_NAME="${write_dict['registry']}/${write_dict['organization']}/${write_dict['image']}:${write_dict['tag']}"
        echo "Saving $FULL_IMAGE_NAME to a tar file..."

        docker save -o "${write_dict['image']}.tar" "$FULL_IMAGE_NAME"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to save Docker image to tar file."
            exit 1
        fi

        # 2. Transfer the tar file to the remote server
        echo "Transferring ${write_dict['image']}.tar to remote server ${write_dict['host']}..."

        # Check if the remote server is reachable  :/home/admin/images
        scp "${write_dict['image']}.tar" "${write_dict['host']}"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to transfer tar file to remote server."
            exit 1
        fi

        # 3. Load the image on the remote server
        echo "Loading Docker image on remote server ${write_dict['host']}..."

        # TODO: Check if the remote server is reachable split by :
        #ssh "${write_dict['host']}" "sudo docker load -i /home/admin/images/${write_dict['image']}.tar"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to load Docker image on remote server."
            exit 1
        fi

        # 5. Update docker-compose file on the remote server
        echo "Send docker-compose file on remote server ${write_dict['host']}..."
        #scp docker-compose.yml "${write_dict['host']}:/home/admin/images/docker-compose.yml"
        ;;

    -h|help|--help)
		print_help
		;;

	-v|version|--version)
		echo '"'$VERSION'"'
		exit 0
		;;

	*)
		print_error
		;;

esac
exit 0
