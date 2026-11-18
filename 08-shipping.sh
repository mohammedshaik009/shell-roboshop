#!/bin/bash

name=shipping
source ./common.sh
check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>> $LOGS_FILE
VALIDATE $? "installing mysql-client"

COUNT=$(mysql -h $MYSQL_HOST -u root -pRoboShop@1 -Nse "SELECT COUNT(*) FROM information_schema.schemata WHERE SCHEMA_NAME = 'cities';")
if [ -z $COUNT ] || [ $COUNT -eq 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql 2>> $LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOGS_FILE
    VALIDATE $? "Load master data"
else
    echo -e "$TIMESTAMP [INFO] Master data already loaded ...$Y SKIPPING $N"
fi
