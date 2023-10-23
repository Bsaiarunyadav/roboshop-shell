#!/bin/bash

#now we previous discussed about array same way just giving a variable
NAMES=("Web" "mongodb" "catlaogue" "cart" "user" "redis" "mysql" "shipping" "rabbitmq" "payment" "dispatch")
        

for a in "${NAMES[@]}"  
do 
    echo "ALL NAMES: $a"
done 