# bin/bash
export APP_NAME=
export USE_DOCKER=1

while getopts "n:dh" opt; do
    case $opt in
		n)
			APP_NAME=$OPTARG
			echo "Application name=$APP_NAME"
		;;

		d)
			echo "Disable docker"
			USE_DOCKER=0
		;;

		h)
			echo "
	An app is a web application that has a specific meaning in your project, like a home page, a contact form, or a members database.
	In this tutorial we will create an app that allows us to list and register members in a database.
	But first, let's just create a simple Django app that displays \"Hello World!\"."
			echo
			echo "Options:"
			echo "App name:                  -n <project name>"
			exit;
		;;
	esac
done

if [ -z "$APP_NAME" ]; then
	echo "Error!"
	echo "Create new Django application with no name"
	echo "Please input the required parameters!"
	bash $0 -h
	exit;
fi

echo
echo "Create new application $APP_NAME"

if [ $USE_DOCKER -eq 1 ]
then
	echo "Using docker to create new application"
	sudo docker compose run web django-admin startapp $APP_NAME

else
	python manage.py startapp $APP_NAME
fi

echo "Create new application successfully!"
