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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>$LOGFILE

VALIDATE $? "components repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>$LOGFILE

VALIDATE $? "Yum repos for rabbitmq"

yum install rabbitmq-server -y  &>>$LOGFILE

VALIDATE $? "installing rabbitmq"

systemctl enable rabbitmq-server  &>>$LOGFILE

VALIDATE $? "Enabling rabbitmq"

systemctl start rabbitmq-server  &>>$LOGFILE

VALIDATE $? "Starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "Adding user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "Setting permissions"
