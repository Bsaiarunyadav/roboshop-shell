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

username="roboshop"

directory="/app"


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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$LOGFILE

VALIDATE $? "Nodejs nodesource"

yum install nodejs -y  &>>$LOGFILE

VALIDATE $? "Installing node js"

useradd roboshop  &>>$LOGFILE

if id "$username"
    then
        echo -e "$R User $username already exists. Skipping user creation $N"
    else
        useradd "$username"
        echo -e "$Y User $username has been added $N"
fi


VALIDATE $? "User add"

mkdir /app  &>>$LOGFILE

if [ -d "$directory" ]; 
    # Directory exists, skip the step
    then
    echo -e "$R Directory $directory already exists. Skipping directory creation $N"
else
    # Directory does not exist, create the directory
    mkdir -e "$G $directory $N"
    echo -e "$Y Directory $directory has been created $N"
fi
  
VALIDATE $? "Making dir app"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>>$LOGFILE

cd /app   &>>$LOGFILE

VALIDATE $? "CD app"

unzip /tmp/user.zip  &>>$LOGFILE

VALIDATE $? "unzippping user"

npm install   &>>$LOGFILE

VALIDATE $? "Installing NPM"

cp /home/centos/roboshop-shell/user.service  /etc/systemd/system/user.service  &>>$LOGFILE

VALIDATE $? "Systemd userservice"

systemctl daemon-reload  &>>$LOGFILE

VALIDATE $? "Reloading user"

systemctl enable user   &>>$LOGFILE

VALIDATE $? "enabling user"

systemctl start user  &>>$LOGFILE

VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/Mongodb.repo /etc/yum.repos.d/Mongodb.repo  &>>$LOGFILE

VALIDATE $? "Copying repo file"

yum install mongodb-org-shell -y  &>>$LOGFILE

VALIDATE $? "Installing mongod client"

mongo --host mongodb.awsdevopsjoin.online </app/schema/user.js  &>>$LOGFILE

VALIDATE $? "Loading schema"