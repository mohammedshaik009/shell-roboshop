#!/bin/bash

source ./common.sh

dnf install mysql-server -y &>> $LOGS_FILE
VALIDATE $? "installing mysql"

systemctl enable mysqld  &>> $LOGS_FILE
systemctl start mysqld  &>> $LOGS_FILE
VALIDATE $? "enabling and starting"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "setting up root password"

print_total_time