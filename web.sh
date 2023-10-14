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





yum install nginx -y

VALIDATE $? "installing nginx"

systemctl enable nginx

VALIDATE $? "enabling ngnix"

systemctl start nginx

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing the default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading frontend content"

cd /usr/share/nginx/html

VALIDATE $? "Extracting front end content"

unzip /tmp/web.zip

VALIDATE $? "unzipping web"

cp /home/centos/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf

VALIDATE $? "copying roboshop.conf

systemctl restart nginx 

VALIDATE $? "restarting nginx"