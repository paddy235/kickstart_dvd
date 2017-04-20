#!/usr/bin/env bash
# 2017-04-10
# reference - http://www.nathanboyce.com/automatic-centos-6-installation-dvd-with-kickstart/

BASE_DIR=`pwd`
MOUNT_DIR=${BASE_DIR}/iso
BUILD_DIR=${BASE_DIR}/custom_iso
ISO_DIR=/root/iso
ISO_FILE=CentOS-6.9-x86_64-bin-DVD1.iso
C_ISO_FILE=grvy_CentOS-6.9-x86_64-bin-DVD1.iso

echo "====================================="
echo "Base Directory	: ${BASE_DIR}"
echo "ISO Directory	: ${MOUNT_DIR}"
echo "BUILD Directory	: ${BUILD_DIR}"
echo 
echo "ISO File	: ${ISO_FILE}"
echo "custom ISO File	: ${C_ISO_FILE}"
echo "====================================="
echo 
sleep 1

echo "cleaning previous build files"
echo "====================================="
rm -rf $C_ISO_FILE
rm -rf ${MOUNT_DIR} ${BUILD_DIR}
sleep 1

echo "start build"
echo "====================================="
mkdir ${MOUNT_DIR} ${BUILD_DIR}
mkdir ${BUILD_DIR}/{ks,post}
sleep 1

echo
echo "mount dvd"
echo "====================================="
# mount dvd
mount -o loop ${ISO_DIR}/${ISO_FILE} ${MOUNT_DIR}
df -h | grep ${MOUNT_DIR}
sleep 1


# rsync dvd
echo
echo "rsync dvd"
echo "====================================="
rsync -av ${MOUNT_DIR}/ ${BUILD_DIR}
sleep 1


# copy setting files
echo
echo "copy to setting files"
echo "====================================="
# first. boot files
cp -f ${BASE_DIR}/config/BOOTX64.conf ${BUILD_DIR}/EFI/BOOT/
cp -f ${BASE_DIR}/config/isolinux.cfg ${BUILD_DIR}/isolinux/
cp -f ${BASE_DIR}/config/ks-*.cfg ${BUILD_DIR}/ks/
sleep 1

# second. post setting files
cp -f ${BASE_DIR}/post/* ${BUILD_DIR}/post/
sleep 1


# make iso file
echo
echo "make iso file"
echo "====================================="
cd ${BUILD_DIR}
mkisofs -U -A "centos6.9 x86_64" -V "Custom CentOS 6.9 Boot" -volset "Custom CentOS 6.9 x86_64" -J -joliet-long -r -v -T -x ./lost+found -o ${BASE_DIR}/${C_ISO_FILE} -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .

# clean
echo
echo "umount iso file"
echo "====================================="
umount ${MOUNT_DIR}
