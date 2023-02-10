---
layout: post
title: Installing SAMtools on Ubuntu
subtitle: 行前定，则不疚。道前定，则不穷。
date: 2023-02-10
author: Chevy
header-img: img/055.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 背景

心血来潮现在本地的工作上跑跑RNA-seq分析流程，在配置samtools的时候使用conda配置后出现了报错：

```shell
samtools: symbol lookup error: /lib/x86_64-linux-gnu/libp11-kit.so.0: undefined symbol: ffi_type_pointer, version LIBFFI_BASE_7.0
```

可惜的是，尽管我也搜索到有其他人遇到了同样的问题，但是我最后依旧没有能解决掉这个报错：

[ffi_type_pointer, version LIBFFI_BASE_7.0](https://stackoverflow.com/questions/75045632/apt-update-failed-libp11-kit-so-0-undefined-symbol-ffi-type-pointer-version)

## 解决方案

<*重剑无锋*，大巧不工>

我选择从官网直接install

### Preparing system

```shell
sudo apt-get update
sudo apt-get upgrade
```

### Installing Pre-requisites

```shell
sudo apt-get install -y libncurses-dev libbz2-dev liblzma-dev zlib1g-dev
```

### Downloading SAMtools

```shell
wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2
# 如果网络问题可以从GitHub上直接点击下载
```

### Installing SAMtools

```shell
tar xvjf samtools-1.12.tar.bz2
cd samtools-1.16.1
./configure
make
sudo make install
```

最后一步会输出：

```shell
$ sudo make install
mkdir -p -m 755 /usr/local/bin /usr/local/bin /usr/local/share/man/man1
install -p samtools /usr/local/bin
install -p misc/ace2sam misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim /usr/local/bin
install -p misc/blast2sam.pl misc/bowtie2sam.pl misc/export2sam.pl misc/fasta-sanitize.pl misc/interpolate_sam.pl misc/novo2sam.pl misc/plot-ampliconstats misc/plot-bamstats misc/psl2sam.pl misc/sam2vcf.pl misc/samtools.pl misc/seq_cache_populate.pl misc/soap2sam.pl misc/wgsim_eval.pl misc/zoom2sam.pl /usr/local/bin
```

