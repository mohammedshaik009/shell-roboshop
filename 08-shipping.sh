#!/bin/bash

name=shipping
source ./common.sh
check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>> $LOGS_FILE
VALIDATE $? "installing mysql-client"
