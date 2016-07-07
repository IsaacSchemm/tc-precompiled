#!/bin/sh
if [ ! -f vmlinuz ];then
	wget -O vmlinuz http://tinycorelinux.net/7.x/x86/release/distribution_files/vmlinuz
fi
if [ ! -f core.gz ];then
	wget -O core.gz http://tinycorelinux.net/7.x/x86/release/distribution_files/core.gz
fi
for i in $*;do

done
