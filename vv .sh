cp Mongodb.repo /etc/yum.repos.d/Mongodb.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of MongoDB" 

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Editing MongoDB conf" 

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"