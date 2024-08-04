#!/bin/bash


# Build Docker images
echo "Building Docker images..."
docker build -t todolist-flask:1.0 . -f Dockerfile.flask
docker build -t todolist-mysql:1.0 . -f Dockerfile.db
echo "Images done building..."

#create network
docker network create todolist-network

# Running those containers
echo "Building Docker Containers..."

docker run -itd --network todolist-network -p 3306:3306 --name todolist-mysql-container todolist-mysql:1.0 

docker run -itd --network todolist-network -p 8080:80 \
  -e MYSQL_DATABASE_HOST=todolist-mysql-container \
  -e MYSQL_DATABASE_USER=errick \
  -e MYSQL_DATABASE_PASSWORD=new_password \
  -e MYSQL_DATABASE_DB=todolist_errick_db \
  -e MYSQL_DATABASE_PORT=3306 \
  --name todolist-flask-container todolist-flask:1.0

echo "Containers done building..."

#connect the network
docker network connect todolist-network todolist-flask-container

#restart containers
docker restart todolist-flask-container
# docker restart todolist-mysql-container


