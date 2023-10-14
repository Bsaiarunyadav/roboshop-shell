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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Installing repo file"

yum module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Enabling module 6.2"

yum install redis -y  &>> $LOGFILE

VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  &>> $LOGFILE

VALIDATE $? "Updating address"

systemctl enable redis  &>> $LOGFILE

VALIDATE $? "enabling redis"

systemctl start redis  &>> $LOGFILE

VALIDATE $? "Starting redis"