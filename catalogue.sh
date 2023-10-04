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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>> $LOGFILE

VALIDATE $? "setting up npm source"

yum install nodejs -y  &>> $LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop  &>> $LOGFILE

VALIDATE $? "User adding roboshop"

mkdir /app  &>> $LOGFILE

VALIDATE $? "Making directiory app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip   &>> $LOGFILE

VALIDATE $? "Downloading application code"

cd /app &>>  $LOG_FILE

VALIDATE $? "Change dir app"

unzip /tmp/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Unzipping catalogue.zip"

cd /app  &>> $LOGFILE

VALIDATE $? "Change dir app"

npm install     &>> $LOGFILE

VALIDATE $? "Installing npm source"

cp Catalogue.service /etc/systemd/system/catalogue.service  &>> $LOGFILE

VALIDATE $? "copying catalogue service"

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "Reloading catalogue"

systemctl enable catalogue  &>> $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue  &>> $LOGFILE

VALIDATE $? "Starting catalogue"

yum install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "Installing mongodb-org-shell"

mongo --host mongodb.awsdevopsjoin.online </app/schema/catalogue.js  &>> $LOGFILE

VALIDATE $? "Loading schema"