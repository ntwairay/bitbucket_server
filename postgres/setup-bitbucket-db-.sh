#!/bin/bash
echo "******CREATING Bitbucket DATABASE******"
psql --username postgres <<- EOSQL
  CREATE DATABASE bitbucketdb;
  CREATE USER bitbucket WITH PASSWORD 'insert_bitbucket_db_password_here';
  ALTER USER bitbucket WITH SUPERUSER;
EOSQL
echo ""

{ echo; echo "host bitbucket bitbucket 0.0.0.0/0 trust"; } >> "$PGDATA"/pg_hba.conf

if [ -r '/tmp/dumps/bitbucket.dump' ]; then
    echo "**IMPORTING Bitbucket DATABASE BACKUP**"
    gosu postgres postgres &
    SERVER=$!; sleep 2
    gosu postgres psql bitbucket < /tmp/dumps/bitbucket.dump
    kill $SERVER; wait $SERVER
    echo "**Bitbucket DATABASE BACKUP IMPORTED***"
fi

echo "******Bitbucket DATABASE CREATED******"
