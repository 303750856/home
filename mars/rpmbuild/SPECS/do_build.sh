#!/bin/bash -e

#########################################################################
#                                                               	#
# Author:               Mars Tian <marstian@linpus.com>      		#
# Lable:                do_build.sh					#
# Information:          build kernel and driver for lite 1.6            #
# Create Date:          2011-09-19                              	#
# Modify Date:          2011-11-17                             		#
# Modify by:          	Joe Jiang <joejiang@linpus.com>			#
# Version:              v1.2                                    	#
#                                                               	#
#########################################################################

# build the kernel
BuildKer(){
rpmbuild -ba kernel.spec \
	 --target=i686 \
	 --with paeonly \
         --with paedebug \
	 --with headers \
	 --define='dist .lp' \
	 --without debug \
	 --without debuginfo \
	 --without tools \
         --without doc \
	 || exit 1
#	 --without  up debug doc headers tools debuginfo vdso_install omap tegra \
}


# build the drivers
BuildDrivers(){
rpmbuild -ba  drivers-add.spec \
	 --define='dist .lp' \
	 || exit 1
}

# start build 
echo "start time:`date`" > .start_time
start_s=`date +%s`


if [ $# -eq 0 ] ; then
	BuildKer
	BuildDrivers
else
	case $1 in 
		# build all
		"all" )
			BuildKer
			BuildDrivers
			;;
		# only build the kernel
		"k" | "kernel" | "1" )
			BuildKer
			;;
		# only build the drivers
		"d" | "drivers" | "driver" | "2" )
			BuildDrivers
			;;
		# deal with other input
		* )
			echo "Invalid input"
			exit -1
			;;
	esac
fi

# print Success infomation
end_s=`date +%s`
use_s=`echo "$end_s $start_s" | awk '{print $1-$2}'`
use_m=`echo "$use_s 60" | awk '{print $1/$2}'`
use_h=`echo "$use_m 60" | awk '{print $1/$2}'`
echo "use $use_s seconds"
echo "use $use_m minutes"
echo "use $use_h hours"
echo "Building Success!!"
