#!/bin/bash

app_name=frontend
source ./common.sh
check_root

dnf module disable nginx -y  &>> $LOGS_FILE
dnf module enable nginx:1.24 -y  &>> $LOGS_FILE
dnf install nginx -y  &>> $LOGS_FILE
VALIDATE $? "installing nginx"

rm -rf /usr/share/nginx/html/*  &>> $LOGS_FILE
VALIDATE $? "removing existing code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOGS_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip  &>> $LOGS_FILE
VALIDATE $? "downloaded and extracted code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "created nginx configuration"

systemctl enable nginx &>> $LOGS_FILE
systemctl restart nginx &>> $LOGS_FILE
VALIDATE $? "restarted nginx"
print_total_time