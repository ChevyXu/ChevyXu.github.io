---
layout: post
title: Posting Rmarkdowns to your Jekyll website
subtitle: 蟠木不雕饰，且将斤斧疏。
date: 2024-01-24
author: Chevy
header-img: img/52.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 前言
> 最近习惯使用rmarkdown来写东西，主要好处是能够兼容图片，还可以一键推送到RPubs。

但是rmakrdown写完以后，遇到一个问题，以往使用markdown写的记录，可以很方便的转到Jekyll里面的post生成blog用于记录和分享，rmakrdown是不兼容的，但是保留脚本生成的图片其实还是我的刚需，所以就Jekyll和rmarkdown的联通做了一些搜索，予以记录。

## [方案一](https://jchellmuth.com/news/jekyll/website/code/2020/01/04/Rmarkdown-posts-to-Jekyll.html)

### Option 1: Uploading a complete / allinclusive html file

这个方案很简单，就是先用rmarkdown的knitr生成一个html文件，再在html文件的开头加上一段YAML：
```
---
layout: post
title: Your blog title
---
```

缺点：
-  事实上等于把网页插入到Jekyll新生成的网页下面，嵌套了，展示效果没有到最佳情况。

### Option 2: Uploading a markdown

