#!/bin/bash

#now we previous discussed about array same way just giving a variable
NAMES=("Web" "mongodb" "catlaogue" "cart" "user" "redis" "mysql" "shipping" "rabbitmq" "payment" "dispatch")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-0b3a6df94f038e0fc
DOMAIN_NAME=awsdevopsjoin.online

for i in "${NAMES[@]}"  
do  
   if [[ $i == "mongodb" || $i == "mysql" ]]
   then     
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi    
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id Z02946853G9H9IVS4XYSF --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done 

#Here you are  creating the instance and that is giving the Ipaddress and saving them in the variable called IP_ADDRESS.

# How to improvise the script
#1)check the instance was already created or not 
#2)update route 53 record


#Just change the route 53 AWs change record sets and use different command to update the records with new Ipadress