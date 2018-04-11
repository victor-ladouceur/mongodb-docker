#!/bin/bash

#####################################
# - Wait for MongoDB server started #
#   before executing some code      #
#####################################
wait_for_mongo() {
  echo "[INFO] -> Wait until MongoDB server is up and running..."
  while netstat -lnt | awk '$4 ~ /:27017$/ {exit 1}'; do sleep 10; done
}

##############################################
# - Create user in function of its type      #
# - args: 1 -> admin user or 2 -> guest user #
# - exception: if parameters not equals 1|2  #
##############################################
create_db_user() {
  if [ $1 -eq 1 ]
  then
    echo "[INFO] -> Creating administrative user on MongoDB server"
    /mongodb/bin/mongo "$MONGODB_ADMIN_DB" --eval "db.createUser({ user: '$MONGODB_ADMIN_ID', pwd: '$MONGODB_ADMIN_PASS', roles: [ { role: 'userAdminAnyDatabase', db: '$MONGODB_ADMIN_DB' } ] });"
  elif [ $1 -eq 2 ]
  then
    echo "[INFO] -> Creating application user on MongoDB server"
    /mongodb/bin/mongo -u "$MONGODB_ADMIN_ID" -p "$MONGODB_ADMIN_PASS" --authenticationDatabase "$MONGODB_ADMIN_DB" --eval "db.createUser({ user: '$MONGODB_GUEST_ID', pwd: '$MONGODB_GUEST_PASS', roles: [ { role: 'readWrite', db: '$MONGODB_GUEST_DB' } ] });"
  else
      echo "[ERROR] -> unrecognized parameter, only 1 or 2 are accepted as args!"
  fi
}

##############################################
# - Start mongo with or without auth process #
# - args: 1 -> no auth 2 -> with auth        #
# - exception: if parameters not equals 1|2  #
##############################################
start_mongo() {
  if [ $1 -eq 1 ]
  then
    echo "[INFO] -> Connecting to MongoDB without security"
    /mongodb/bin/mongod --dbpath /data/db &
  elif [ $1 -eq 2 ]
  then
    echo "[INFO] -> Connecting to MongoDB within security"
    /mongodb/bin/mongod --auth --dbpath /data/db &
  else
    echo "[ERROR] -> unrecognized parameter, only 1 or 2 are accepted as args!"
  fi
}

########################
# - Stop mongo process #
########################
stop_mongo() {
  echo "[INFO] -> Stopping MongoDB server..."
  /mongodb/bin/mongod --shutdown
}
