# Find SD Card with:
# lsblk
# Unmount the card
# clear the cards content:
# sudo dd status=progress bs=4M if=/dev/zero of=/dev/mmcblk0 oflag=sync 

# sudo dd status=progress bs=4M if=~/Downloads/2019-09-26-raspbian-buster-full. of=/dev/mmcblk0 oflag=sync




DISC=/dev/mmcblk0 #TODO path to device (use lsblk to find it, use the device not the partitions!)
BOOT=/media/$USER/boot
ROOTFS=/media/$USER/rootfs
CURRENT_DIR=`pwd`
WPA_SUPPLICANT=$CURRENT_DIR/wpa_supplicant.conf
AUTHORIZED_KEYS=$CURRENT_DIR/authorized_keys
IMAGE=$CURRENT_DIR/images/2020-02-05-raspbian-buster-lite.img #TODO
DEFAULT_NAME=raspberrypi
PI_ETC=/media/$USER/rootfs/etc
    
function confirmation() {
    read -p "Continue (y/n)?" choice
    case "$choice" in 
        y|Y ) return 1;;
        n|N ) return 0;;
        * ) return 0;;
    esac
}

echo "Writing image to sd card"
confirmation
if [ "$?" = 1 ]
then
    echo "unmounting"
    udisksctl unmount -b ${DISC}p1
    udisksctl unmount -b ${DISC}p2
    # udisksctl unmount -b $DISC
    
    echo "Start Image Writing:"
    sleep 1
    # sudo dd status=progress bs=4M if=/dev/zero of=/dev/mmcblk0 oflag=sync 
    sudo dd status=progress bs=4M if=$IMAGE of=$DISC oflag=sync
    sleep 10

else
    # echo "Continue with SSH and WLAN configuration"
    sleep 1
fi

# TODO: After the image is written ensure that the paths for BOOT, ROOTFS and PI_ETC are still correct!
# echo "Continue with SSH and WLAN configuration"



echo "Setup WLAN and SSH?"
confirmation
if [ "$?" = 1 ]
then
    udisksctl mount -b ${DISC}p1
    udisksctl mount -b ${DISC}p2

    if [ -d $BOOT ] && [ -d $ROOTFS ]; then
        echo "Boot mounted!"
        echo "Enable ssh"
        touch $BOOT/ssh
        echo "Enable WLAN"
        cp $WPA_SUPPLICANT $BOOT/
        mkdir -p $ROOTFS/home/pi/.ssh
        echo "Copy ssh key"
        cp $AUTHORIZED_KEYS $ROOTFS/home/pi/.ssh/
    else
        echo "No boot dir!"
    fi

else
    # echo "Continue with SSH and WLAN configuration"
    sleep 1
fi


echo "Change hostname?"
confirmation
if [ "$?" = 1 ]
then
    udisksctl mount -b ${DISC}p1
    udisksctl mount -b ${DISC}p2

    read -p "Enter hostname: " piname
    sudo sed -i -e "s/$DEFAULT_NAME/$piname/g" $PI_ETC/$HOSTS_FILE
    sudo sed -i -e "s/$DEFAULT_NAME/$piname/g" $PI_ETC/$HOSTNAME_FILE

else
    # echo "Continue with SSH and WLAN configuration"
    sleep 1
fi


echo -n "unmount ..."
udisksctl unmount -b ${DISC}p1
udisksctl unmount -b ${DISC}p2

echo "Done!"
