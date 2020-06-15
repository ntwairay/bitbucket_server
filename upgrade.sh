#!/bin/bash

DESIRED_VERSION=$1

# $# = number of arguments. Answer is 3
# $@ = what parameters were passed. Answer is 1 2 3
# $? = was last command successful. Answer is 0 which means 'yes'

if [ $# -eq 0 ]
then
    echo "No arguments supplied, please type Bitbucket Version"
    exit 0
fi

function build_image() {
    sed -i.bak s/BITBUCKET_VERSION=.*/BITBUCKET_VERSION=${DESIRED_VERSION}/g Dockerfile
    sudo docker build -t bitbucket:${DESIRED_VERSION} .
    sed -i.bak s/"image: bitbucket".*/"image: bitbucket:"${DESIRED_VERSION}/g docker-compose.yml
}

function run_compose() {
    docker-compose up -d
}


if [ "$(docker ps -aq -f name=bitbucket)" ];
then
    echo "******Terminating Containers******"
    docker-compose down
fi

echo "******Building Images....******"
build_image
echo "******Running Containers******"
run_compose
