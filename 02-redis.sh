#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y  &>> $LOGS_FILE
dnf module enable redis:7 -y &>>  $LOGS_FILE
dnf install redis -y &>> $LOGS_FILE
VALIDATE $? "installing Redis:7"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable --now redis &>> $LOGS_FILE
VALIDATE $? "starting and enabling redis" 

print_total_time