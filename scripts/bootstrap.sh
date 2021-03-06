#!/usr/bin/env bash
#-------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

PROJ_DIR="${1}" # Required!!
cd "$PROJ_DIR"

#-------------------------------------------------------------------------------

#install basic dependencies
echo "> Updating OS package repositories"
sudo apt-get update >/dev/null

#install basic dependencies
sudo apt-get install -y redis-tools
  
if ! which git >/dev/null
then
  echo "> Installing Git version control"
  sudo apt-get install -y git >/dev/null 2>&1
fi

#install Python with virtual environment
rm -Rf /venv
./scripts/setup-python.sh

#install PostgreSQL client
./scripts/setup-postgresql.sh

#install Chrome (for acceptance testing)
./scripts/setup-chrome.sh

#install CloudFoundry CLI
./scripts/setup-cf.sh

#install Docker and Docker Compose
./scripts/setup-docker.sh

#run Docker applications
echo "> Running all Docker services"

# Remove any previously running containers and start fresh
docker-compose rm --stop --force web scheduler worker
rm -f "$PROJ_DIR/logs/celerybeat.pid"

docker-compose build
