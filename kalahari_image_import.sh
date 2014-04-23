#!/bin/bash
# Author: Jan Harasym <jharasym@linux.com>
# Copyright: JH @ Venda ltd. (although I'm sure it doesn't function well externally anyway)
# Script Designed to Manage MASS image import (over 1.2M images) from local file systems.
# Script expects Directory Layout to be /mnt/cdrom/${RANDOMFOLDERS}/${FILES}
#
# Script initially validates directories, then does import in batches.
#

# Define Functions {{{
usage(){
    echo "$0 [-d|--debug]";
    exit 1;
}

ask(){
    read -p "[y/N] " ans;
    case "$ans" in
        y*|Y*) return 0 ;;
        *) exit 1 ;;
    esac
};

# }}}

# Input Validation {{{
for arg in $@; do
    case $arg in
        -h|--help) echo "This is a small script designed to handle import of kalahari images into the live environment.";
        echo "please be wary when running this, if possible, DON'T";
        echo "running with no arguments will prompt you to work in live mode";
        echo "";
            usage;;
        -d|--debug) debug="1";
                    echo "${green}+${NC} Running in debug mode";;
        *) usage;;
    esac
done

if [ -z ${debug} ]; then
    echo -e -n "${cyan}--${NC} run in live mode? "; ask
fi

# }}}

# Define Variables {{{
CONTENTPATH="${cust_root}/tmp/kalaharing/";
TMP="/tmp";

# }}}

# Define Colors {{{
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color
black='\e[0;30m'
BLACK='\e[1;30m'
green='\e[0;32m'
GREEN='\e[1;32m'
yellow='\e[0;33m'
YELLOW='\e[1;33m'
magenta='\e[0;35m'
MAGENTA='\e[1;35m'
white='\e[0;37m'
WHITE='\e[1;37m'

# }}}

# Check Folders {{{

## is the content variable valid?
if [ -d ${CONTENTPATH} ]; then
    LOCATION=${CONTENTPATH};
    unset CONTENTPATH;
else
    echo -e "${red}+${NC} Problem with directory: ${CONTENTPATH}";
    LOCATION=${CONTENTPATH};
    unset CONTENTPATH;
    exit 255
fi

## # for when I had the misconception that we were running on webs with actual CDROMS
## ## is the CDROM mounted?
## if grep -qs "${LOCATION}" /proc/mounts; then 
##     echo -e "${green}+${NC} CDROM mounted"; 
## else 
##     echo -e "${red}+${NC} CDROM not mounted"; 
##     echo -n -e "${cyan}--${NC} Do you want me to mount the device? "; 
##     ask;
##     sudo mount /dev/cdrom ${LOCATION} -o ro
## fi

## does our tmp directory exist, and can we write to it?
if [ -d ${TMP} ]; then
    if [ -w ${TMP} ]; then
        echo -e "${green}+${NC} UNIX Temporary directory exists and is Read/Writable"
    else
        echo -e "${red}+${NC} Temporary directory ${RED}is not${NC} Writable"
    fi
else
    echo -e "${red}+${NC} Temporary directory ${RED}does not${NC} exist"
fi

# }}}

echo -n -e "${cyan}--${NC} Happy to continue?"; ask;

# Run the loops {{{
echo -e "${green}+${NC} Checking Files on disk."
for FOLDER in ${LOCATION}batch*.$(hostname)
do
    echo -e "${blue}++${NC} Running next batch at $(date)";
    echo -e "${green}+${NC} changing symlink to ${FOLDER}";
    PSVSUM=$(md5sum ${TMP}/kalaharing/*.psv);
    rm "${TMP}/kalaharing"
    ln -sfT ${FOLDER} "${TMP}/kalaharing";
    ## Make sure our symlink was updated successfully.
    NEWPSVSUM=$(md5sum ${TMP}/kalaharing/*.psv);
    PSVNAME=$(file /tmp/kalaharing/*.psv | awk -F: '{print $1}');
    echo -e "${green}+${NC} Uploading ${PSVNAME} to FTP";

#### FTP upload of the PSV file {{{
if [ -z $debug ]; then
#    ftp -i ${FTPHOST} <<EOT
#    put ${PSVNAME}
#    quit
#EOT
  sudo cp /tmp/kalaharing/*.psv /web/01/cust/kalaharing/ftp/pub/product_update/ ; 
  sudo chown apache. /web/01/cust/kalaharing/ftp/pub/product_update/*.psv ;
else
    echo -e "${green}+${NC} Skipping upload :: Debug mode";
#EOT
fi
#### This is required for our intergration to run, 
#### as it can't read our filesystem directly -- don't you just love perldevs? :P
# }}}

    if [ "${PSVSUM}" == "${NEWPSVSUM}" ]; then
        echo -e "${red}+${NC} Symlink was not updated";
    fi
    echo -e "${green}+${NC} running job on: ${FOLDER}";
    if [ -z $debug ]; then
        sudo instmaint entprs job kalaharing "media_update_$(hostname)"
    fi
done;

# }}}

#time for a cache clear

echo -n -e "${cyan}--${NC} Cache Clear? "; ask;
sudo instmaint entprs cache kalaharing clear

# Cleanup {{{
echo -n -e "${cyan}--${NC} Cleanup? "; ask;
echo -e "${green}+${NC} Cleaning up Temporary files";
#sudo rm ~/.netrc
echo -e "${GREEN}+++++++++++++++++${NC} FIN ${GREEN}+++++++++++++++++${NC}";
# }}}
