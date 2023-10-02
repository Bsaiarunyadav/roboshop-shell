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

cp Mongodb.repo /etc/yum.repos.d/Mongodb.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB to yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of MongoDB" 

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling of MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting of MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Editing of MongoDB conf" 

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting of MongoDB"



