#!/bin/sh
docker stop bind
docker run -dit --name bind --publish=53:53/udp --publish=53:53 bind 
