---
layout:	post
title:	无root权限配置zsh及oh-my-zsh
subtitle:	杜鹃啼月一声声，等闲又是三春尽。
date:	2019-11-3
author:	Chevy
header-img:	img/14.jpg
catalog:	true
tags:
    - 技术学习笔记

---

### 前言

近找所里的平台新申请了一个服务器账号，第一步当然是配置一个顺手的shell及安装常用软件了，苦于没有root权限，导致我死在了安装`zsh`的第一步：`yum install zsh`

### zsh的安装

[洲更的 B站视频]( https://www.bilibili.com/video/av62804850 )已经很明白的介绍了zsh是什么及oh-my-zsh的安装，主题的更换等等

#### 搜索得到的解决办法

`google`是个好东西， [这篇文章](https://www.hijerry.cn/p/37831.html) 详细的阐述了如何在没有root权限下搞定`zsh`的安装

其基本思路为，手动安装`zsh`到家目录`$HOME`下，随后将路径写入`$PATH`，这样就命令行可以识别`zsh`了，但是更改`zsh`为默认shell还需要进一步的操作：

1. 使用`chsh`进行更改（但是由于缺少root权限，并无法实现）
2. 在启动时执行`zsh`，即将`exec zsh`写入到`.bashrc`或者`.profile`里

> 该思路可以完成目标

#### 我的解决方案

首先在`bash`里安装`conda`，随后使用`conda install zsh`完成`zsh`的安装，但是这个时候我们需要注意的是，`zsh`的路径在`$HOME/PATH-to-anaconda3/bin/zsh`，所以需要执行``. $HOME/PATH-to-anaconda3/bin/zsh``才行

```shell
echo '[ -f $HOME/biosoft/anaconda3/bin/zsh ] && exec $HOME/biosoft/anaconda3/bin/zsh -l' >> .bashrc
```

> 重启shell后，完美解决了问题

### on-my-zsh的安装

这个就比较简单了，[官网]( https://ohmyz.sh/ )给出了代码 `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" `

随后在`.zshrc`文件里面即可进行配置（依据已有的代码进行修改）

### 需要注意

如果是使用 conda安装的zsh，随后使用zsh作为默认shell的时候，需要使用`conda init zsh`进行环境配置

---

### powerlevel9k or powerlevel10k

[配置好看的zsh吧！]( https://coreja.com/DailyHack/2019/08/config-your-super-zsh/ )这篇文章给出了博主的powerlevel9k配置方案，只需要下载[这个包](https://coreja.com/DailyHack/2019/08/config-your-super-zsh/oh-my-zsh.zip)，进行替换就可以了

> 需要注意的是，这个主题因为有很多的特殊字符所以需要安装powerline字体，Ubuntu或者macOS系统的搞定比较简单，Windows下暂时还没没有很好的解决方法

分享一个我配置好的xshell客户端下的界面

![](https://upload-images.jianshu.io/upload_images/6049898-5dd270480ade176c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)