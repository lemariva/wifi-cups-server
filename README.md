# wifi-cups-server
This is a Plug&Play solution, which runs on Docker to make your old printer Wi-Fi compatible. You only need a Raspberry Pi with Wi-Fi (e.g. Zero W, 3B/3B+ - or 1/2 with Wi-Fi dongle). 

Three Docker containers take care of everything:
* `lemariva/iotwifi`: this is a `wpa_supplicant` configurator. The container starts an AP (access point), which allows you to configure the Raspberry Pi connection to your Wi-Fi.
* `txn2/asws:armhf-1.2.3`: this runs a `https` server and gives you a page to configure the credentials to access your Wi-Fi. 
* `lemariva/rpi-cups:latest`: this runs a [CUPS server](https://de.wikipedia.org/wiki/Common_Unix_Printing_System).

Visit this article to get more information and detailed instructions: [#Raspberry Pi: CUPS Printer Server using Docker](https://lemariva.com/blog/2019/02/raspberry-pi-cups-printer-server-using-docker)

## Instructions
You can read [this article](https://lemariva.com/blog/2019/02/raspberry-pi-cups-printer-server-using-docker) for detailed instructions, if you don't want to, you only need to type the following on a Raspberry Pi terminal:
```shell
$ wget https://raw.githubusercontent.com/lemariva/wifi-cups-server/master/rpi-cup-server.sh
$ chmod +x rpi-cup-server.sh
$ ./rpi-cup-server.sh
```
 The bash file asks you for a SSID and a PASSWORD. These values are for the AP (access-point). Choose them correctly: it should not be your/neighbor network SSID, and the PASSWORD should be secure. After this, the bash file starts to install everything automatically (grab a cup of tea!).
 Then follows [these instructions](https://lemariva.com/blog/2019/02/raspberry-pi-cups-printer-server-using-docker#how-to-use-the-rpi-cups-server-370867).

 ## License
* Apache 2.0