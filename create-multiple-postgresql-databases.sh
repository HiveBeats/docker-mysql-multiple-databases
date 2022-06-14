#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$1
	echo "  Creating database '$database'"
	#mysql -u$DB_USER -p$DB_PASS dbname<<
	mysql -u"root" -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
	    CREATE DATABASE IF NOT EXISTS `$database`;
	    GRANT ALL ON `$database`.* TO '$MYSQL_USER'@'%';
EOSQL
}

if [ -n "$MYSQL_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $MYSQL_MULTIPLE_DATABASES"
	for db in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi
