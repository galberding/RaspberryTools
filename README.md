# RaspberryTools

This repository is intended to setup a working raspbian image as fast as possible.

## Features
* Writing images to sd card
* Setup WLAN
* Setup SSH (with key if you set it up correctly)
* Change Hostname

## Setup
Only use the script **IF YOU KNOW WHAT YOU ARE DOING!!!!** 
The image write process can easily **override your harddrive** if you set a wrong path!


### Images
* create directory and get latest [Raspbean Buster Lite](https://www.raspberrypi.org/downloads/raspbian/) image 
```
mkdir -p images && cd images
wget https://downloads.raspberrypi.org/raspbian_lite_latestcd 
unzip 

```
* Adapt path in ```flashimage.sh**
**Note: We assume that the sd card is formated(eg. with gparted)**

### WLAN
* Adapt the ```wpa_supplicant.conf```
* More examples can be found [here](https://github.com/ccrisan/motioneyeos/wiki/Wifi-Preconfiguration)
* This file will be moved to the sd card after the writing process

### SSH key generation
* Example key generation:
```
ssh-keygen -t rsa -b 4096
```
* Add key to ```authorized_keys```
```
cat key.pub > authorized_keys
```
* Keep in mind that you still need to disable password authentication!

## General Info
* Take a look at the TODOs in flashimage.sh
* Raspberry Pi credentials: Username: pi, Password: raspberry
* You can usually reach a raspberry (connected to the network) by its hostname:
```bash
# SSH to pi with default hostname
ssh pi@raspberry.local
```
