#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
N="\e[0m"
Y="\e[33m"
G="\e[32m"


if [ $USERID -ne 0 ];
then 
    echo -e "$R ERROR :: Run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
        echo -e "$2 ... $R FAILURE $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG_FILE

VALIDATE $? "setting up npm source"

yum install nodejs -y &>> $LOG_FILE

VALIDATE $? "Installing nodejs"

useradd roboshop &>> $LOG_FILE

VALIDATE $? "User adding roboshop"

mkdir /app &>> $LOG_FILE

VALIDATE $? "Making directiory app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG_FILE

VALIDATE $? "Downloading application code"

cd /app &>> $LOG_FILE

VALIDATE $? "Change dir app"

unzip /tmp/catalogue.zip &>> $LOG_FILE

VALIDATE $? "Unzipping catalogue.zip"

cd /app &>> $LOG_FILE

VALIDATE $? "Change dir app"

npm install  &>> $LOG_FILE

VALIDATE $? "Installing npm source"

cp Catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE

VALIDATE $? "copying catalogue service"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "Reloading catalogue"

systemctl enable catalogue &>> $LOG_FILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> $LOG_FILE

VALIDATE $? "Starting catalogue"

yum install mongodb-org-shell -y &>> $LOG_FILE

VALIDATE $? "Installing mongodb-org-shell"

mongo --host mongodb.awsdevopsjoin.online </app/schema/catalogue.js &>> $LOG_FILE

VALIDATE $? "Loading schema"