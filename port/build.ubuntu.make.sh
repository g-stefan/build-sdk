#!/bin/sh
# Public domain
# http://unlicense.org/
# Created by Grigore Stefan <g_stefan@yahoo.com>

ACTION=$1
if [ "$1" = "" ]; then
	ACTION=install
fi
if [ "$1" = "make" ]; then
	ACTION=install
fi

# --
if [ "$1" = "debug" ]; then
	XYO_COMPILE_DEBUG=1
	ACTION=install
fi
# --

echo "-> $ACTION build-sdk"

build(){
	if [ -n "$1" ]; then		
		if [ -d "../$1" ]; then
			if [ -f "../$1/port/build.ubuntu.sh" ]; then
				cd ../$1; /bin/sh -- ./port/build.ubuntu.sh $ACTION;
				if [ "$?" = "1" ]; then
					exit 1
				fi
			else
				echo "Error - not found: ../$1/port/build.ubuntu.sh"
				exit 1			
			fi
		else
			echo "Error - not found: $1"
			exit 1			
		fi
	fi
}

{ <"./source/ubuntu.txt" tr -d "\r"; echo; } | while read -r line; do
	case "$line" in
		\#*) continue ;;
	esac
	if [ -n "$line" ]; then
		build $line
	fi
done
