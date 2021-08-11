---
layout: post
title: 计算二代测序数据的Insert size和standard deviation
subtitle: 涓涓不塞，将为江河。
date: 2021-08-03
author: Chevy
header-img: img/44.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## Solution 1：Picard的[CollectInsertSizeMetrics](https://gatk.broadinstitute.org/hc/en-us/articles/360037055772-CollectInsertSizeMetrics-Picard-)命令

该工具为验证文库构建提供了有用的指标，包括双端文库的插入大小分布和读取方向。

预期的文库指标数据与建库方法有很大的关联。

CollectInsertSizeMetrics命令输出的结果包括一个histogram和一个dataframe，包括fragment的的统计信息。

###### 使用示例：

```shell
java -jar picard.jar CollectInsertSizeMetrics \
      I=input.bam \
      O=insert_size_metrics.txt \
      H=insert_size_histogram.pdf \
      M=0.5
```

你会得到insert_size_metrics.txt，其中***MEAN_INSERT_SIZE***和***STANDARD_DEVIATION***列就是我们需要的结果了。

## Solution 2：使用python脚本计算

脚本如下

```shell
#! /usr/local/bin/python2.7
"""
mean_size.py
Created by Tim Stuart
"""

import numpy as np


def get_data(inp):
    lengths = []
    for line in inp:
        if line.startswith('@'):
            pass
        else:
            line = line.rsplit()
            length = int(line[8])
            if length > 0:
                lengths.append(length)
            else:
                pass
    return lengths


def reject_outliers(data, m=2.):
    """
    rejects outliers more than 2
    standard deviations from the median
    """
    median = np.median(data)
    std = np.std(data)
    for item in data:
        if abs(item - median) > m * std:
            data.remove(item)
        else:
            pass


def calc_size(data):
    mn = int(np.mean(data))
    std = int(np.std(data))
    return mn, std


if __name__ == "__main__":
    import sys
    lengths = get_data(sys.stdin)
    reject_outliers(lengths)
    mn, std = calc_size(lengths)
    print mn, std
```

###### 使用示例：

 ```shell
 head -10000 mapped.sam | python mean_size.py
 # 220 35
 samtools view mapped.bam | head -10000 | python mean_size.py
 # 220 35
 ```



## Solution 3：使用shell的awk计算

示例：

```shell
awk '{ if ($9 > 0) { N+=1; S+=$9; S2+=$9*$9 }} END { M=S/N; print "n="N", mean="M", stdev="sqrt ((S2-M*M*N)/(N-1))}' sample.sam
## 数据过滤，以insert size <2000 为限制举例
awk '{ if ($9 > 0) {if ($9 <2000){ N+=1; S+=$9; S2+=$9*$9 }}} END { M=S/N; print "n="N", mean="M", stdev="sqrt ((S2-M*M*N)/(N-1))}' sample.sam
```

