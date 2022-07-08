echo "Install some dependencies"

echo "Install python3-venv"
apt-get install python3-venv & y

echo "Docker-compose-plugin package"
sudo apt-get install docker-compose-plugin & y

echo "Python-dev package"
sudo apt-get install libpq-dev python-dev & y
