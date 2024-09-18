DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

# build and run all services
all: prepare up

# prepare necessary directories
prepare:
	@echo "Preparing directories for volumes..."
	@if [ ! -d "/home/${USER}/data/mariadb" ]; then mkdir -p /home/${USER}/data/mariadb; fi
	@if [ ! -d "/home/${USER}/data/wordpress" ]; then mkdir -p /home/${USER}/data/wordpress; fi
	@sudo chown -R $(USER):$(USER) /home/${USER}/data
	@echo "Directories are ready."

up: prepare
	@$(DOCKER_COMPOSE) build
	@$(DOCKER_COMPOSE) up -d
	@echo "Containers are up and running."

new: prepare
	@$(DOCKER_COMPOSE) build --no-cache
	@$(DOCKER_COMPOSE) up -d

# stop containers but dont remove the volumes
down:
	@$(DOCKER_COMPOSE) down
	@echo "Containers have been stopped."

# stop, remove containers netowrks and volumes
fclean:
	@$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	@docker volume prune -f
	@echo "Containers, networks, images and volumes have been removed."
	@echo "Removing /home/${USER}/data directory..."
	@sudo rm -rf /home/${USER}/data
	@echo "/home/${USER}/data directory removed."

# restart containers
re: fclean up

# check status of containers running
ps:
	@$(DOCKER_COMPOSE) ps

# tails logs for services
logs:
	@$(DOCKER_COMPOSE) logs -f

secrets:
	@echo "Copying and setting secrets..."
	@chmod 600 secrets/mysql_password.txt
	@chmod 600 secrets/wp_admin_password.txt
	@chmod 600 secrets/wp_editor_password.txt

.PHONY: all up down fclean re ps logs secrets