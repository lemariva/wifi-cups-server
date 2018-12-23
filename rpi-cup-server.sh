#!/bin/bash

echo "please enter the SSID name and press enter to continue:"
read SSID
echo "please enter the PASSWORD for the "$SSID" network and press enter to continue:"
read PASSWORD
history -c

echo "installing system packages..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git nano -y

echo "installing Docker..."
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi

# Docker 18.09.0CE is not working properly -> 18.06.1 is the alternative
# apt-cache madison docker-ce
echo "downgrading Docker..."
sudo apt-get install docker-ce=18.06.1~ce~3-0~raspbian -y

# pulling docker images
echo "pulling Docker images..."
sudo docker pull portainer/portainer
sudo docker pull cjimti/iotwifi
sudo docker pull txn2/asws:armhf-1.2.3
sudo docker pull lemariva/rpi-cups

# wificfg_configuration
echo "downloading configurations and updating ssid/password"
wget https://raw.githubusercontent.com/cjimti/iotwifi/master/cfg/wificfg.json
sed -i 's/iot-wifi-cfg-3/'"$SSID"'/' wificfg.json
sed -i 's/iotwifipass/'"$PASSWORD"'/' wificfg.json
unset PASSWORD
unset SSID

echo "Downloading www files..."
git clone https://github.com/lemariva/wifi-cups-server.git
mv wifi-cups-server/iot-website $(pwd)/www

echo "starting to run the Containers..."
echo "portainer runs on <ip-address>:9000. Please change the password!"
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
echo "to configure the internet access go to  <ip-adress>:80"
sudo docker run -d --restart unless-stopped -e DEBUG=true -p 80:80 -v $(pwd)/www:/www txn2/asws:armhf-1.2.3
echo "CUPS running on  <ip-adress>:631"
sudo docker run -d --restart unless-stopped -p 631:631 --privileged -v /var/run/dbus:/var/run/dbus -v /dev/bus/usb:/dev/bus/usb lemariva/rpi-cups

echo "stoping wpa_supplicant..."
# prevent wpa_supplicant from starting on boot
sudo systemctl mask wpa_supplicant.service
# rename wpa_supplicant on the host to ensure that it is not used.
sudo mv /sbin/wpa_supplicant /sbin/no_wpa_supplicant
# kill any running processes named wpa_supplicant
sudo pkill wpa_supplicant
# delete credentials
sudo rm /etc/wpa_supplicant/wpa_supplicant.conf

echo "Iotwifi running on host"
sudo docker run -d --restart unless-stopped --privileged --net host -v $(pwd)/wificfg.json:/cfg/wificfg.json  cjimti/iotwifi
