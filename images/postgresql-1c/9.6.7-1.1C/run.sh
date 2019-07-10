#!/bin/sh
sudo docker run -p 5432:5432 \
    --name postgresql-1c \
    --detach \
    --env POSTGRES_PASSWORD=postgres \
    msav/postgresql-1c
