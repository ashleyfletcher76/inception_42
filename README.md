# Inception Project

**Inception** is a system administration project that leverages **Docker** to create a virtualized infrastructure composed of multiple services running in isolated containers. The goal of this project is to set up a small infrastructure with containers that run NGINX, MariaDB, and WordPress, connected through a Docker network. The containers are built from scratch using custom **Dockerfiles** and must follow strict rules regarding best practices.

## Table of Contents
- [Project Description](#project-description)
- [Features](#features)
- [Directory Structure](#directory-structure)
- [Installation](#installation)
- [Makefile Usage](#makefile-usage)
- [Authors](#authors)

## Project Description

Inception is designed to broaden your knowledge of system administration by using **Docker**. It involves setting up a virtual infrastructure where each service (NGINX, WordPress, MariaDB) runs in a separate container. These containers must be built using Alpine or Debian images (excluding pre-made solutions like DockerHub) and must adhere to best practices such as using **environment variables** and **Docker secrets** for storing sensitive information.

The project includes the following components:
- **NGINX**: A web server with TLSv1.2 or TLSv1.3 support.
- **WordPress**: A content management system (CMS) with **php-fpm** for processing PHP.
- **MariaDB**: A database management system used to store WordPress data.
- **Volumes**: One for the WordPress website files and another for the database.
- **Docker Network**: A private network connecting all the containers.

## Features

- **NGINX** running with TLSv1.2/1.3 for secure HTTPS connections.
- **WordPress** + **php-fpm** installed and configured inside its own container.
- **MariaDB** container managing the WordPress database.
- Persistent storage using Docker volumes for both the website files and the database.
- A custom domain `yourlogin.42.fr` pointing to your local environment using Docker.
- Fully automated setup with a Makefile, ensuring easy deployment and management.

## Directory Structure

The directory structure follows best practices to separate source files, secrets, and Docker configurations:

```plaintext
.
├── Makefile
├── secrets
│   ├── mysql_password.txt
│   ├── mysql_root_password.txt
│   ├── wp_admin_password.txt
│   ├── wp_editor_password.txt
├── srcs
│   ├── docker-compose.yml
│   ├── requirements
│   │   ├── mariadb
│   │   │   └── Dockerfile
│   │   ├── nginx
│   │   │   └── Dockerfile
│   │   ├── wordpress
│   │   │   └── Dockerfile
│   │   └── tools
└── volumes
    ├── mariadb
    └── wordpress
```

## Installation
To get started with the Inception project, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/yourusername/inception.git
cd inception
```
2. Prepare directories and build the infrastructure: Run the following make commands:
```bash
make new
```

This will:

- Prepare the directories for MariaDB and WordPress volumes.
- Build Docker images for NGINX, WordPress, and MariaDB.
- Launch all services as Docker containers.

3. Access your services:

- Open your web browser and navigate to https://yourlogin.42.fr (replace yourlogin with your actual 42 login).
- WordPress will be accessible, and you can start setting it up.

## Makefile Usage
The Makefile in this project automates many tasks. Below are the key targets:

- make all: Prepares the necessary directories and brings up all the services.
- make up: Builds and starts the Docker containers in detached mode.
- make new: Rebuilds all Docker containers from scratch without using the cache.
- make down: Stops all running containers but preserves the volumes.
- make fclean: Stops all containers and removes containers, images, volumes, and the data directory.
- make re: Cleans everything and restarts the entire setup.
- make ps: Shows the status of all running containers.
- make logs: Tails the logs of all running services.

Example Commands:
```bash
make re
```
```bash
make all
```
```bash
make logs
```
```bash
make fclean
```
```bash
make ps
```

and more...

## Authors

- **Ashley Fletcher** - *Developer* - [GitHub Profile](https://github.com/ashleyfletcher76)
