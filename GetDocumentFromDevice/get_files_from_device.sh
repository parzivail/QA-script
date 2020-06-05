#!/bin/bash

# Extract a document from device to a .tar file.
# The document name need to be unique in order for the script to work. 
# The user shall be prompted if the document is not found or there are more than one match e.g To documents that have the name Notebook and Notebook1 
# and the user enters Notebook. Then the GREP command will find two matches and the script want work.

SSH_CONF=~/.ssh/config



if [ -e $SSH_CONF ]; then
  echo "File $SSH_CONF already exists checking if Host is added!"
else
  ssh-keygen -t rsa
  echo >> $SSH_CONF
  echo "Host rm
   User root
   Hostname 10.11.99.1
   StrictHostKeyChecking no
   UserKnownHostsFile /dev/null" >> $SSH_CONF
fi
if ! grep -q 'Host rm' "$SSH_CONF"; then
  echo "Host rm
   User root
   Hostname 10.11.99.1
   StrictHostKeyChecking no
   UserKnownHostsFile /dev/null" >> $SSH_CONF
else
  echo "SSH config is ok, trying to login to reMarkable device"
fi

sleep 1

TARGET='rm'
echo Enter File Name
read -e FILE_NAME
#FILE_DIR= echo $FILE_NAME | sed 's/ //g'
DESTINATION_DIR=~/Downloads/rM_export/
echo $DESTINATION_DIR

ssh-copy-id $TARGET

mkdir -p $DESTINATION_DIR/
#ssh $TARGET "ls -lh | grep $FILE_NAME ~/.local/share/remarkable/xochitl/*.metadata | cut -f1 -d":" | sed -e "s/.metadata//"" > $DESTINATION_DIR/tmp.txt
NUMB_FILES=$(ssh $TARGET "ls -lh | grep -w '$FILE_NAME' ~/.local/share/remarkable/xochitl/*.metadata | cut -f1 -d":" | sed -e "s/.metadata//" | wc -l")
if [ $NUMB_FILES -lt 1 ]; then
echo "!!!ERROR!!! Could not find $FILE_NAME"
exit 1
fi
if [ $NUMB_FILES -ge 2 ]; then
echo "!!!ERROR!!! Found $NUMB_FILES documents on device that match $FILE_NAME, change name of the document you want to download and try again"
exit 1
fi

UUID_PATH=$(ssh $TARGET "ls -lh | grep -w '$FILE_NAME' ~/.local/share/remarkable/xochitl/*.metadata | cut -f1 -d":" | sed -e "s/.metadata//"")
#echo $UUID_PATH
ssh $TARGET "tar -cf document_export.tar $UUID_PATH*"
sleep 1
scp -r $TARGET:/home/root/document_export.tar $DESTINATION_DIR/document_export.tar
#mv $DESTINATION_DIR/document_export.tar $DESTINATION_DIR/$FILE_DIR.tar	
sleep 1
ssh $TARGET "rm -r document_export.tar"
echo "!!!Completed!!! The downloaded document can be found here: $DESTINATION_DIR"