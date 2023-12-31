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

if ! yum module list -e enabled mysql &> /dev/null; then
    sudo yum module disable mysql -y
else
    echo "MySQL module is already disabled."
fi


#yum module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disabling the default version"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copying MySQL repo" 

yum install mysql-community-server -y  &>> $LOGFILE

VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling MySQL"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "Staring MySQL"

mysql_secure_installation --set-root-pass RoboShop@1  &>> $LOGFILE

VALIDATE $? "setting up root password"




