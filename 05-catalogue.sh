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

