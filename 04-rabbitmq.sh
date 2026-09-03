#!/bin/bash

source ./common.sh

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding rabbitmq.repo"

dnf install rabbitmq-server -y &>> $LOGS_FILE
VALIDATE $? "installing Rabbitmq"

systemctl enable --now rabbitmq-server &>> $LOGS_FILE
VALIDATE $? "starting and enabling"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGS_FILE
VALIDATE $? "creating Rabbitmq user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> $LOGS_FILE
VALIDATE $? "setting up Rabbitmq permissions"

print_total_time