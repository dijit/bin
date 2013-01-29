#!/bin/bash

function randpass
{
    echo -n $(</dev/urandom tr -dc A-Za-z0-9 | head -c8)
}

while [[ x < $1 ]]; do
    echo "$x : "; randpass
    x=$((1+$x));
    echo ""
done
