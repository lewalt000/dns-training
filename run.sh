#!/bin/sh
docker stop bind
docker ps -a | grep bind | awk '{print $1'} | xargs docker container rm
docker run -dit --name bind --publish=53:53/udp --publish=53:53 bind 
