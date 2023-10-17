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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y  &>> $LOGFILE
 
VALIDATE $? "installing nodejs"

id roboshop &>> $LOGFILE

if [ $? -ne 0 ];
    then 
        useradd roboshop &>> $LOGFILE
fi

#useradd roboshop  &>> $LOGFILE 

VALIDATE $? "User adding roboshop"

mkdir -p /app &>> $LOGFILE

VALIDATE $? "making dir app"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

VALIDATE $? "downloading cart artifact"

cd /app &>> $LOGFILE

VALIDATE $? "Moving into app directory"

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "unzipping cart"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>> $LOGFILE

VALIDATE $? "copying cart.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"

# systemctl unmask cart.service

# VALIDATE $? "unmasking cart service"

systemctl enable cart  &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart  &>> $LOGFILE

VALIDATE $? "Starting cart"