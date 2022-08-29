---
layout: post
title: 多设备git同一个账号到GitHub的同步问题
subtitle: 离心迸落叶，乡梦入寒流。
date: 2021-12-10
author: Chevy
header-img: img/48.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 最近在编辑bookdown，并且将这本Linux_Shell_Script托管到GitHub pages上。
现在用两个设备本地建立git仓库后同步到同一个GitHub的repo上，更换设备进行编辑的时候，首先会git pull，经常会导致出现冲突

> 《当GitHub的文件和本地文件不一致的时候，git pull命令会自动merge冲突，再让你手动修改》

### **我的需求是，以remote端的文件为最新版，同步到我的本地仓库后继续工作。**

#### 操作1：

方法来源于[reset-and-sync-local-respository-with-remote-branch](https://www.ocpsoft.org/tutorials/git/reset-and-sync-local-respository-with-remote-branch/)

此Git Tip将本地存储库转换为您仓库的远程镜像，命令如下：

```shell
git fetch origin && git reset --hard origin/master && git clean -f -d

## or

git fetch origin
git reset --hard origin/master
git clean -f -d

## Your local branch is now an exact copy (commits and all) of the remote branch.
```

#### 操作2：

我们同样可以编辑`.gitconfig`文件，里面加入一个快捷键

```shell
[alias]
    resetorigin = !git fetch origin && git reset --hard origin/master && git clean -f -d
    resetupstream = !git fetch upstream && git reset --hard upstream/master && git clean -f -d
```

随后使用`git resetupstream`或者 `git resetorigin` 即可一键同步。
