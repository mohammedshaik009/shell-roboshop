#!/bin/bash

name=catalogue
source ./common.sh
check_root
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGS_FILE
VALIDATE $? "adding mongo.repo"

dnf install mongodb-mongosh -y &>> $LOGS_FILE
VALIDATE $? "installing MongoDB-client"

INDEX=$(mongosh --host mongodb.nazeer.shop --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $? -lt 0 ]; then
    mongosh --host mongodb.nazeer.shop </app/db/master-data.js &>> $LOGS_FILE
    VALIDATE $? "Load Products"
else
    echo -e "$TIMESTAMP [INFO] products already loaded ....$Y SKIPPING $N"
fi

app_restart
print_total_time