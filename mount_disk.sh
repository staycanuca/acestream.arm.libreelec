#!/bin/sh

. settings.conf

ACEDIR=$(readlink -f $(dirname $0))
ACECHROOT="androidfs"
DIR_MOUNT="$ACEDIR/$ACECHROOT/mount"
LIST_MOUNT="default /storage"
LOG="$ACEDIR/aceaddon.log"

log(){   
   IS_DEBUG=$is_debug
   [ -z $IS_DEBUG ] && IS_DEBUG="false"
   [ $IS_DEBUG == "true" ] && echo "$(date +"%y-%m-%d %T")|"acestreammedia"|$(basename "$0")|$@" >> $LOG
}

IS_MOUNT_SD=$(/bin/mount | grep '/dev/mmcblk.* on /var/media')
IS_MOUNT_USB=$(/bin/mount | grep '/dev/sd[a-z][1-9] on /var/media')

log "IS_MOUNT_SD=$IS_MOUNT_SD"
log "IS_MOUNT_USB=$IS_MOUNT_USB"

if [ -n "$IS_MOUNT_USB" ]; then  
  LIST_MOUNT_USB=$(/bin/mount | grep '/dev/sd[a-z][1-9] on /var/media' | awk '{print $3, $1}' | sed 's|/var/media/||')
  LIST_MOUNT="$LIST_MOUNT $LIST_MOUNT_USB"
fi  
if [ -n "$IS_MOUNT_SD" ]; then
  LIST_MOUNT_SD=$(/bin/mount | grep '/dev/mmcblk.* on /var/media' | awk '{print $3, $1}' | sed 's|/var/media/||')
  LIST_MOUNT="$LIST_MOUNT $LIST_MOUNT_SD"
fi

log "LIST_MOUNT=$LIST_MOUNT"

echo $LIST_MOUNT
