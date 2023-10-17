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

yum install python36 gcc python3-devel -y  &>>$LOGFILE

VALIDATE $? "Installing python"

useradd roboshop  &>>$LOGFILE

VALIDATE $? "Adding user"

mkdir /app   &>>$LOGFILE

VALIDATE $? "Making dir app"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>>$LOGFILE

VALIDATE $? "downloading artifact"

cd /app  &>>$LOGFILE

VALIDATE $? "Changing dir app"

unzip /tmp/payment.zip  &>>$LOGFILE

VALIDATE $? "Unzipping payment.zip"

pip3.6 install -r requirements.txt  &>>$LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

systemctl daemon-reload  &>>$LOGFILE

VALIDATE $? "daemon reloading"

systemctl enable payment  &>>$LOGFILE

VALIDATE $? "Enabling payment"

systemctl start payment  &>>$LOGFILE

VALIDATE $? "Starting payment"