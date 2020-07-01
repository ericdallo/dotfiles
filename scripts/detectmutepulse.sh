#!/usr/bin/env bash

value=$(pulsemixer --id 0 --get-mute)
volume=$(pulsemixer --id 0 --get-volume | grep '' | awk -F' ' '{print $2}')

if  [[ $value = '0' ]]; then
    echo 'Unmuted'
    #echo 'Unmuted : '$volume
elif [[ $value = '1' ]];  then
    echo 'Muted'
else
    echo 'Unknown'
fi
