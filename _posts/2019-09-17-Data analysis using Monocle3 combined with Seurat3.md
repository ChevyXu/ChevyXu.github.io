---
layout:	post
title:	scRNA-seq data analysis using Monocle3 combined with Seurat3
subtitle:	single cell and single learning
date:	2019-09-17
author:	Chevy
header-img:	img/11-min.jpg
catalog:	true
tags:
    - 技术学习笔记

---

# scRNA-seq data analysis using Monocle3 combined with Seurat3

徐春晖

2019-09-17

---

## 基本步骤

<<<<<<< HEAD
[TOC]

---

## Tips: 从Seurat3 pbmc构建数据到Monocle3

```r
#Extract count data, phenotype data, and feature data from the Seurat Object.
counts.data <- as(as.matrix(Seurat.object@assays$RNA@data), 'sparseMatrix')
pheno.data <- new('AnnotatedDataFrame', data = Seurat.object@meta.data)
feature.data <- data.frame(gene_short_name = row.names(counts.data), row.names = row.names(counts.data))
feature.data <- new('AnnotatedDataFrame', data = feature.data)

#Construct a CellDataSet.
cds <- newCellDataSet(counts.data, 
                      phenoData = pheno.data, 
                      featureData = feature.data)
```

## Step1: data read-in

```r
# ===========================================================================================data readin
=======
## Tips: 从Seurat3 pbmc构建数据到Monocle3

```r
# Extract count data, phenotype data, and feature data from the Seurat Object.
counts.data <- as(as.matrix(Seurat.object@assays$RNA@data), 'sparseMatrix')

pheno.data <- new('AnnotatedDataFrame', data = Seurat.object@meta.data)

feature.data <- data.frame(gene_short_name = row.names(counts.data), row.names = row.names(counts.data))

feature.data <- new('AnnotatedDataFrame', data = feature.data)

# Construct a CellDataSet.
cds <- newCellDataSet(counts.data, 
                   phenoData = pheno.data, 
                   featureData = feature.data)
```



## Step1: data read-in

```r
# ===================================================================data readin
>>>>>>> ae7e002d1660b2725edc2db55152957864950e4a
filter_umi <- 450
name <- character()
temp <- list.files(path = "../Raw_data/",pattern="*_gene_exon_tagged.dge.txt.gz")
temp

for(i in 1:length(temp)){
<<<<<<< HEAD
  name[i] <- unlist(strsplit(temp[i],"_out_gene_exon_tagged.dge.txt.gz"))[1]
  message(paste(name[i], "is loading"))
  
  tmpvalue<-read.table(paste0("../Raw_data/", temp[i]), sep = "\t", quote = "", row.names = 1, header = T)
  message(paste(name[i], "is loaded, now is adding name"))
  
  colnames(tmpvalue) <- paste0(name[i], "-", colnames(tmpvalue))         
  message(paste0(name[i], "'s name added, now filtering ", filter_umi))
  
  tmpvalue <- tmpvalue[,colSums(tmpvalue) >= filter_umi]
  message(paste(name[i], "cells above", filter_umi, "filtered"))
  
  assign(name[i], tmpvalue)
  rm(tmpvalue)
}
message("data loading done, and strat merge counts file")

# ===========================================================================================UMI summary
summary <- NULL
for (s in 1:length(temp)) {
  summary <- cbind(summary, as.matrix(summary(colSums(get(name[s])))))
=======
    name[i] <- unlist(strsplit(temp[i],"_out_gene_exon_tagged.dge.txt.gz"))[1]
    message(paste(name[i], "is loading"))
    
    tmpvalue<-read.table(paste0("../Raw_data/", temp[i]), 
                         sep = "\t", quote = "", row.names = 1, header = T)
    message(paste(name[i], "is loaded, now is adding name"))
    
    colnames(tmpvalue) <- paste0(name[i], "-", colnames(tmpvalue))
    message(paste0(name[i], "'s name added, now filtering ", filter_umi))
    
    tmpvalue <- tmpvalue[,colSums(tmpvalue) >= filter_umi]
    message(paste(name[i], "cells above", filter_umi, "filtered"))
    
    assign(name[i], tmpvalue)
    rm(tmpvalue)
}
message("data loading done, and strat merge counts file")

# ==============================================================UMI summary
summary <- NULL
for (s in 1:length(temp)) {
    summary <- cbind(summary, as.matrix(summary(colSums(get(name[s])))))
>>>>>>> ae7e002d1660b2725edc2db55152957864950e4a
}
colnames(summary) <- paste0(name, "'s UMI")
summary

<<<<<<< HEAD
# ===========================================================================================data merge
dge <- get(name[1])
for(p in 2:length(temp)) {
  dge_temp <- get(name[p])
  dge_merge <- dplyr::full_join(dge %>% mutate(name = rownames(dge)), 
                                dge_temp %>% mutate(name = rownames(dge_temp)))
  rownames(dge_merge) <- dge_merge$name
  dge <-  dplyr::select(dge_merge, -(name)) %>% na.replace(0)
  rm(dge_temp)
  rm(dge_merge)
=======
# ===============================================================data merge
dge <- get(name[1])
for(p in 2:length(temp)) {
    dge_temp <- get(name[p])
    dge_merge <- dplyr::full_join(dge %>% mutate(name = rownames(dge)), 
                                  dge_temp %>% mutate(name = rownames(dge_temp)))
    rownames(dge_merge) <- dge_merge$name
    dge <-  dplyr::select(dge_merge, -(name)) %>% na.replace(0)
    rm(dge_temp)
    rm(dge_merge)
>>>>>>> ae7e002d1660b2725edc2db55152957864950e4a
}
message("data merge done")
```

<<<<<<< HEAD
=======


>>>>>>> ae7e002d1660b2725edc2db55152957864950e4a
## Step2: cds construction

```r
cds <- new_cell_data_set(expression_data = as.matrix(dge),
                         cell_metadata = cell_metadata,
                         gene_metadata = gene_metadata)
```

## Step3: normalization and scale and PCA

```r
cds <- preprocess_cds(cds, 
                      method = "PCA", 
                      # use_genes = c(pbmc@assays$SCT@var.features),
                      num_dim = 50,
                      norm_method = "log", 
                      residual_mod
```

## Step4: UMAP or tSNE

```r
cds <- reduce_dimension(cds, 
                        cores = 4,
                        reduction_method = "UMAP", 
                        preprocess_method = "PCA")
                        
plot_cells(cds, 
           reduction_method = "UMAP", 
           color_cells_by = "Treat", 
           label_cell_groups = FALSE,
           cell_size = 1)
```

## Step5: clustering cells

```r
cds = cluster_cells(cds, 
                    reduction_method = "UMAP", 
                    k = 200)
plot_cells(cds, reduction_method = "UMAP", cell_size = 1)
```

## Step6: trajectory construction

```r
cds <- learn_graph(cds)
# 目前只支持针对UMAP结果做路径构建
```

## step7: order pesudotime

```r
cds <-  order_cells(cds)
plot_cells(cds,
           color_cells_by = "pseudotime",
           label_cell_groups = F,
           label_leaves = T,
           label_branch_points = T,
           graph_label_size = 4,
           cell_size = 2) 
```

## 问题

- 如何将Seurat3的PCA结果（和normalized counts）替换cds对应的步骤结果，也就是Step3，S4对象实在是比较难理解
- 因为trajectory只支持UMAP，如何取舍tSNE