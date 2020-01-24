#!/usr/bin/env bash
docker run --rm -d \
        -p 8080:8080 \
        -p 9990:9990 \
        --name wildfly_app \
        wildfly:18.0.1
