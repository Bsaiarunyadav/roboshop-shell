#!/bin/bash

NAMES=$@  # here we will pass the app names thorugh command line
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-0b3a6df94f038e0fc
DOMAIN_NAME=awsdevopsjoin.online
HOSTED_ZONE_ID=Z02946853G9H9IVS4XYSF

for i in $@  # as we given a variable as $@ we given it as $@
do  
   if [[ $i == "mongodb" || $i == "mysql" ]]
   then     
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi    
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
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

#improvements 
# check instances already created or not 
# check route 53 record is already exsist, if exist update the route53 record.
