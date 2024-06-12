---
layout: post
title: Different Length List to Dataframe in R
subtitle: 故人何不返，春花复应晚。
date: "2024-06-12"
author: Chevy
header-img: img/055.png
catalog: true
tags:
  - 技术学习笔记
style: plain 
knit: (function(input, encoding) {
  rmarkdown::render(input, output_dir = "../_posts/")})
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
  # prettydoc::html_pretty:
  # theme: cayman
  # toc: yes
---

# 1. Set a demo list

``` r
# Your input list
gene_list <- list(
  GeneListA = c("A", "B", "C", "D", "E", "F"),
  GeneListB = c("A", "F", "H"),
  GeneListC = c("A", "C", "D", "H"),
  GeneListD = NA
)

print(gene_list)
```

    ## $GeneListA
    ## [1] "A" "B" "C" "D" "E" "F"
    ## 
    ## $GeneListB
    ## [1] "A" "F" "H"
    ## 
    ## $GeneListC
    ## [1] "A" "C" "D" "H"
    ## 
    ## $GeneListD
    ## [1] NA

# 2. Turn it into a dataframe

``` r
# Find the maximum length of the list elements
max_length <- max(sapply(gene_list, length))

# Create a data frame with columns named after list elements
gene_df <- as.data.frame(lapply(gene_list, function(x) {
  length(x) <- max_length # Extend each element to max length by padding with NAs
  return(x)
}))

# View the data frame
print(gene_df)
```

> We need to note that GeneListD could not be NULL

## Show you the difference

``` r
# Your input list
gene_list <- list(
  GeneListA = c("A", "B", "C", "D", "E", "F"),
  GeneListB = c("A", "F", "H"),
  GeneListC = c("A", "C", "D", "H"),
  GeneListD = c()
)


# Replace NULL with empty character vectors
gene_list_modified <- lapply(gene_list, function(x) if (is.null(x)) character(0) else x)

print(gene_list)
```

    ## $GeneListA
    ## [1] "A" "B" "C" "D" "E" "F"
    ## 
    ## $GeneListB
    ## [1] "A" "F" "H"
    ## 
    ## $GeneListC
    ## [1] "A" "C" "D" "H"
    ## 
    ## $GeneListD
    ## NULL

``` r
print(gene_list_modified)
```

    ## $GeneListA
    ## [1] "A" "B" "C" "D" "E" "F"
    ## 
    ## $GeneListB
    ## [1] "A" "F" "H"
    ## 
    ## $GeneListC
    ## [1] "A" "C" "D" "H"
    ## 
    ## $GeneListD
    ## character(0)

# 3. Then we could turn wider dataframe to longer dataframe using pivot function.
