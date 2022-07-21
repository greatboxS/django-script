date:           07/2022 - Danang city VietNam
author:         greatboxs
descriptions:   Script for working with: Django (oauth2) - docker - postgresSQL
                This work helpful for a django (api-oauth) project can quickly deploy
                and run without any complicated configuration via docker.

1. Requirements:
    Docker
    python3
    pip3

2. How to create a project:

Cmd: bash create_project.sh -n webapi -p ../projects/
Des: Create aproject name webapi and store it in ../projects/ directory
     This creation used docker compose.

3. How to run project:

Cmd: sh __run_server.sh -b
Des: -b used to build the docker image, the server is running in port 8989
     to change to new port, use -p <port number> option.