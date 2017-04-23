#!/bin/bash

LOGFILE="$HOME/.logs/a1.backup.log"
BACKUP_SOURCE="/var/run/user/1000/gvfs/mtp*"
BACKUP_DESTINATION="$HOME/Backups/A1/Prep"
CALLS_FOLDER="com.boldbeast.recorder"
CALLS_DESTINATION_FOLDER="$HOME/Backups/A1/Calls"
CALLS_CMD="rsync -avP $BACKUP_DESTINATION/$CALLS_FOLDER/ $CALLS_DESTINATION_FOLDER/"
COMPRESS_CMD="7z a -mx=0 -v100m -p -o $COMPRESS_FOLDER A1.$(date).7z $BACKUP_DESTINATION/."
COMPRESS_FOLDER="$HOME/Backups/A1/Image"
CLOUD_BACKUP_CMD="rclone copy -v $COMPRESS_FOLDER/ Backup:/A1/"
CLEANUP_CMD="rm -rf $BACKUP_DESTINATION/. >> $LOGFILE"

rm "$LOGFILE"
date > "$LOGFILE"
echo "Starting initial backup" >> "$LOGFILE"
rsync -avP --exclude '*cache*' "$BACKUP_SOURCE"/ "$BACKUP_DESTINATION"/ >> "$LOGFILE"

echo "Backing up calls" >> "$LOGFILE"
$CALLS_CMD >> "$LOGFILE"

echo "Compressing backup" >> "$LOGFILE"
$COMPRESS_CMD >> "$LOGFILE"

echo "Uploading the backup" >> "$LOGFILE"
$CLOUD_BACKUP_CMD >> "$LOGFILE"
