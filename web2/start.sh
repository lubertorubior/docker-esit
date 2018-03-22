#!/usr/bin/env bash

service nginx start &
service php7.0-fpm start &


while true; do sleep 1000; done
