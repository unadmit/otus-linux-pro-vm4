#!/bin/bash
lsblk
blklist=$(lsblk -o NAME,FSTYPE -dsn|awk '$2 == "" {print "/dev/"$1}')
strarr=($blklist)
for ((i=0; i < 7 ; i++));do sudo zpool create otus$i mirror ${strarr[$i]} ${strarr[$(($i+1))]};i=$(($i+1));done
zpool list
zplist=$(zpool list|awk 'NR>1 {print $1}')
strarr=($zplist)
IFS=', ' read -r -a ctypes <<< "lzjb,lz4,gzip-9,zle"
for ((i=0; i < 4 ; i++));do sudo zfs set compression=${ctypes[$i]} ${strarr[$i]};done
zfs get all | grep compression
for pname in "${strarr[@]}";do sudo wget -P /$pname https://gutenberg.org/cache/epub/2600/pg2600.converter.log -q;done
ls -l /otus*
zfs list
zfs get all | grep compressratio | grep -v ref
wget --no-check-certificate -O archive.tar.gz 'https://docs.google.com/uc?export=download&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg' -r -A -e -q
tar -xzvf archive.tar.gz
sudo zpool import -d zpoolexport/
sudo zpool import -d zpoolexport/ otus
zpool status
IFS=', ' read -r -a settings <<< "all,available,type,recordsize,compression,checksum"
for el in "${settings[@]}";do zfs get $el otus;done
wget -O otus_task2.file --no-check-certificate 'https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download' -q
sudo zfs receive otus/test@today < otus_task2.file
path=$(find /otus/test -name "secret_message")
echo $path
cat $path