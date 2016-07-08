#!/bin/sh
set -e
if [ ! -f vmlinuz ];then
	wget -O vmlinuz http://tinycorelinux.net/7.x/x86/release/distribution_files/vmlinuz
fi
if [ ! -f core.gz ];then
	wget -O core.gz http://tinycorelinux.net/7.x/x86/release/distribution_files/core.gz
fi
if [ ! -d xbase ];then
	mkdir xbase
	for i in Xvesa Xlibs Xprogs aterm flwm_topside wbar;do
		./get-tcz.sh $i xbase
	done
fi
for i in $*;do
	if [ -f $i.gz ];then
		echo "$i.gz exists."
	else
		if [ -d $i ];then
			rm $i/*.tcz
			rmdir $i
		fi
		mkdir $i
		cp xbase/*.tcz $i
		./get-tcz.sh $i $i
		
		if [ -d initroot ];then
			sudo rm -r initroot
		fi
		mkdir initroot
		
		(cd initroot; gzip -cd ../core.gz | sudo cpio -i -H newc -d)
		for j in $i/*.tcz;do
			sudo unsquashfs -d sq $j
			sudo cp -r sq/* initroot
			sudo rm -r sq
		done
		if [ $i = "gparted" ];then
			(cd initroot/etc/init.d;sudo patch -p0 < ${FDIR}/tc-config.diff)
		fi
		(cd initroot; sudo find | sudo cpio -o -H newc | gzip > ../$i.gz)
	fi
done
