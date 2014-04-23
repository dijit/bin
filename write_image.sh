#!/usr/bin/env bash

if [[ $1n == "n" || $2x == "x" ]];
then
    echo "usage: $0 input.iso /dev/outputdisk"
    exit 2
fi

size=$(du -sb $1 | awk '{print $1}')
echo "Checking auth for sudo"
sudo echo "Passed..."

dd if=$1 | pv -s $size | sudo dd bs=4k of=$2
unset size
