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


zip_file="/tmp/catalogue.zip"
target_directory="/app"
indicator_file="$target_directory/.unzipped"


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

useradd roboshop   &>> $LOGFILE 

VALIDATE $? "User adding roboshop"

mkdir /app &>> $LOGFILE

VALIDATE $> "making dir app"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

VALIDATE $? "downloading cart artifact"

cd /app &>> $LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/cart.zip &>> $LOGFILE

if [ -f "$indicator_file" ]; then
    # Indicator file exists, skip the unzipping step
    echo "Target $target_directory already contains the expected content. Skipping unzipping."
else
    # Target does not contain the indicator file, unzip the file
    unzip "$zip_file" -d "$target_directory"

    # Create the indicator file to signal that unzipping is complete
    touch "$indicator_file"

    echo "File $zip_file has been unzipped to $target_directory."
fi
# Explanation:

# The script checks for the existence of an "indicator file" (e.g., .unzipped) in the target directory. The presence of this file indicates that the content has already been unzipped.

# If the indicator file exists, the script prints a message and skips the unzipping step.

# If the indicator file does not exist, the script proceeds with the unzipping process using the unzip command.

# After successful unzipping, the script creates the indicator file to signal that the unzipping process has been completed.

# You can customize the script based on your specific use case and requirements. If you have a different way of determining whether the content is already present, adjust the logic accordingly. The key is to have a reliable indicator that allows you to determine whether the unzipping step should be skipped.




VALIDATE $? "unzipping cart"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>> $LOGFILE

VALIDATE $? "copying cart.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"

systemctl unmask cart.service

VALIDATE $? "unmasking cart service"

systemctl enable cart  &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart  &>> $LOGFILE

VALIDATE $? "Starting cart"