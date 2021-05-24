---
layout: post
title: R语言对RNA-seq画火山图
subtitle: 谢却海棠飞尽絮，困人天气日初长。
date: 2021-05-14
author: Chevy
header-img: img/41.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

### 首先安装我们会用到的包并加载

```shell
# 安装tidyverse
install.packages("tidyverse")
install.packages("ggrepel")

library(tidyverse)
## -- Attaching packages -------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --
## √ ggplot2 3.3.3     √ purrr   0.3.4
## √ tibble  3.0.5     √ dplyr   1.0.3
## √ tidyr   1.1.2     √ stringr 1.4.0
## √ readr   1.4.0     √ forcats 0.5.0
library(ggrepel)
```

### 随后读入数据并对label进行定义

```shell
# load data 
genes <- read.table("https://gist.githubusercontent.com/stephenturner/806e31fce55a8b7175af/raw/1a507c4c3f9f1baaa3a69187223ff3d3050628d4/results.txt", header = TRUE)
head(genes)

##      Gene log2FoldChange    pvalue      padj
## 1    DOK6         0.5100 1.861e-08 0.0003053
## 2    TBX5        -2.1290 5.655e-08 0.0004191
## 3 SLC32A1         0.9003 7.664e-08 0.0004191
## 4  IFITM1        -1.6870 3.735e-06 0.0068090
## 5   NUP93         0.3659 3.373e-06 0.0068090
## 6 EMILIN2         1.5340 2.976e-06 0.0068090


# categorize genes that have absolute log2 fold change > 1 and p-adjusted-value < Bonferroni cut-off (usually 0.05)
# label both absolute log2 fold change > 2 and p-adjusted-value < 0.05 as "both"
# labels onl p-adjusted-value < 0.05 as "significant"
# label only absolute log2 fold change > 2 as "log2FC > 1"
genes$labels <- ifelse(abs(genes$log2FoldChange) > 1 & genes$padj < 0.05, "Both", 
                       ifelse(genes$padj < 0.05, "Significant",
                              ifelse(abs(genes$log2FoldChange) > 1, "log2FC > 1", "None")))
count(genes, labels)

## # A tibble: 4 x 2
##        labels     n
##         <chr> <int>
## 1        Both    17
## 2  log2FC > 1    93
## 3        None 16291
## 4 Significant     5


```

### 最后常规ggplot2作图

```shell
# draw the basic structure of volcano plot
p <- ggplot(genes, aes(log2FoldChange, -1*log10(padj))) 
p <- p + geom_point(aes(color=labels), alpha=0.4, size=1.75) 

# add text for dots with abs(log2FC) > 1 and padj < 0.05
# to avoid the overlaps between text, we use geom_text_repel to separate them
p <- p + geom_text_repel(data = subset(genes, labels == "Both"), aes(label = Gene), size = 3) 

# change color by groups
# the order of the color is the alphabet order of label names
p <- p + scale_color_manual(values =c("red", "orange", "grey", "blue")) 

# set a and y axis limits
p <- p + xlim(c(-2.5, 2.5)) + ylim(c(0, 8))

# add vertical and horizontal
p <- p + geom_vline(xintercept=c(-1,1), lty=4, col="black", lwd=0.6)
p <- p + geom_hline(yintercept = -log10(0.05), lty=4, col="black", lwd=0.6)

# add title and axis titles
p <- p + labs(title="Volcano plot", x=expression(log[2](Fold_Change)), y=expression(-log[10](p_adjusted_value))) 

# set background
p <- p + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) 

# set plot theme
p <- p + theme(
          # Change the color, size and the face of main title, x and y axis labels
          plot.title = element_text(color="red", size=15, face="bold.italic", hjust = 0.5), #centered the title
          axis.title.x = element_text(color="blue", size=12, face="bold"),
          axis.title.y = element_text(color="#993333", size=12, face="italic"),
          # set legend 
          legend.position="right",
          legend.title = element_blank(),
          legend.text= element_text(face="bold", color="black",family = "Times", size=8),
          # set axis tick 
          axis.text.x = element_text(face="bold", color="black", size=12),
          axis.text.y = element_text(face="bold",  color="black", size=12))
p
```

[![volcano.md.png](https://img.xuchunhui.top/images/2021/05/25/volcano.md.png)](https://img.xuchunhui.top/image/X4QF)