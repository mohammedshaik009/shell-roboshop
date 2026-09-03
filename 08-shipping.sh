#!/bin/bash

source ./common.sh
app_name=shipping
check_root
app_setup
java_setup
systemd_setup
app_restart
print_total_time

MYSQL_HOST=mysql.mohammed.world

dnf install mysql -y &>> $LOGS_FILE
VALIDATE $? "installing mysql client"

mysql -h $MYSQL_HOST -u root -pRoboShop@1 -e "use cities" &>> $LOGS_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOGS_FILE
    VALIDATE $? "Data loaded"
else
    echo -e "Data already loaded ...$Y SKIPPING $N"
fi
