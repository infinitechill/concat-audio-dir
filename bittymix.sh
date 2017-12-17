#!/bin/bash

# BITTYMIX 2018
# bittymix.sh

# this bash script makes bittymix mixes by convert 
# all the files in the directory supplied to a common 
# bitrate / mp3 # and join them together using ffmpeg
# WARNING: this script does remove files. 
# use at your own risk


# arg checking
if [ ! $# -eq 1 ]; then
	printf "\n\
		usage: ./bittymix full/path/to/dir/of/audio_files\n"
	printf "\n\
		wrong number arguments supplied.\n\
		remember this script deletes files. \n\
		be careful. exiting now.\n\n"
	exit 1
fi
if [[ ! -d $1 ]]; then
	printf "\n\
		usage: ./bittymix full/path/to/dir/of/audio_files\n"
	printf "\n\
		$1 is not a directory.\n\n" 
	exit 1
fi


# echo 'preparing the files'
cleanup_file_list=()
for ff in $1/*; 
do
	filename=$(basename $ff)
	extension=${filename##*.}
	filename=${filename%.*}
	original_file_list+=("$1/${filename}B.${extension}")
	ffmpeg -i "${ff}" -acodec libmp3lame -ab 320k "$1/${filename}B.mp3" > /dev/null 2>&1
	cleanup_file_list+=("$1/${filename}B.mp3");
	rm $ff
done

# echo 'preparing the list'
for f in $1/*; do echo "file '$f'" >> $1/mylist.txt; done

# echo 'join the mp3s / mixdown'
ffmpeg -f concat -safe 0 -i $1/mylist.txt -c copy $1/output.mp3 > /dev/null 2>&1

# echo 'cleaning up files'
for i in ${cleanup_file_list[@]}; do rm $i; done
rm $1/mylist.txt

# echo $1/output.mp3