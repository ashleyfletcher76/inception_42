DOCKER_COMPOSE = docker-compose -f docker-compose.yml

# build and run all services
all: up

up:
	@$(DOCKER_COMPOSE) up --build -d
	@echo "Containers are up and running."

# stop containers but dont remove the volumes
down:
	@$(DOCKER_COMPOSE) down
	@echo "Containers have been stopped."

# stop, remove containers netowrks and volumes
fclean:
	@$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	@docker volume prune -f
	@echo "Containers, networks, images and volumes have been removed."

# restart containers
re: fclean up

# check status of containers running
ps:
	@$(DOCKER_COMPOSE) ps

# tails logs for services
logs:
	@$(DOCKER_COMPOSE) logs -f

nginx_ip:
	@docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx
	@echo "NGINX IP fetched."

secrets:
	@echo "Copying and setting secrets..."
	@chmod 600 secrets/mysql_user_password.txt
	@chmod 600 secrets/mysql_password.txt

.PHONY: all up down fclean re ps log nginx_ip secrets