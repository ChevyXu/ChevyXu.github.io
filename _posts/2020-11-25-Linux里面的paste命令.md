---
layout: post
title: Linux里面的 paste命令
subtitle: 江南无所有，聊赠一枝春。
date: 2020-11-25
author: Chevy
header-img: img/34.jpg
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## Linux里面的 paste命令

paste命令是Unix和Linux系统中使用频率很高的一个命令。它被用来将文件按列以**tab**作为分隔符拼接在一起随后输出到标准输出(standard output)。

> 如果没有指定文件或者使用`-`作为管道符，那么`paste`命令会从标准输入(standard input)读入随后输出到标准输出

标准用法：

```shell
paste [OPTION]... [FILES]...
```

我们拿几个数据举例：

```shell
wanglab@mgt:~/test$ ll
total 12K
-rw-rw-r-- 1 wanglab wanglab 38 Nov  6 15:26 capital
-rw-rw-r-- 1 wanglab wanglab 10 Nov  6 15:27 number
-rw-rw-r-- 1 wanglab wanglab 58 Nov  6 15:26 state

wanglab@mgt:~/test$ cat state 
Arunachal Pradesh
Assam
Andhra Pradesh
Bihar
Chhattisgrah

wanglab@mgt:~/test$ cat capital 
tanagar
Dispur
Hyderabad
Patna
Raipur

wanglab@mgt:~/test$ cat number 
1
2
3
4
5
```

我们目前有state, captial和number几个文件，使用`paste`命令对这几个文件进行处理

### 参数

1. `-d (delimiter)`

   `paste`命令会默认以制表符(delimiter)作为分隔符对文件进行merge，而我们可以通过使用`-d`来指定分隔符，如果多个字符被指定为分隔符，`paste`命令会循环指定分隔符来进行使用：

   ```shell
   # 指定一个固定分隔符
   wanglab@mgt:~/test$ paste -d "|" number state capital
   1|Arunachal Pradesh|tanagar
   2|Assam|Dispur
   3|Andhra Pradesh|Hyderabad
   4|Bihar|Patna
   5|Chhattisgrah|Raipur
   
   # 指定多个分隔符
   wanglab@mgt:~/test$ paste -d "|," number state capital number 
   1|Arunachal Pradesh,tanagar|1
   2|Assam,Dispur|2
   3|Andhra Pradesh,Hyderabad|3
   4|Bihar,Patna|4
   5|Chhattisgrah,Raipur|5
   ```

2. `-s (serial)`

   `-s`参数可以指示shell将读入的文件按行输出，每个文件都会被整合到一行，原文件内的数据每行之间会以`tab`作为分隔符，每个文件的内容占据一行：
   
   ```shell
   wanglab@mgt:~/test$ paste -s number state capital
   1	2	3	4	5
   Arunachal Pradesh	Assam	Andhra Pradesh	Bihar	Chhattisgrah
   tanagar	Dispur	Hyderabad	Patna	Raipur
   ```
   
   **结合`-s`和`-d`参数**：
   
   ```shell
   wanglab@mgt:~/test$ paste -s -d ":" number state capital
   1:2:3:4:5
   Arunachal Pradesh:Assam:Andhra Pradesh:Bihar:Chhattisgrah
   tanagar:Dispur:Hyderabad:Patna:Raipur
   ```
   
3. `--version`

   该参数可以用来展示`paste`函数的版本：

   ```
   wanglab@mgt:~/test$ paste --version
   paste (GNU coreutils) 8.22
   Copyright (C) 2013 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later       <http://gnu.org/licenses/gpl.html>.
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.
   
   Written by David M. Ihnat and David MacKenzie.
   
   ```



### 应用实例

1. 将单个文件整合成多行：

   ```shell
   # 单个文件整合成两列排布
   wanglab@mgt:~/test$ cat capital | paste - -
   tanagar	Dispur
   Hyderabad	Patna
   Raipur	
   
   # 单个文件整合成三列排布
   wanglab@mgt:~/test$ paste - - - < capital
   tanagar	Dispur	Hyderabad
   Patna	Raipur	
   ```

2. 联合其他命令处理文本：

   ```shell
   # 联合cut函数和连字符-
   ## 不使用连字符
   wanglab@mgt:~/test$ cut -d " " -f 1 state | paste number
   1
   2
   3
   4
   5
   
   ## 使用连字符
   wanglab@mgt:~/test$ cut -d " " -f 1 state | paste number -
   1	Arunachal
   2	Assam
   3	Andhra
   4	Bihar
   5	Chhattisgrah
   
   ## pipeline的使用请自行学习
   wanglab@mgt:~/test$ cut -d " " -f 1 state | paste - number
   Arunachal	1
   Assam	2
   Andhra	3
   Bihar	4
   Chhattisgrah	5
   ```

   

## Reference

This article is contributed by **Akash Gupta**

[contribute.geeksforgeeks.org](http://www.contribute.geeksforgeeks.org/)