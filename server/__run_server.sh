#!bin/bash
export USE_DOCKER=1
export PORT_NUMBER=


while getopts "hdp:" opt; do
    case $opt in
		d) 
			echo "Disable docker"
			USE_DOCKER=0
		;;

		p) 
			PORT_NUMBER=$OPTARG
			echo "Port number: $PORT_NUMBER"
		;;

		h)
			echo "Options:"
			echo "Listen on port:            -p <port number>"
			echo "Using docker:              -d"
			exit;
		;;
	esac
done

if [ $USE_DOCKER -eq 1 ]
then
	echo "Docker compose build"
	docker compose build
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