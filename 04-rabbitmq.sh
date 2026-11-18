#!/bin/bash

source ./common.sh
check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LOGS_FILE
VALIDATE $? "adding rabbitmq.repo"

dnf install erlang rabbitmq-server -y  &>> $LOGS_FILE
VALIDATE $? "installing rabbitmq-server"

systemctl --now enable rabbitmq-server  &>> $LOGS_FILE
VALIDATE $? "enable and start rabbitmqserver"

rabbitmqctl add_user roboshop roboshop123  &>> $LOGS_FILE
VALIDATE $? "adding roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGS_FILE
VALIDATE $? "setting up roboshop permissions"

print_total_time