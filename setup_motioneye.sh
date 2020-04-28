#!/bin/bash

# see: https://github.com/ccrisan/motioneye/wiki/Install-On-Raspbian

# setup dependencies
set -e


sudo apt -y update
sudo apt -y dist-upgrade


sudo apt -y install ffmpeg libmariadb3 libpq5 libmicrohttpd12
wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb

sudo dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
sudo apt -y install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev

sudo pip install motioneye --no-cache-dir
sudo mkdir -p /etc/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
sudo mkdir -p /var/lib/motioneye

sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
sudo systemctl daemon-reload
sudo systemctl enable motioneye
sudo systemctl start motioneye
