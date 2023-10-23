#!/bin/bash

#now we previous discussed about array same way just giving a variable
NAMES=("Web" "mongodb" "catlaogue" "cart" "user" "redis" "mysql" "shipping" "rabbitmq" "payment" "dispatch")
        

for i in "${NAMES[@]}"  
do 
    echo "ALL NAMES: $i"
done 