---
layout: post
title: R语言读入Excel多个sheet数据
subtitle: 云雨无情难管领，任他别嫁楚襄王。
date: 2021-04-26
author: Chevy
header-img: img/40.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

# 子标题
> readxl::read_excel(): importing multiple worksheets

# 介绍
[readxl](https://readxl.tidyverse.org/)包是一个用于读入Excel数据（包括.xls, .xlsx为文件）到R里面的包。

当然除了`readxl`包以外还有一下这些包可以做到：1）返回sheet的名称；2）读入每个sheet的数据：

1. “[XLConnect](https://cran.r-project.org/web/packages/XLConnect/index.html)”
2. “[gdata](https://cran.r-project.org/web/packages/gdata/index.html)”
3. “[xlsx](https://cran.r-project.org/web/packages/xlsx/index.html)”

我们会加在`readxl`包并且的读入示例数据：*datasets.xlsx* ，主要会用到`read_excel`函数和`excel_sheets`函数。

首先安装和加载R包（`plyr`包的`rbind.fill`函数用以整合所有sheet的数据到一个变量里，这里需要注意`rbind.fill`是个很有用的函数，按列合并可以用`dplyr`包的各种join函数）：

```shell
# 首先先安装readxl包或者tidyverse包
# install.packages("readxl") or install.packages("tidyverse")
library(readxl)
library(plyr)
library(tibble)
```

Note that there is a *readxl_example()* function that eases loading of the example files - i.e doesn’t require specification of a file path or additional arguments - but for this exercise we will use *read_excel* and assume that our working directory is not one of library subdirectories. The “datasets.xlsx” has four (4) tabs, with the iris, mtcars, chickwts and quakes datasets.

```
# You would need to use readxl_example() or specify the path relevant to your
# terminal.

xl_data <- "C:/Users/Chevy/Documents/R/win-library/3.4/readxl/extdata/datasets.xlsx"

# Before reading data, we will return the names of the sheets for later use:
excel_sheets(path = xl_data)
## [1] "iris"     "mtcars"   "chickwts" "quakes"
# We will now read in just the quakes data. First, specifying by sheet name, then by number

df_quakes_name <- read_excel(path = xl_data, sheet = "quakes")

df_quakes_number <- read_excel(path = xl_data, sheet = 4)

identical(df_quakes_name, df_quakes_number)
## [1] TRUE
```

We may want to import all sheets from a workbook. We will do this via *lapply()*, iterating over the names (or range) of our sheets; passing *read_excel()* as our function. The resulting object should be a list of four (4) data frames; one (1) per tab.

```
tab_names <- excel_sheets(path = xl_data)

list_all <- lapply(tab_names, function(x) read_excel(path = xl_data, sheet = x))

str(list_all)
## List of 4
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    150 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##   ..$ Sepal.Width : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##   ..$ Petal.Length: num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##   ..$ Petal.Width : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##   ..$ Species     : chr [1:150] "setosa" "setosa" "setosa" "setosa" ...
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    32 obs. of  11 variables:
##   ..$ mpg : num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##   ..$ cyl : num [1:32] 6 6 4 6 8 6 8 4 4 6 ...
##   ..$ disp: num [1:32] 160 160 108 258 360 ...
##   ..$ hp  : num [1:32] 110 110 93 110 175 105 245 62 95 123 ...
##   ..$ drat: num [1:32] 3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##   ..$ wt  : num [1:32] 2.62 2.88 2.32 3.21 3.44 ...
##   ..$ qsec: num [1:32] 16.5 17 18.6 19.4 17 ...
##   ..$ vs  : num [1:32] 0 0 1 1 0 1 0 1 1 1 ...
##   ..$ am  : num [1:32] 1 1 1 0 0 0 0 0 0 0 ...
##   ..$ gear: num [1:32] 4 4 4 3 3 3 3 4 4 4 ...
##   ..$ carb: num [1:32] 4 4 1 1 2 1 4 2 2 4 ...
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    71 obs. of  2 variables:
##   ..$ weight: num [1:71] 179 160 136 227 217 168 108 124 143 140 ...
##   ..$ feed  : chr [1:71] "horsebean" "horsebean" "horsebean" "horsebean" ...
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    1000 obs. of  5 variables:
##   ..$ lat     : num [1:1000] -20.4 -20.6 -26 -18 -20.4 ...
##   ..$ long    : num [1:1000] 182 181 184 182 182 ...
##   ..$ depth   : num [1:1000] 562 650 42 626 649 195 82 194 211 622 ...
##   ..$ mag     : num [1:1000] 4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
##   ..$ stations: num [1:1000] 41 15 43 19 11 12 43 15 35 19 ...
```

*read_xl()* accepts additional arguments for specifying column types (“col_types”), column names (“col_names”), ranges of cells to read (as opposed to an entire sheet), number of lines to skip when reading in and others.

Lastly, we may have workbooks with sheets identically formatted, but with novel data; e.g. tabs per month, year, location. The following code reads in the worksheets as above, but the list is then collapsed into a single data frame. Note that there are multiple ways to accomplish this task. The example workbook has three (3) identical sheets: “Sheet1”, “…2” and “…3”. Each sheet has the same three (3) columns - “column1”, “…2” and “…3” - each with twenty (20) elements:

1. column1: A-B-C-D, repeating
2. column2: integers 1 through 20
3. column3: A-B, repeating

```
sheets <- excel_sheets("readxl_example.xlsx")

list_all_example <- lapply(sheets, function(x) read_excel("readxl_example.xlsx", sheet = x))

str(list_all_example)
## List of 3
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    20 obs. of  3 variables:
##   ..$ column1: chr [1:20] "A" "B" "C" "D" ...
##   ..$ column2: num [1:20] 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ column3: chr [1:20] "A" "B" "A" "B" ...
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    20 obs. of  3 variables:
##   ..$ column1: chr [1:20] "A" "B" "C" "D" ...
##   ..$ column2: num [1:20] 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ column3: chr [1:20] "A" "B" "A" "B" ...
##  $ :Classes 'tbl_df', 'tbl' and 'data.frame':    20 obs. of  3 variables:
##   ..$ column1: chr [1:20] "A" "B" "C" "D" ...
##   ..$ column2: num [1:20] 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ column3: chr [1:20] "A" "B" "A" "B" ...
# Then, to create single data frame:
df <- rbind.fill(list_all_example)
str(df)
## 'data.frame':    60 obs. of  3 variables:
##  $ column1: chr  "A" "B" "C" "D" ...
##  $ column2: num  1 2 3 4 5 6 7 8 9 10 ...
##  $ column3: chr  "A" "B" "A" "B" ...
# Or,
df_doCall <- do.call("rbind", list_all_example)
str(df_doCall)
## Classes 'tbl_df', 'tbl' and 'data.frame':    60 obs. of  3 variables:
##  $ column1: chr  "A" "B" "C" "D" ...
##  $ column2: num  1 2 3 4 5 6 7 8 9 10 ...
##  $ column3: chr  "A" "B" "A" "B" ...
# Or,
df_plyr <- plyr::ldply(list_all_example, data.frame)
str(df_plyr)
## 'data.frame':    60 obs. of  3 variables:
##  $ column1: chr  "A" "B" "C" "D" ...
##  $ column2: num  1 2 3 4 5 6 7 8 9 10 ...
##  $ column3: chr  "A" "B" "A" "B" ...
```

In the above, “df_doCall” is of classes “tbl_df” (tibble data frame), “tbl” (tibble) and “data.frame”. “tibbles” are a “[modern reimagining of the data frame](https://tibble.tidyverse.org/)…” The additional classes are a product of using the *read_excel()* function. The *rbind.fill()* and *ldply()* approaches coerce the resulting object to (only) data frame. However, we could coerce them back (or coerce “df_doCall” to a data frame):

```
df <- as.tibble(df)
df_plyr <- as.tibble(df)

identical(df, df_doCall)
## [1] TRUE
identical(df, df_plyr)
## [1] TRUE
```



# 引用

以上内容学习自[*readxl::read_excel()*; importing multiple worksheets](https://rpubs.com/tf_peterson/readxl_import)