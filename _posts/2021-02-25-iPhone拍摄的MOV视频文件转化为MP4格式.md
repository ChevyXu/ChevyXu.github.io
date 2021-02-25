---
layout: post
title: iPhone拍摄的MOV视频文件转化为MP4格式
subtitle: 青春的动人之处，就在于勇气，和他们的远大前程。
date: 2021-02-25
author: Chevy
header-img: img/38.jpg
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 准备

Linux系统

- 安装了 ffmpeg
  - conda install -c conda-forge ffmpeg
- iPhone导出到电脑里的MOV文件

## 脚本

```shell
processvideo() {
  filename=$1
  ext=$2
  destination=$3
  pathbase=$4


  encodedfilename="${filename//.$ext/.mp4}"

  echo -e "\e[93m=========================================================="
  echo "Found         $filename"
  echo -e "Converting to $encodedfilename\e[0m"

  if [ -f "$encodedfilename" ]; then
    echo -e "\e[91mFile $encodedfilename already exists. Doing nothing, preserving original file, please resolve manually.\e[0m"
    read -p "Press [Enter] to continue"
  else
    #encode to x264 with ffmpeg
    ffmpeg -i "$filename" -c:v libx264 -crf 23 -preset medium -pix_fmt yuvj420p -map 0:a:0 -map 0:v:0 -movflags +faststart "$encodedfilename"
    res=$?

    if [ $res -eq 0 ]; then

      # take base portion off file path and replace with base portion of destination path
      filenameInNewPath="$destination${filename/$pathbase/}"
      directoryName=$(dirname "$filenameInNewPath")

      # create destination directory for the original file, if not exist
      if [ ! -d "$directoryName" ]; then
        echo -e "\e[93mCreating directory $directoryName\e[0m"
        mkdir -p "$directoryName"
      fi

      echo -e "\e[93mMoving file $filename to $filenameInNewPath\e[0m"

      mv "$filename" "$filenameInNewPath"

      echo -e "\e[92mOK\e[0m"
    else
      echo -e "\e[91mffmpeg returned error code $res."
      if [ -f "$encodedfilename" ]; then
        rm "$encodedfilename"
        echo -e "Removed encoded file $encodedfilename, and preserved original file $filename\e[0m"
      else
        echo -e "Encoded file $encodedfilename was not created, original file $filename preserved.\e[0m"
      fi
      read -p "Press [Enter] to continue"
    fi
  fi


}

export -f processvideo

# parameters, with / at the end trimmed
path=${1%/}
ext=$2
destination=${3%/}
basePortion=${4%/}

if [ "$1" == "" ]; then
  echo -e "\e[0mUsage example:"
  echo "./encode.sh /media/remote/photo/2019 MOV /media/remote/mov /media/remote/photo"
  echo "Will search for files of type MOV in /media/remote/photo/2019, and move each original to /media/remote/mov/2019/<file_relative_location>"
  echo ""
	echo "Syntax:"
  echo "./encode.sh search_path search_extension destination [base_portion_of_search_path]";
  echo "It will search for the files of given extension, in search_path, encode each to x264 (.mp4), then move original file to the destination, maintaining folder structure."
  echo "If need to ignore base portion of search path when creating folder at destination, provide it as an extra parameter"
  echo ""
  echo "NB: All trailing slashes in paths are ignored, so it makes no difference if they are added"


else
  echo -e "\e[93m================== STARTING SCRIPT ======================="
  echo "Finding files of type $ext in: $path"
  echo -e "Moving originals to: $destination"

	find $path -name "*.$ext" \( -exec bash -c "processvideo '{}' '$ext' '$destination' '$basePortion' " \; -o -print \)

  echo -e "\e[93mFinished.\e[0m"
fi
```

来自：https://github.com/DmitriyLogunov/bash-mov-to-mp4/blob/master/encode.sh

## 操作

首先`chmod`shell脚本为可执行文件：` ~/bash-mov-to-mp4/encode.sh`

随后将MOV文件放在文件夹1`Files`里面

执行命令：

```
~/bash-mov-to-mp4/encode.sh Files/ MOV Files_Raw
```
## 结果
运行结束后，`Files`文件夹下的MOV后缀的视频文件都会被转成MP4格式的文件，原始的MOV文件会被转移到`Files_Raw`文件夹下。