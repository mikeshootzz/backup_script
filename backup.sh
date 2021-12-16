#!/bin/bash

einsteckung=`lsusb | grep 0781:5583 | wc -l`

if [ $einsteckung -eq 0 ]
then
    echo "Kein USB Stick eingesteckt."
    logger Backup failed due to missing USB device
    exit 0
fi

while :
do
    echo "wovon möchtest du ein Backup machen?"
    read path
    exists=$path
if [ -d "$exists" ]
then
        echo "Wie soll dein Backup heissen?"
        read name
        space=$(df |grep /dev/sdb1 |awk '{print $4}')

        disc=$(du -sc $path |awk '{print $1}' |tail -n 1)

    if [ $disc -gt $space ]
    then
        echo "Zu wenig Speicherplatz verfügbar!"
        logger Backup failed: not enough storage
        exit 0
    fi
    echo "Dein Backup beginnt in Kürze..."
    sleep 5


    tar czf $name.tar $path
    cp $name.tar /media/demo/usb/
    rm $name.tar
    logger Backup successful
    echo "Done!"
    exit 0
else
    echo "Diesen Pfad gibt es nicht!"
    sleep 2
fi
done



