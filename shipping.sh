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



yum install maven -y &>>$LOGFILE

VALIDATE $? "installing maven"

useradd roboshop &>>$LOGFILE

VALIDATE $? "Adding user roboshop"

mkdir /app &>>$LOGFILE

VALIDATE $? "Making dir app"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip  &>>$LOGFILE

VALIDATE $? "Downloading artifact"

cd /app  &>>$LOGFILE

VALIDATE $? "Changing app"

unzip /tmp/shipping.zip  &>>$LOGFILE

VALIDATE $? "unzipping file"

mvn clean package &>>$LOGFILE

VALIDATE $? "Packaging shipping app"

mv target/shipping-1.0.jar shipping.jar  &>>$LOGFILE

VALIDATE $? "Remaining shipping jar"

cp /home/centos/roboshop-shell/shipping.service  /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "Copying shipping service"

systemctl daemon-reload

VALIDATE $? "Daemon reloading"

systemctl enable shipping 

VALIDATE $? "enabling shipping"

systemctl start shipping

VALIDATE $? "Starting shipping"

yum install mysql -y 

VALIDATE $? "installing mysql"

mysql -h mysql.awsdevopsjoin.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

VALIDATE $? "Loading cities and location info"

systemctl restart shipping

VALIDATE $? "restarting shipping"
 