#!/bin/bash

echo -e "==========================="
echo -e "= START COMPILING KERNEL  ="
echo -e "==========================="
bold=$(tput bold)
normal=$(tput sgr0)

#apt update -y && apt upgrade -y && apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && apt install build-essential -y && apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && apt install pigz -y && apt install python2 -y && apt install python3 -y


# Scrip option
while (( ${#} )); do
    case ${1} in
        "-Z"|"--zip") ZIP=true ;;
    esac
    shift
done
[[ -z ${ZIP} ]] && { echo "${bold}LOADING-_-....${normal}"; }

DEFCONFIG="vince_defconfig"
export KBUILD_BUILD_USER=Rsyd58
export TZ=Asia/Jakarta
export KBUILD_BUILD_HOST=non-pangu-pod
#export VER="V4.6.15.0.REGMIXM"
export KERNELDIR="/workspace/Rsyd58/krnlv"
export USE_CCACHE=1
export CCACHE_DIR="workspace/Rsyd58/.ccache"
export KERNELNAME="Furina"
export SRCDIR="${KERNELDIR}"
export OUTDIR="${KERNELDIR}/out"
export ANYKERNEL="${KERNELDIR}/AnyKernel3"
export DEFCONFIG="vince_defconfig"
export ZIP_DIR="${KERNELDIR}/files"
export IMAGE="${OUTDIR}/arch/arm64/boot/Image.gz-dtb"
export ZIPNAME="${KERNELNAME}-vince-$(date +%m%d-%H%M%S).zip"
export FINAL_ZIP="${ZIP_DIR}/${ZIPNAME}"
TC_DIR="/workspace/weebx"
export PATH="$TC_DIR/bin:$PATH"

if [[ $1 = "-r" || $1 = "--regen" ]]; then
make O=out ARCH=arm64 $DEFCONFIG savedefconfig
cp out/defconfig arch/arm64/configs/$DEFCONFIG
exit
fi

if [[ $1 = "-c" || $1 = "--clean" ]]; then
rm -rf out
fi

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG
export LOCALVERSION="-msm8953-arm64-Android-12-LAW.BR.5.1.r1"
export KSU=y
make -j$(nproc --all) O=out ARCH=arm64  CC=clang HOSTCC=clang HOSTCXX=clang++ READELF=llvm-readelf HOSTAR=llvm-ar AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-  2>&1 | tee log.txt
#make -j$(nproc --all) O=out ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt
    echo -e "==========================="
    echo -e "   COMPILE KERNEL COMPLETE "
    echo -e "==========================="

# Make ZIP using AnyKernel
# ================
echo -e "Copying kernel image";
rm -rf ${ZIP_DIR}/*
cp -v "${IMAGE}" "${ANYKERNEL}/";
cd -;
cd ${ANYKERNEL};
zip -r9 ${FINAL_ZIP} *;
gh release upload test ${FINAL_ZIP} -R github.com/Rsyd58/Rsyd58;
cd -;

#echo -e "zip boot and dtbo"
#rm -rf kernel.zip && cd out/arch/arm64/boot && zip kernel.zip Image.gz-dtb && mv kernel.zip ../../../../

if [[ ":v" ]]; then
exit
fi
#gh release upload test files/${FINAL_ZIP} -R github.com/Rsyd58/Rsyd58
