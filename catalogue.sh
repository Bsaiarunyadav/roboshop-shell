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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "setting up npm source"

yum install nodejs -y  &>>$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop  &>>$LOGFILE
#Here we are not giving the validation as if once the user was created then 2nd time it will be failed definetly.
#IMPROVEMENT:- 1st check the user already exists or not if not exist then create.

# To check user :- cd /var
                #id roboshop

# if the user was added already then $? will be 1 if user not added then $? will be "0"

mkdir /app  &>>$LOGFILE
# Here also we wont right the validation if the /app dirc was already present then it will be failed . 
# Write a condition to check the directory already exist or not .


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip   &>>$LOGFILE

VALIDATE $? "Downloading catalogue artifact"

cd /app  &>>$LOGFILE

VALIDATE $? "Change dir app"

unzip -o /tmp/catalogue.zip  &>>$LOGFILE

VALIDATE $? "Unzipping catalogue.zip"

npm install  &>>$LOGFILE

VALIDATE $? "Installing dependencies"

# And here we will copy instead of editing as we already created the "catalogue.service"

# here we are giving the full path but not the absolute path .
# Give the full path of catalogue.service beacuse we are inside /app
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service  &>>$LOGFILE

VALIDATE $? "copying catalogue service"

systemctl daemon-reload  &>>$LOGFILE

VALIDATE $? "Reloading catalogue"

systemctl enable catalogue  &>>$LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue  &>>$LOGFILE

VALIDATE $? "Starting catalogue"

yum install mongodb-org-shell -y  &>>$LOGFILE

VALIDATE $? "Installing mongodb-org-shell client"

mongo --host mongodb.awsdevopsjoin.online </app/schema/catalogue.js  &>>$LOGFILE

VALIDATE $? "Loading schema"





# Here there is a small issue .

# we are taking the root access so we are in the root folder . and in the script we are moving the directories .so we give the full path insted of absolute path @ catalogue.service.
