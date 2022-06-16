# Using multiple databases with the official MySQL Docker image

The [official recommendation](https://hub.docker.com/_/mysql/) for creating
multiple databases is as follows:

*When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables. Furthermore, it will execute files with extensions .sh, .sql and .sql.gz that are found in /docker-entrypoint-initdb.d. Files will be executed in alphabetical order. You can easily populate your mysql services by mounting a SQL dump into that directory and provide custom images with contributed data. SQL files will be imported by default to the database specified by the MYSQL_DATABASE variable.*

This directory contains a script to create multiple databases using that
mechanism.

## Usage

### By mounting a volume

Clone the repository, mount its directory as a volume into
`/docker-entrypoint-initdb.d` and declare database names separated by commas in
`MYSQL_MULTIPLE_DATABASES` environment variable as follows
(`docker-compose` syntax):

    myapp-db:
        image: "mysql/mysql-server:8.0.26"
        restart: always
        environment:
            MYSQL_MULTIPLE_DATABASES: db1,db2,db3
            MYSQL_ROOT_PASSWORD: passw0rd
            MYSQL_USER: john
            MYSQL_PASSWORD: passw0rd
            MYSQL_ROOT_HOST: 172.*.*.*
        volumes:
            - ./sqlinit:/docker-entrypoint-initdb.d

### By building a custom image

Clone the repository, build and push the image to your Docker repository,
for example for Google Private Repository do the following:

    docker build --tag=eu.gcr.io/your-project/mysql-multi-db .
    gcloud docker -- push eu.gcr.io/your-project/mysql-multi-db

You still need to pass the `MYSQL_MULTIPLE_DATABASES` environment variable
to the container:

    myapp-db:
        image: eu.gcr.io/your-project/mysql-multi-db
        restart: always
        environment:
            MYSQL_MULTIPLE_DATABASES: db1,db2,db3
            MYSQL_ROOT_PASSWORD: passw0rd
            MYSQL_USER: john
            MYSQL_PASSWORD: passw0rd
            MYSQL_ROOT_HOST: 172.*.*.*
