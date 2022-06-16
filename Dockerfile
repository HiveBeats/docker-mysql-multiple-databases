FROM mysql/mysql-server:8.0.26
COPY create-multiple-mysql-databases.sh /docker-entrypoint-initdb.d/
