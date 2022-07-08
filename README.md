
Change build path before create new project
_web_name_ (no needs to change)
docker-compose.yml
  web:
    build: home/pi/django/projects

Example: Create project webapi with output directory is ../projects

bash create_project.sh -n webapi -p ../projects/

Run server with docker
bash run_server.sh -d

posgres db configuration:

setting.py

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_NAME'),
        'USER': os.environ.get('POSTGRES_USER'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
        'HOST': 'db',
        'PORT': 5432,
    }
}

// Clear docker unused file
docker system prune

// Install dependencies:

sudo apt-get install docker-compose-plugin

sudo apt-get install libpq-dev python-dev

sudo apt-get install build-dep python-psycopg2

// Install in virtual enviroment
pip install psycopg2-binary 