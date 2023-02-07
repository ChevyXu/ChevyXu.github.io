---
layout: post
title: singscore包计算signature脚本示例
subtitle: 飒飒东风细雨来，芙蓉塘外有轻雷。
date: 2023-02-06
author: Chevy
header-img: img/055.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 背景

Attached please find the singscore script I just write with annotation; it may help if you want to continue with it.

- SummarizedExperiment is an object which need to know before you use singscore.
- GSEABase::GeneSet could be used to create gene set object.

And glad you ultimately find a way to do all the method.

## 代码

```shell
#===============================================================================
# singscore script
#===============================================================================

# install bofore library it~
library(singscore)
library(GSEABase)
library(SummarizedExperiment)

#===============================================================================
# prepare SummarizedExperiment
#===============================================================================

# example expression data set
# tgfb_expr_10_se %>% assay()

# construct self-SummarizedExperiment
nrows <- 200
ncols <- 6
counts <- matrix(runif(nrows * ncols, 1, 1e4), nrows)
rownames(counts) <- paste0("gene_", 1:200)

# feature
rowRanges <- GRanges(rep(c("chr1", "chr2"), c(50, 150)),
                     IRanges(floor(runif(200, 1e5, 1e6)), width=100),
                     strand=sample(c("+", "-"), 200, TRUE),
                     feature_id=sprintf("ID%03d", 1:200))

# sample data
colData <- DataFrame(Treatment=rep(c("ChIP", "Input"), 3),
                     row.names=LETTERS[1:6])
# raw info
metadata <- "this is ax example for how to establish a SE object" 

se <- SummarizedExperiment(assays=list(counts=counts),
                           rowRanges=rowRanges, 
                           colData=colData,
                           metadata=metadata)

assay(se)
colData(se)
rowRanges(se)
rowData(se)

#===============================================================================
# prepare gene set
#===============================================================================

# example gene set
tgfb_gs_up %>% class()
tgfb_gs_dn

# get gene ids
tgfb_gs_up@geneIds
GSEABase::geneIds(tgfb_gs_up)

# create self-gene set using GeneSet function
# ## Empty gene set
# GeneSet()
# 
# ## Gene set from ExpressionSet
# data(sample.ExpressionSet)
# gs1 <- GeneSet(sample.ExpressionSet[100:109])
# 
# ## GeneSet from Broad XML; 'fl' could be a url
# fl <- system.file("extdata", "Broad.xml", package="GSEABase")
# gs2 <- getBroadSets(fl)[[1]] # actually, a list of two gene sets
# 
# ## GeneSet from list of gene identifiers
# geneIds <- geneIds(gs2) # any character vector would do
# gs3 <- GeneSet(geneIds)
# ## unspecified set type, so...
# is(geneIdType(gs3), "NullIdentifier") == TRUE
# ## update set type to match encoding of identifiers
# geneIdType(gs2)
# geneIdType(gs3) <- SymbolIdentifier()
# ## other ways of accomplishing the same
# gs4 <- GeneSet(geneIds, geneIdType=SymbolIdentifier())
# gs5 <- GeneSet(SymbolIdentifier(), geneIds=geneIds)

gs <- GeneSet(c("KIT", "CTSG", "MPO", "DUSP4"), geneIdType=SymbolIdentifier())
gs <- GeneSet(paste0("gene_", 1:100), geneIdType=SymbolIdentifier())

#===============================================================================
# sample scoring
#===============================================================================
rankData <- rankGenes(se)

scoredf <- simpleScore(rankData = rankData, upSet = gs, knownDirection = F)
# scoredf <- simpleScore(rankData, upSet = tgfb_gs_up, downSet = tgfb_gs_dn)

scoredf
```



## 参考文献
- [Bioconductor数据结构简介之SummarizedExperiment](https://www.sciencedirect.com/science/article/pii/S2212968515000069)
- [Methods to construct GeneSet instances](https://rdrr.io/bioc/GSEABase/man/GeneSet-methods.html)