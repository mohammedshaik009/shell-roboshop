#!/bin/bash

LOGS_FOLDER=/var/log/shell-script
sudo mkdir -p $LOGS_FOLDER
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
SCRIPT_DIR=$PWD
MYSQL_HOST=mysql.mohammed.world
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
#check root access or not
if [ $USERID -ne 0 ]; then
    echo -e "$TIMESTAMP [ERROR] $R please run this script with root access $N" | tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$TIMESTAMP [ERROR] $2 is...$R FAILED $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$TIMESTAMP [INFO] $2 is...$G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf install maven -y &>> $LOGS_FILE
VALIDATE $? "installing maven"

id roboshop &>> $LOGS_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
    VALIDATE $? "creating system user"
else
    echo -e "system user already created ...$Y SKIPPING $N"
fi

rm -rf /app  &>> $LOGS_FILE
VALIDATE $? "removing app directory"

mkdir -p /app  &>> $LOGS_FILE
VALIDATE $? "creating app directory"

rm -rf /tmp/shipping.zip  &>> $LOGS_FILE
VALIDATE $? "removing existing code"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>> $LOGS_FILE
cd /app &>> $LOGS_FILE
unzip /tmp/shipping.zip &>> $LOGS_FILE
VALIDATE $? "download and extracted the code"

cd /app &>> $LOGS_FILE
mvn clean package &>> $LOGS_FILE
mv target/shipping-1.0.jar shipping.jar &>> $LOGS_FILE
VALIDATE $? "installing dependencies"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>> $LOGS_FILE
VALIDATE $? "creating systemd service"

dnf install mysql -y &>> $LOGS_FILE
VALIDATE $? "installing mysql client"


mysql -h mysql.mohammed.world -u root -pRoboShop@1 -e "use cities" &>> $LOGS_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOGS_FILE
    VALIDATE $? "Load products"
else
    echo -e "Data already loaded ...$Y SKIPPING $N"
fi

systemctl enable shipping &>> $LOGS_FILE
systemctl restart shipping &>> $LOGS_FILE
VALIDATE $? "restarting shipping"