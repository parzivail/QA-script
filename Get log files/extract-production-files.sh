#!/bin/bash

# Extract log files, config files and test result files that might be intersting from a
# device after production

SSH_CONF=~/.ssh/config



if [ -e $SSH_CONF ]; then
  echo "File $SSH_CONF already exists!"
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
fi

TARGET='rm'
echo Enter Serial Number
read SERIAL_NUMBER
DESTINATION_DIR=~/Downloads/$SERIAL_NUMBER

ssh-copy-id $TARGET

mkdir -p $DESTINATION_DIR/
scp -r $TARGET:/home/root/.config/ $DESTINATION_DIR/config

scp -r $TARGET:/home/root/.local/tests/ $DESTINATION_DIR/tests

scp -r $TARGET:/home/root/log.txt $DESTINATION_DIR/log

mkdir -p $DESTINATION_DIR/journal

ssh $TARGET "journalctl" > $DESTINATION_DIR/journal/journal-all.log
ssh $TARGET "journalctl -u remarkable-qa -p 7" > $DESTINATION_DIR/journal/journal-remarkable-qa.log

mkdir -p $DESTINATION_DIR/dmesg
ssh $TARGET "dmesg -T" > $DESTINATION_DIR/dmesg/dmesg.log

mkdir -p $DESTINATION_DIR/serialnumbers
ssh $TARGET "cat /dev/mmcblk2boot1" > $DESTINATION_DIR/serialnumbers/serialnumbers-raw.txt

