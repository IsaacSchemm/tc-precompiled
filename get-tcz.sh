#!/bin/sh
set -e
for i in $*;do
	if !(echo $i | grep -q '\.tcz$');then
		i=$i.tcz
	fi
	echo $i
	if [ ! -f $i ];then
		wget -qO- http://distro.ibiblio.org/tinycorelinux/7.x/x86/tcz/$i.dep | while read j;do
			$0 $j
		done
		wget -qO $i http://distro.ibiblio.org/tinycorelinux/7.x/x86/tcz/$i
	fi
done
