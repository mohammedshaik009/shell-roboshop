#!/bin/bash

source ./common.sh
check_root

dnf install mysql-server -y &>> $LOGS_FILE
VALIDATE $? "installing mysql-server"

systemctl --now enable mysqld &>> $LOGS_FILE
VALIDATE $? "enable and start mysql-server"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGS_FILE
VALIDATE $? "setting up root password"

print_total_time