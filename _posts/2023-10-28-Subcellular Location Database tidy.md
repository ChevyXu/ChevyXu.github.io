---
layout: post
title: Subcellular Location Database tidy
subtitle: 读书不下苦功，妄想显荣，岂有此理？
date: 2023-10-23
author: Chevy
header-img: img/52.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---



## 本文讨论对于不规则数据的简单处理

> 数据来源：https://www.uniprot.org/uniprotkb?query=%28keyword%3AKW-9998%29&facets=model_organism%3A9606



```shell
library(tidyverse)

# read in raw data --------------------------------------------------------
# download from https://www.uniprot.org/uniprotkb?query=%28keyword --------

raw_data <- data.table::fread("uniprotkb_AND_model_organism_9606_AND_r_2023_10_20.tsv")
head(raw_data)

# test split using different content --------------------------------------

raw_data$`Subcellular location [CC]`[3198]
raw_data$`Subcellular location [CC]`[4321]
raw_data$`Subcellular location [CC]`[3198] %>% 
  str_split_1("; |\\. ") %>%
  # paste(., collapse = "") %>% 
  # str_split_1("\\}.") %>%
  str_remove("SUBCELLULAR LOCATION: ") %>% 
  str_remove(pattern = "\\{.*") %>% 
  str_remove(pattern = "\\.$| $") %>% 
  stringi::stri_remove_empty() %>% 
  list() %>% 
  map_chr(paste, collapse = "; ")
  
# get annotation ---------------------------------------------------------

raw_data$`Subcellular Location` <- raw_data %>% 
  apply(1, function(x){x["Subcellular location [CC]"] %>% 
    str_split_1("; |\\. ") %>% 
    str_remove("SUBCELLULAR LOCATION: ") %>% 
    str_remove(pattern = "\\{.*") %>% 
    str_remove(pattern = "\\.$| $") %>% 
    stringi::stri_remove_empty()
  }) %>% 
  map_chr(paste, collapse = "; ")

# output excel file -------------------------------------------------------

writexl::write_xlsx(raw_data, path = "uniprotkb_subcellular_location.xlsx", col_names = T)
```
