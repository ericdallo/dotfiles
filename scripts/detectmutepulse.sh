#!/usr/bin/env bash

value=$(pulsemixer --get-mute)
volume=$(pulsemixer --get-volume | grep '' | awk -F' ' '{print $2}')

if  [[ $value = '0' ]]; then
    echo 'Unmuted'
    #echo 'Unmuted : '$volume
elif [[ $value = '1' ]];  then
    echo 'Muted'
else
    echo 'Unknown'
fi
