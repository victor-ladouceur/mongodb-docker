#!/bin/bash

################@################
# - Load mongodb-functions file #
#################################
source /data/scripts/mongodb-functions.sh

#######################################
# - Create MongoDB user administrator #
#######################################
start_mongo 1
wait_for_mongo
create_db_user 1
stop_mongo

#############################
# - Create MongoDB user app #
#############################
start_mongo 2
wait_for_mongo
create_db_user 2
stop_mongo
