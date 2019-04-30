docker_name = dokuwiki
docker_organization = canelrom1
docker_image = dokuwiki
docker_tag = $(shell date +%y%m%d%H%M%S)

path_data = $(shell pwd)/data

dw_port = 80
tag = latest

all: run

build: src/Dockerfile
	docker build -t $(docker_organization)/$(docker_name):$(docker_tag) src
	docker tag $(docker_organization)/$(docker_name):$(docker_tag) $(docker_organization)/$(docker_name):latest 

up:
	docker-compose up -d

down:
	docker-compose down

run:
	docker run -d \
		   --name=$(docker_name) \
		   -p $(dw_port):8080 \
		   $(docker_organization)/$(docker_image):$(tag)

stop:
	docker stop $(docker_name)
	docker rm $(docker_name)

exec:
	docker exec -it $(docker_image) sh

restart: stop run

doc-server: README.md
	@grip --quiet -b $< 0.0.0.0:8888 &
	@sleep 2

doc-server-stop:
	@killall grip

edit:
	@vim Makefile \
	     docker-compose.yml \
	     src/Dockerfile \
	     src/entrypoint.sh \
	     scripts/backups.sh
