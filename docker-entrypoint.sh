#!/bin/bash

username=${DB_USERNAME:-iris}
database=${DB_DATABASE:-iris}
password=${DB_PASSWORD:-iris}
host=${DB_HOST:-localhost}
db_port=${DB_PORT:-5432}
port=${PORT:-8080}

echo "Wait until database $host:$db_port is ready..."
until nc -z $host $db_port
do
  sleep 1
done

databases=$(psql \
  -h $host \
  -p $db_port \
  -U $username \
  -W $password \
  -d postgres \
  -c '\l' | \
  grep $database)

# if the database exists then don't re-create it
if [ -z $database ]
then
  psql \
    -h $host \
    -p $db_port \
    -U $username \
    -W $password \
    -d $database \
    -f db/schema_0.psql.sql
fi

# create a yml file for this app
config=configs/config.yaml

cp configs/config.dev.yaml $config

yq --yaml-output '.db.conn.kwargs.scheme = "postgresql+pygresql"' > $config.tmp && mv $config.tmp $config
yq --yaml-output '.db.conn.kwargs.user = "'$user'"' > $config.tmp && mv $config.tmp $config
yq --yaml-output '.db.conn.kwargs.password = "'$password'"' > $config.tmp && mv $config.tmp $config
yq --yaml-output '.db.conn.kwargs.database = "'$database'"' > $config.tmp && mv $config.tmp $config
yq --yaml-output '.db.conn.kwargs.host = "'$host'"' > $config.tmp && mv $config.tmp $config
yq --yaml-output '.db.conn.kwargs.port = '$db_port > $config.tmp && mv $config.tmp $config

yq --yaml-output '.server.port = '$port'' > $config.tmp && mv $config.tmp $config

forego start
