#!/bin/bash

#You'll have to change the ID here to the one of your backup device!
plugin=`lsusb | grep 0781:5583 | wc -l`

if [ $plugin -eq 0 ]
then
    echo "Your USB device is not plugged in."
    logger Backup failed due to missing USB device
    exit 0
fi

while :
do
    echo "What do you want to backup?"
    read path
    exists=$path
if [ -d "$exists" ]
then
        echo "How should your backup be called?"
        read name
        #You'll  probably have to adjust the path of your usb device here
        space=$(df |grep /dev/sdb1 |awk '{print $4}')

        disc=$(du -sc $path |awk '{print $1}' |tail -n 1)

    if [ $disc -gt $space ]
    then
        echo "You don't have enough storage!"
        logger Backup failed: not enough storage
        exit 0
    fi
    echo "Your backup will start shortly..."
    sleep 5


    tar czf $name.tar $path
    cp $name.tar /media/demo/usb/
    rm $name.tar
    logger Backup successful
    echo "Done!"
    exit 0
else
    echo "That directory doesn't exist!"
    sleep 2
fi
done



