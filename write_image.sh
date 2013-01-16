#!/usr/bin/env bash

if [ $1n == "n" || $2x == "x" ];
then
    echo "usage: $0 input.iso /dev/outputdisk"
    exit 2
fi

size="$(du $1)k"
echo "Checking auth for sudo"
sudo echo "Passed..."

dd bs=4k if=$1 | pv -s $size | sudo dd of=$2
unset size
