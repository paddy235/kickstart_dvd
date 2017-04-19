#!/usr/bin/env bash
# 2017-04-10
# reference - http://www.nathanboyce.com/automatic-centos-6-installation-dvd-with-kickstart/

BASE_DIR=`pwd`
WORK_DIR=${BASE_DIR}/rebuild
BUILD_DIR=${WORK_DIR}/build
MOUNT_DIR=${WORK_DIR}/dvd

ISO_FILE=CentOS-6.9-x86_64-minimal.iso
RESULT_FILE=grvy_centos-6.9-x86_64-minimal.iso

echo "====================================="
echo "work dir  - ${WORK_DIR}"
echo "build dir - ${BUILD_DIR}"
echo "mount dir - ${MOUNT_DIR}"
echo "iso file  - ${ISO_FILE}"
echo "====================================="
echo 

echo "clean the previous work...."
rm -rf ${WORK_DIR}
echo "done"
echo "====================================="
echo 

echo "start build"
# make workspace
mkdir -p ${WORK_DIR}/dvd
mkdir -p ${BUILD_DIR}/{isolinux,images,ks,CentOS,EFI}

# origin dvd mount
mount -o loop ./iso/${ISO_FILE} ${MOUNT_DIR}

chown -R $USER: ${BUILD_DIR}

# copy data from dvd
cp -R ${MOUNT_DIR}/EFI/* ${BUILD_DIR}/EFI/
cp -R ${MOUNT_DIR}/isolinux/* ${BUILD_DIR}/isolinux/
cp -R ${MOUNT_DIR}/images/* ${BUILD_DIR}/images/
cp ${MOUNT_DIR}/.discinfo ${BUILD_DIR}/
cp ${MOUNT_DIR}/Packages/*.rpm ${BUILD_DIR}/CentOS/

cp -f ./config/EFI/BOOT/BOOTX64.conf ${BUILD_DIR}/EFI/BOOT/
cp ./config/ks-bios.cfg ${BUILD_DIR}/ks
cp ./config/ks-efi.cfg ${BUILD_DIR}/ks
cp ./config/isolinux.cfg ${BUILD_DIR}/isolinux

cp ./post/post.sh ${BUILD_DIR}
cp ./post/final.sh ${BUILD_DIR}
cp ./post/ifcfg-eth* ${BUILD_DIR}
cp ./post/CentOS-Base.repo ${BUILD_DIR}

# modify permission
chmod 644 ${BUILD_DIR}/isolinux/isolinux.bin
chmod 644 ${BUILD_DIR}/isolinux/isolinux.cfg
chmod 644 ${BUILD_DIR}/ks/ks.cfg

# download comps.xml
cd ${BUILD_DIR}

# dvd
wget http://ftp.kaist.ac.kr/CentOS/6.9/os/x86_64/repodata/1cde788f77b08a7eb3dfdba12fa384a5f0214147a717a1e2d4504368037fba90-c6-x86_64-comps.xml.gz
gzip -d 1cde788f77b08a7eb3dfdba12fa384a5f0214147a717a1e2d4504368037fba90-c6-x86_64-comps.xml.gz
mv 1cde788f77b08a7eb3dfdba12fa384a5f0214147a717a1e2d4504368037fba90-c6-x86_64-comps.xml comps.xml

# createrepo
declare -x discinfo=`head -1 .discinfo`
createrepo -u "media://$discinfo" -g comps.xml .

# make iso file
cd ${WORK_DIR}
mkisofs -r -N -L -d -J -T -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -V centos -boot-load-size 4 -boot-info-table -o ${RESULT_FILE} ${BUILD_DIR} 

echo "build done"
echo "====================================="
echo 

mv -f ${WORK_DIR}/${RESULT_FILE} ${BASE_DIR}
umount ${MOUNT_DIR}
rm -rf ${WORK_DIR}
echo "clear"
echo "====================================="
echo 

