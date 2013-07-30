#!/bin/bash

cd ~/android/android_kernel_htc_m7
TOOLCHAIN=../toolchain/gcc-linaro/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm

# make mrproper
make CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper

# remove backup files
find ./ -name '*~' | xargs rm
rm compile.log

# make kernel
make cyanogenmod_m7_defconfig
make -j`grep 'processor' /proc/cpuinfo | wc -l` CROSS_COMPILE=$TOOLCHAIN >> compile.log 2>&1 || exit -1

# copy modules
find -name '*.ko' -exec cp -av {} ../m7-cwm_zip/system/lib/modules/ \;

# copy kernel image
cp arch/arm/boot/zImage ../m7-cwm_zip/kernel/kernel

# strip modules
${TOOLCHAIN}strip --strip-unneeded ../m7-cwm_zip/system/lib/modules/*ko

# create cwm zip
cd ../m7-cwm_zip
find ./ -name '*~' | xargs rm
rm *.zip
TIMESTAMP=thoravukk-m7-`date +%Y%m%d-%T`
zip -r $TIMESTAMP-cwm.zip *
