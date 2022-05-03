---
layout: post
title: 配置iTerm2+oh-my-zsh
subtitle: 今夜偏知春气暖，虫声新透绿窗纱。
date: 2022-05-03
author: Chevy
header-img: img/48.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 前言

得空把手上笔记本的iTerm2和zsh配置了一下，记录一下以备后续使用。

本教程学习自：

 [mac之 iTerm2 + Oh My Zsh 终端安装教程](https://segmentfault.com/a/1190000039834490)

[iTerm2 配置和美化 - 少数派](https://sspai.com/post/63241)

## 一、iTerm2配置

##### 1. 首先，下载iTerm2来替换默认终端。

[iTerm2](https://iterm2.com/)

##### 2. 调整Status Bar

> 将 iTerm2 自带 theme 修改为 Minimal （ Preferences-Appearance-General-Theme ） 以达到顶栏沉浸式的效果

可以在Profiles选项卡，Session页面最底部看到开启选项。Status bar enabled 选项，勾选上即可打开。点击右边的 Configure Status Bar 按钮可设置显示的内容。

可以看到能显示的内容非常多，把上方要显示的内容拖动到下方 Active Components 区域即添加。

在Preference页面中点击Appearance选项卡，可以设置Status bar的位置，修改 Status bar location，我这里改到Bottom底部。

##### 3. 更改颜色

这个千人千色，自己选择，图省事可以使用`Pastel`。

我比较喜欢 Dracula 配色方案，包括VS Code使用的都是这个配色方案。

https://draculatheme.com/iterm/

解压后更换 Preferences-Profiles-Color-Color Presets-Import

## 二、oh-my-zsh配置

#### 安装oh-my-zsh

```shell
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 配置zsh主题

官方收集了一些主题（不再收录新主题），你可以访问 [主题&&截图](https://link.segmentfault.com/?enc=aDW7xc41dkkS79ruBVrMGw%3D%3D.3YV5GoIDAAZ%2BskOnXORZegKkcY6KZO0UB8HNU7TNE0VTfYLLIJwJJ359Ub5r5Yd5) 页面查看并选取。

这里以`agnoster`为例说明：

##### 1. 编辑`~/.zshrc`文件，修改`ZSH_THEME`配置：

```shell
ZSH_THEME="agnoster"
# 主题介绍请访问 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster
```

##### 2. 安装字体

`agnoster`还需要额外安装字体 [Meslo for Powerline](https://link.segmentfault.com/?enc=p3GGdzD5QiU2oD9xph3idg%3D%3D.3jLGEWKkhme9u8aCe6J8TS3uAzAgO6ilqAGGlARLiuSimyuQFbzzDPS5PG3n%2BUfo%2FUdwRENiRy11ZEZT1Zeg1tKvtgEYacQQRq2vYl1SQmbxGnT5Q%2BdZ77G25LSxdjqq4LitncGBjkvcB594ugel8A%3D%3D)

> 大部分主题都用到了 [Powerline Fonts](https://link.segmentfault.com/?enc=TGAWWFk%2BzfFPV7VhaE84Ug%3D%3D.uD%2B7fP3%2FQaTygbMIBPFIFzIMPaRFuGqpCjK4FCrutVwHAsKenZy9taoBbbjVK9NL)

下载好`ttf`文件，双击即可完成安装。

##### 3. 选择字体

打开iTerm2，`iTerm -> Preferences -> Profiles -> Text -> Change Font`，选择`Meslo LG S Regular for Powerline`。

## 三、功能增强

##### 1. zsh-autosuggestions，命令自动补全功能。

cd到plugins文件夹，执行一下命令`（默认位于`~/.oh-my-zsh/custom/plugins`）

```shell
git clone https://gitee.com/imirror/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

##### 2. zsh-syntax-highlighting，语法高亮。

cd到plugins文件夹，执行一下命令`（默认位于`~/.oh-my-zsh/custom/plugins`）

```shell
git clone https://gitee.com/imirror/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

##### 3. 在oh-my-zsh中启用插件

打开`~/.zshrc`，找到`plugins`，追加`zsh-autosuggestions zsh-syntax-highlighting`。

```shell
# 其中一行修改为
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

##### 4. 执行`source ~/.zshrc`生效
