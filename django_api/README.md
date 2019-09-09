# Trekbook API

The Trekbook API is a containerized django server. All source code is mounted in the docker volume, so any changes to this directory will be present in the container. 

## Prerequisites

* You MUST have docker installed
* If you do not have it, follow the instructions at [docker installation tutorial](https://docs.docker.com/v17.09/engine/installation/#supported-platforms)

## Setup

* First step is to build the containers
```bash
make build
```
* After, we spool up the containers
```bash
make run
```
* Once the containers are running, create an superuser to be able to login
```bash
make createadmin
```
* Follow the remaining instructions to set a password
* The username for the admin account created is `admin`

* The environment is now set up and visible at [0.0.0.0:8000](http://0.0.0.0:8000/)

* Navigate to [0.0.0.0:8000/admin](http://0.0.0.0:8000/admin) to view and login to the django admin page using the superuser you created
