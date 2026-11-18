#!/bin/bash

source ./common.sh
check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGS_FILE
VALIDATE $? "adding mongo.repo"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "installing MongoDB"

systemctl --now enable mongod &>> $LOGS_FILE
VALIDATE $? "enable and start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGS_FILE
VALIDATE $? "allow remote connections to all"

systemctl restart mongod &>> $LOGS_FILE
VALIDATE $? "restarting MongoDB"

print_total_time