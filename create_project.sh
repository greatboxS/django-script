#!bin/bash
export VIRTUAL_ENV=django-virt
export PROJECT_NAME=
export RUN_SERVER=0
export USE_DOCKER=1
export PROJECT_ROOT=
export USE_VENV=1

while getopts "n:p:v:ehrd" opt; do
    case $opt in
		n)
			PROJECT_NAME=$OPTARG
			echo "Project name: $PROJECT_NAME"
		;;

		p)
			PROJECT_ROOT=$OPTARG
			PROJECT_ROOT=$(sed "s/^\///;s/\/$//" <<< $PROJECT_ROOT)
			echo "Project root path $PROJECT_ROOT"
		;;

		v)
			VIRTUAL_ENV=$OPTARG
			echo "VIRTUAL_ENV=$VIRTUAL_ENV"
		;;

		e)
			echo "Use virtual enviroment"
			USE_VENV=0
		;;

		r)
			echo "Disable docker"
			RUN_SERVER=1
		;;

		d) 
			echo "Create new project with docker"
			USE_DOCKER=1
		;;

		h)
			echo "Options:"
			echo "Project name:              -n <project name>"
			echo "Project root:              -p <project root path>"
			echo "Virutal eviroment name:    -v <virtual enviroment name>"
			echo "Running server:            -r"
			echo "Using virtual enviroment:  -e"
			echo "Using docker:              -d"
			exit;
		;;
	esac
done

if [ -z "$PROJECT_NAME" ]
then
	echo "Error!"
	echo "Create project with no project name"
	echo "Please input the required parameters!"
	bash $0 -h
	exit;
fi

if [ -z "$PROJECT_ROOT" ]
then
	echo "WARNING!"
	echo "Project root path is not specified, use current directory"
	bash $0 -h
	exit;
fi

# Update new Project root directory
PROJECT_ROOT=$PROJECT_ROOT/$PROJECT_NAME

export PROJECT_ROOT_FULL_PATH=$(realpath $PROJECT_ROOT)
echo "Project root full path: ${PROJECT_ROOT_FULL_PATH}"

export BUILD_ROOT="${PROJECT_ROOT_FULL_PATH:1}"
# BUILD_ROOT=$(sed -i -e "s/\/;s/\\/g" <<< $BUILD_ROOT)
echo "BUILD ROOT: $BUILD_ROOT"

if [ ! -d $PROJECT_ROOT ]
then
	mkdir $PROJECT_ROOT
fi

# Use virtual eviroment
if [ $USE_VENV == 1 ]
then
	echo "Create python virtual enviroment"
	python -m venv $PROJECT_ROOT/$VIRTUAL_ENV

	echo "Activate python virutal enviroment"
	source $PROJECT_ROOT/$VIRTUAL_ENV/bin/activate
fi

# install django
echo "Install Django"
python -m pip install Django

echo "Install psycopg2-binary"
python -m pip install psycopg2-binary

echo "Sync script files"
cp db/* $PROJECT_ROOT
cp env/* $PROJECT_ROOT
cp env/.env $PROJECT_ROOT
cp server/* $PROJECT_ROOT

if [ $USE_DOCKER == 1 ]
then
	echo "USE DOCKER TO BUILD IMAGE"

	echo "Sync docker files"
	cp docker/* $PROJECT_ROOT

	cd $PROJECT_ROOT

	echo "Current directory: `pwd`"
	echo "Update project name in docker-compose.yml file"

	# sed -i "s/\[_root_\]/\[${BUILD_ROOT}\]/g" docker-compose.yml
	sed -i "s/_web_name_/$PROJECT_NAME/g" docker-compose.yml

	echo "Create new Django project"
	sudo docker compose run web django-admin startproject $PROJECT_NAME .

	sudo chown -R $USER:$USER *

	if [ $RUN_SERVER == 1 ]
	then
		echo "DOCKER COMPOSE UP"
		docker compose up
	fi
	
	echo "Create new django project successfully!"
	exit;
fi

echo "Create new Django project"
cd $PROJECT_ROOT
django-admin startproject ${PROJECT_NAME}

if [ $RUN_SERVER == 1 ]
then
	cd $PROJECT_NAME
	python manage.py runserver
fi

echo "Create new django project successfully!"
exit;
