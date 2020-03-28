---
layout: post
title: 使用DESeq2分析RNA-seq数据
subtitle: 二月东湖湖上路，官柳嫩，野梅残。
date: 2020-03-28
author: Chevy
header-img: img/20.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---



本文依据[Analyzing RNA-seq data with DESeq2](<http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html>)进行解读后撰写，包含差异分析必备流程及必备知识

---

前言：RNA-seq的基本任务就是检测差异基因，基于我们拥有的多个样本表达矩阵数据，一个重要的问题就是基因表达的定量和在不同条件下表达变化的统计推断。

DEseq2包提供了基于负二项分布构建的线性模型对差异表达进行检测，使用数据的先验分布进行离散程度及倍数变化的估计。

> 如果你在发表文章时使用到DEseq2包，请引用：
>
> Love, M.I., Huber, W., Anders, S. (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology*, **15**:550. [10.1186/s13059-014-0550-8](http://dx.doi.org/10.1186/s13059-014-0550-8)

[TOC]

### 1. 标准流程

此时的设定是，我们拿到了表达矩阵`cts is your counts matrix`， 同时我们构建了样本信息文件`coldata is your design information`，那么最快速的差异分析流程如下：

```
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~ batch + condition)
dds <- DESeq(dds)
resultsNames(dds) # lists the coefficients
res <- results(dds, name="condition_trt_vs_untrt")
# or to shrink log fold changes association with condition:
res <- lfcShrink(dds, coef="condition_trt_vs_untrt", type="apeglm")
```

某些情况的小tips：

- 如果你使用例如`Salmon`, `Sailfish`或者`kallisto`产生的转录本定量文件，那么你需要使用`DESeqDataSetFromTximport`来读入数据
- 如果你使用`htseq-count`拿到的表达矩阵，那么你需要使用`DESeqDataSetFromHTSeq`来读入数据
- 如果你有一个`rangedSummarizedExperiment`，那么你需要使用`DEseqDataSet`

### 2. 如何得到DEseq2相关的帮助

所有DEseq2相关的问题都已经发布在[**Bioconductor support site**]([https://support.bioconductor.org](https://support.bioconductor.org/))

如果你有什么问题，也可以在此页面发表post（具体信息请查看 [Frequently Asked Questions](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#FAQ) (FAQ) ）

### 3.dds对象的构建

#### 矩阵需要预处理吗（比如是否normalize）

提供表达counts矩阵作为DESeq2统计模型的输入数据是很重要的，因为只有counts值才能正确评估测量精度。DESeq2模型在内部纠正了库大小，因此转换或标准化的值(如按库大小缩放的计数)不应该用作输入

#### DESeqDataSet(dds)对象了解

DESeq2包使用DESeqDataSet(dds)作为存放count数据及分析结果的对象，每个DESeqDataSet(dds)对象都必须由以下三者：

- countData，存放counts matrix的对象
- colData，存放分组信息和处理信息的对象

- design公式，对应sample的分组信息以备后续的统计分析，需要以`~` 波浪字符进行连接，而不同的信息之间需要以+连接，示例写法为`design=~variable_1 + variable_2`；而这些分组信息会被用来估算离散度和估算Log2 fold change的模型

> 注意，为了方便起见，在默认参数下，用户应该把感兴趣的分组信息放在formula的最后，并且确认control组的level是第一个（因子的level，见R语言基础视频）

#### 从表达矩阵（counts matrix）构建dds

本次课程，我们通过Linux的处理，拿到了表达矩阵，所以我们使用`DESeqDataSetFromMatrix`构建我们的dds对象

```
# ===================================================================================package library
library(DESeq2)

# ===================================================================================dds construct
# =====================================================================data read_in
countsdata <- read.table(file = paste0(getwd(), "/expr_matrix"), 
                         header = T, 
                         sep = "\t", 
                         quote = "", 
                         check.names = F)

# =====================================================================construct countdata
countdata <- countsdata[,7:10]
rownames(countdata) <- countsdata[,1]

# =====================================================================construct coldata
coldata <- data.frame(Sample = factor(c(rep("EZH1_KD",2), rep("Control",2)), 
                                      levels = c("Control", "EZH1_KD")),
                      row.names = colnames(countdata))
coldata
coldata$Sample

# =====================================================================construct dds
dds <- DESeqDataSetFromMatrix(countData = countdata, 
                              colData = coldata, 
                              design = ~ Sample ) 
dds
```

#### 我们是否需要过滤数据？

对于原始数据，除非是处于降低内存使用或者测试DEseq2，我们无需进行基于counts数的过滤，因为`result`函数提供了一个更加严格的基于normalize后的counts均值的过滤

#### 关于合并重复的选项

生物学重复的数据是不需要合并的，但是技术性重复的数据需要合并（例如一个library在两个lane上测了两遍）

### 4. 差异分析

所有的差异分析的步骤在目前的DEseq2包里面都被整合到函数`DESseq`中了，它可以一条龙的完成以下操作:

- 估算size factor
- 估算离散度
- 估算基因的离散度
- 均值-离散度关系
- 估算最终离散度
- 模型适应和测试

你只需要使用`DEseq`函数处理`dds`对象即可

> 默认参数的情况下，`DEseq`函数会以design的公式的最后一个分组类别信息进行差异分析，并且是将最后一个分组类别信息中第一个因子水平作为control，后一个因子水平作为treatment，当然你也可以使用`name`或者`contrast`参数进行设置

而`results`可以从差异分析后的`dds`对象中提取出分析表格进行数据导出：

```
# ===================================================================================DEG test
# ---------------------------------------------------------------------perform analysis 
dds <- DESeq(dds)

# ---------------------------------------------------------------------extract data table
res <- results(dds)
# or
res <- results(dds, name = "Sample_Knockdown_vs_Control")
resultsNames(dds)
res <- results(dds, name = resultsNames(dds)[2])
# or
res <- results(dds, contrast = c("Sample","Knockdown","Control"))

head(res)
head(as.data.frame(res))
```



那么`res`就是我们拿到的差异分析结果了，使用`as.data.frame`函数可以将的`res`转化为我们熟悉的data.table

#### lfcShrink

什么是lfcShrink呢，全称就是`Log fold change shrinkage`，它是用来处理`dds`对象的，其目的是为了解决低counts基因或者高离散度的数据在计算log fold change时引起的误差，在使用它的时候需要先安装好对应的R包`BiocManager::install("apeglm")`OR`install.packages("ashr")`，随后指明coefficient即可：

```
# ---------------------------------------------------------------------lfcShrink
BiocManager::install("apeglm")
install.packages("ashr")

resLFC <- lfcShrink(dds, coef = "Sample_Knockdown_vs_Control", type = "apeglm")
resLFC <- lfcShrink(dds, coef = resultsNames(dds)[2], type = "apeglm")
# or using default method in old version
resLFC <- lfcShrink(dds, contrast = c("Sample","Knockdown","Control"))
# or using ashr method 
resLFC <- lfcShrink(dds, coef = "Sample_Knockdown_vs_Control", type = "ashr")

resLFC
```

> 问：是否需要做lfcShrink呢？
>
> 答：我的建议是使用lfcShrink获得你的res，虽然标准流程里面并不包含这个步骤，但是你可以依据这个方法获得更加准确的差异基因，减少你的假阳性，并且具有作图友好性

#### 得到差异数据

数据分析都讲究一个用户交互，拿到我们的分析表格以后，大家的惯性思维都是首先去看最前面的几行数据，这也就要求我们对结果文件进行简单的处理，得到一个大家看得懂，大家用的好的分析结果

首当其冲的当然依据p.adj来对分析结果进行排序，p值最小的甩在最前面，然后最好我们还要在分析结果里面提供最原始的count值以便别人可以使用原始数据重新分析数据，同时还要算上一个FPKM值给没有生信基础的人员可以直观的去比较基因表达，最后还要使用通用的阈值来界定差异表达基因，这样才算是一个好的分析结果：

```
# sort by p.adj
res <- res[order(res$padj),]
# get diff_gene
diff_gene <- subset(res, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))

resdata <- merge(as.data.frame(res), 
                 as.data.frame(counts(dds, normalized=F)), 
                 by="row.names", sort=FALSE)

resdata$significant <- "unchanged"
resdata$significant[resdata$padj <= 0.05 & resdata$log2FoldChange >= 1 ] <- "upregulated"
resdata$significant[resdata$padj <= 0.05 & resdata$log2FoldChange <= -1 ] <- "downregulated"

head(resdata)
```

### 5. 一站式分析脚本

```
# ===================================================================================package library
library(DESeq2)

# ===================================================================================dds construct
# ---------------------------------------------------------------------data read_in
countsdata <- read.table(file = paste0(getwd(), "/expr_matrix"), 
                         header = T, 
                         sep = "\t", 
                         quote = "", 
                         check.names = F)
head(countsdata)
# ---------------------------------------------------------------------construct countdata
countdata <- countsdata[,7:10]
rownames(countdata) <- countsdata[,1]

# ---------------------------------------------------------------------construct coldata
coldata <- data.frame(Sample = factor(c(rep("Knockdown",2), rep("Control",2)), 
                                      levels = c("Control", "Knockdown")),
                      row.names = colnames(countdata))
coldata
coldata$Sample

# ---------------------------------------------------------------------construct dds
dds <- DESeqDataSetFromMatrix(countData = countdata, 
                              colData = coldata, 
                              design = ~ Sample ) 
dds

# ===================================================================================DEG test
# ---------------------------------------------------------------------perform analysis 
dds <- DESeq(dds)

# ---------------------------------------------------------------------lfcShrink
BiocManager::install("apeglm")

res <- lfcShrink(dds, coef = "Sample_Knockdown_vs_Control", type = "apeglm")

# ===================================================================================get results
# sort by p.adj
res <- res[order(res$padj),]
# get diff_gene
diff_gene <- subset(res, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))

resdata <- merge(as.data.frame(res), 
                 as.data.frame(counts(dds, normalized=F)), 
                 by="row.names", sort=FALSE)

resdata$significant <- "unchanged"
resdata$significant[resdata$padj <= 0.05 & resdata$log2FoldChange >= 1 ] <- "upregulated"
resdata$significant[resdata$padj <= 0.05 & resdata$log2FoldChange <= -1 ] <- "downregulated"

head(resdata)
```

### 6. 学习任务

- 构建一个10000 X 2 的data.frame，尝试使用多种方法求出第一列数值中的最小值
- 假设上述10000 X 2 的data.frame的第一列为gene length，第二列为gene counts，试着使用FPKM的公式计算FPKM

```
# ===================================================================================tasks
test_data_frame <- data.frame(length = rnorm(n = 10000, mean = 1500, sd = 200), 
                              counts = rnorm(n = 10000, mean = 150, sd = 20))
```

