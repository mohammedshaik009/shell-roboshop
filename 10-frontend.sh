#!/bin/bash

source ./common.sh
check_root

dnf module disable nginx -y &>> $LOGS_FILE
dnf module enable nginx:1.24 -y &>> $LOGS_FILE
dnf install nginx -y &>> $LOGS_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>> $LOGS_FILE
systemctl start nginx &>> $LOGS_FILE
VALIDATE $? "enable and start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGS_FILE
VALIDATE $? removing existing code

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOGS_FILE
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOGS_FILE
VALIDATE $? "download and extracted the code"

cp nginx.conf /etc/nginx/nginx.conf &>> $LOGS_FILE
VALIDATE $? "created nginx configuration"

systemctl restart nginx &>> $LOGS_FILE
VALIDATE $? "restaring nginx"

print_total_time
