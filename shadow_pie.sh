#
# Custom build script for Shadow kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it.
#
VERSION="Pie"
DEVICE="Kenzo"
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Welcome to Shadow building program !\n\n ===================================="
echo -e "$gre \n 1.Build Shadow CLean\n\n 2.Build Shadow Dirty\n"
echo -n " Enter your choice:"
read qc
echo -e "$white"
KERNEL_DIR=$PWD
cd $KERNEL_DIR/arch/arm/boot/dts/
rm *.dtb > /dev/null 2>&1
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/nesara/gcc-linaro-6.5.1/bin/aarch64-linux-gnu-"
echo -e "$yellow Running make clean before compiling \n$white"
if [ $qc == 1 ]; then
make clean > /dev/null
fi
#
#if [ $qc == 2 ]; then
#echo -e "$yellow Applying quick charging patch \n $white"
#git apply qc.patch
#elif [ $qc == 1 ]; then
#git apply -R qc.patch > /dev/null 2>&1
#fi
make shadow_pie_defconfig
#export KBUILD_BUILD_HOST="xda"
#export KBUILD_BUILD_USER="energyspear17"
make -j4
time=$(date +"%d-%m-%y-%T")
date=$(date +"%d-%m-%y")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
#if ([ $qc -eq 1 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/$VERSION/tools/dt1.img
#elif ([ $qc -eq 2 ]); then
#mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/$VERSION/tools/dt2.img
#fi
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/$VERSION/tools/Image1
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build/$VERSION
rm *.zip > /dev/null 2>&1
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
zip -r shadow-$DEVICE-$VERSION-$date.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/export/$VERSION/shadow-$DEVICE-$VERSION-$date.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($qc) >> \n $white"
fi
cd $KERNEL_DIR
#if [ $qc == 2 ]; then
#git apply -R qc.patch
#fi
