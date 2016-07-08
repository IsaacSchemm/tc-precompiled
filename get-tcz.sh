#!/bin/sh
set -e
i=$1
echo $0 $*
if [ "$2" = "" ] || [ ! -d $2 ];then
	echo "Usage: $0 [filename].tcz [directory]"
	return 1
fi
if !(echo $i | grep -q '\.tcz$');then
	i=$i.tcz
fi
echo "Looking up dependencies for $i"
wget -qO- http://distro.ibiblio.org/tinycorelinux/7.x/x86/tcz/$i.dep | while read j;do
	if [ "$j" != "" ];then
		$0 $j $2
	fi
done
if [ ! -f $i ];then
	echo "Downloading $i"
	wget -qO $i http://distro.ibiblio.org/tinycorelinux/7.x/x86/tcz/$i &
	wait $!
fi
cp -v $i $2
