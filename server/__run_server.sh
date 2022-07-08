#!bin/bash
export USE_DOCKER=1
export PORT_NUMBER=
export BUILD_ENABLE=0

while getopts "hdbp:" opt; do
    case $opt in
		d) 
			echo "Disable docker"
			USE_DOCKER=0
		;;

		b)
			echo "Enable docker compose build"
			BUILD_ENABLE=1
		;;

		p) 
			PORT_NUMBER=$OPTARG
			echo "Port number: $PORT_NUMBER"
		;;

		h)
			echo "Options:"
			echo "Listen on port:            -p <port number> without docker mode"
			echo "Using docker:              -d"
			echo "Docker compose build:      -b"
			exit;
		;;
	esac
done

if [ $USE_DOCKER -eq 1 ]
then

	if [ $BUILD_ENABLE -eq 1 ]
	then
		echo "Docker compose build"
		docker compose build
	fi
	echo "Docker compose up"
	docker compose up

else
	if [ -z "$PORT_NUMBER" ]
	then
		PORT_NUMBER=8000
		echo "Warning!"
		echo "No port number is applied, running server with default port $PORT_NUMBER"
	fi

	python manage.py migrate
	python manage.py runserver $PORT_NUMBER
fi