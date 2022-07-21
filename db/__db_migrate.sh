#!bin/bash
USE_DOCKER=1
DOCKER_CONTAINER_ID=
CREATE_SUPPER_USER=

while getopts "udhc:" opt; do
    case $opt in
		d)
			echo "Disable docker"
			USE_DOCKER=0
		;;

        u)
            echo "Create supperuser is enabled"
            CREATE_SUPPER_USER=true
        ;;

        c)
            echo "Docker container Id $OPTARG"
            DOCKER_CONTAINER_ID=$OPTARG
        ;;

		h)
			echo
			echo "Options:"
			echo "Migration without using docker:           -d"
			echo "Docker container id:                      -c <container id>"

			exit;
		;;
	esac
done

if [ $USE_DOCKER -eq 1 ]
then
    if [ -z $DOCKER_CONTAINER_ID ]
    then
        echo "Please input docker container id, which is running the application"
        sh $0 -h
        exit;
    fi

    if [ ! -z $CREATE_SUPPER_USER ]
    then
        echo "Create supper user:"
        docker exec -it $DOCKER_CONTAINER_ID python manage.py createsuperuser
        exit;
    fi

    docker exec -it $DOCKER_CONTAINER_ID python manage.py makemigrations
    docker exec -it $DOCKER_CONTAINER_ID python manage.py migrate
else

    if [ ! -z $CREATE_SUPPER_USER ]
    then
        echo "Create supper user:"
        python manage.py createsuperuser
        exit;
    fi
    
    python manage.py makemigrations
    python manage.py migrate
fi
