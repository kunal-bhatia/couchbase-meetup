#!/usr/bin/env bash

docker-compose -f docker-compose.yml rm -f
docker-compose -f docker-compose.yml pull

docker-compose -f docker-compose.yml down --rmi local -v --remove-orphans
docker-compose -f docker-compose.yml up --build meetup-app
