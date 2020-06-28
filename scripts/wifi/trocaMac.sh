#Necessario ter instalado macchanger
#trocar o 'wlan0' pelo nome da sua placa de rede wi-fi
sudo ifconfig wlan0 down
sudo macchanger -a wlan0
sudo ifconfig wlan0 up
