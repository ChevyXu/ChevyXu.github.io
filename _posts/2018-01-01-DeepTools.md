---
layout:     post
title:	DeepTools学习笔记
subtitle:   学习记录
date:       2017-10-01
author:     Chevy
header-img: img/deeptools_bg.jpg
catalog: true
tags:
    - 技术学习笔记
---
DeepTools学习笔记
===

# 前言

#### 开题啦，所以需要整合自己之前处理过的数据包括可视化作图，在GALAXY上翻到DeepTools正好有着一点用处，适当的搞了一波事情，顺带记录一下。GALAXY上可以可视化操作，其实也是一个考虑的选项。

### 现有资源 
>比对完成后的bam文件，参考基因组：hg19, 基因位置注释文件：RefGeneReg.bed，涉及到数据保密，不使用自己的数据进行演示
安装好的deeptools（使用anaconda，此处不赘述，安装后配置deeptools及环境即可，不需要自己去配置环境）


[官网](http://deeptools.readthedocs.io/en/latest/index.html)
![what can deeptools do for you](http://deeptools.readthedocs.io/en/latest/_images/start_collage.png)

![Basic workflow](http://deeptools.readthedocs.io/en/latest/_images/start_workflow1.png)
[manual book](http://deeptools.readthedocs.io/en/latest/content/list_of_tools.html#parameters-to-decrease-the-run-time)

---
# 正文

#### deeptools 上接比对好的bam文件或者转换好的bigwig文件，可以进行bam文件的处理及数据质控，对数据进行关联分析包括作图，而且可以根据提供的bed文件绘制热图/密度图


## DEEPTOOLS的三大功能
- BAM & bigWig file processing
- Tools for QC
- Heatmap and summary plot
- Miscellaneous(此处不涉及)

### 额外参数提示

```
# 处理器数目设定
-p max/2

# 针对指定区域进行处理
--region chr2:10000-20000

# ignoreDuplicates参数去除重复序列，针对匹配到同一方向同一起点的序列，只保留一个
-- ignoreDuplicates

# 匹配得分阈值设定
--minMappingQuality

# warning，deeptools是在scaling data做低质量数据去除和去重，所以如果数据质量较差及重复数据很多，尽量事先使用samtools进行提前处理
```
---
## 功能一：BAM & bigwig file processing
### [multiBamSummary](http://deeptools.readthedocs.io/en/latest/content/tools/multiBamSummary.html)
### [multiBigwigSummary](http://deeptools.readthedocs.io/en/latest/content/tools/multiBigwigSummary.html)
### [correctGCbias](http://deeptools.readthedocs.io/en/latest/content/tools/correctGCBias.html)
### [bamCoverage](http://deeptools.readthedocs.io/en/latest/content/tools/bamCoverage.html)
### [bamCompare](http://deeptools.readthedocs.io/en/latest/content/tools/bamCompare.html)
### [bigwigCompare](http://deeptools.readthedocs.io/en/latest/content/tools/bigwigCompare.html)
### [computeMatrix](http://deeptools.readthedocs.io/en/latest/content/tools/computeMatrix.html)

>考虑到实际上bigwig是bam的另一种形式的存在，且函数运用和bam差不多，这里着重介绍一下bam文件的处理的几个函数：
multiBamSummary
bamCoverage
bamCompare
computeMatrix

## multiBamSummary
可以用来处理bam文件在基因组上覆盖情况，默认输出npz文件，衔接`plotCorrelation`和`plotPCA`进行作图。
有两种模式，`bins`和`BED-file`，`bins`是给定bin size在全基因组范围内进行coverage的统计，`bed-file`模式则是给定region进行coverage的统计。

```
# bin mode
multiBamSummary bins --bamfiles file1.bam file2.bam -out results.npz

# BED-file mode
multiBamSummary BED-file --BED selection.bed --bamfiles file1.bam file2.bam -out results.npz
```
**EXAMPLE**

```
deepTools2.0/bin/multiBamSummary bins \
 --bamfiles testFiles/*bam \ # using all BAM files in the folder
 --minMappingQuality 30 \
 --region 19 \ # limiting the binning of the genome to chromosome 19
 --labels H3K27me3 H3K4me1 H3K4me3 HeK9me3 input \
 -out readCounts.npz --outRawCounts readCounts.tab

head readCounts.tab
'chr'	'start'	'end'	'H3K27me3'      'H3K4me1'       'H3K4me3'       'HeK9me3'       'input'
 19 10000   20000   0.0     0.0     0.0     0.0     0.0
 19 20000   30000   0.0     0.0     0.0     0.0     0.0
 19 30000   40000   0.0     0.0     0.0     0.0     0.0
 19 40000   50000   0.0     0.0     0.0     0.0     0.0
 19 50000   60000   0.0     0.0     0.0     0.0     0.0
 19 60000   70000   1.0     1.0     0.0     0.0     1.0
 19 70000   80000   0.0     1.0     7.0     0.0     1.0
 19 80000   90000   15.0    0.0     0.0     6.0     4.0
 19 90000   100000  73.0    7.0     4.0     16.0    5.0
```
## bamCoverage
可以用来将bam file转换成bigwig file，同时可以设定`binSize`参数从而的获取不同的分辨率，在比较非一批数据的时候，还可以设定数据`normalizeTo1X`到某个值（一般是该物种基因长度）从而方便进行比较。
单纯的可以当作bigwig转换工具。

**EXAMPLE**

```
bamCoverage --bam a.bam -o a.SeqDepthNorm.bw \
    --binSize 10
    --normalizeTo1x 2150570000
    --ignoreForNormalization chrX
    --extendReads
```
## bamCompare
可以用来的处理treat组和control组的数据转换成bigwig文件，给出一个binsize内结合强度的比值（默认log2处理）。

**EXAMPLE**


```
bamCompare -b1 treatment.bam -b2 control.bam -o log2ratio.bw --normalizeTo1x 2451960000
```
## computeMatrix
该功能可以计算每个基因区域的结合得分，生成中间文件用以给plotHeatmap和plotProfiles作图。
![数据传递链](http://deeptools.readthedocs.io/en/latest/_images/computeMatrix_overview.png)

computeMatrix有两种模式，scale-regions mode和reference-point mode

![区别展示图](http://deeptools.readthedocs.io/en/latest/_images/computeMatrix_modes.png)

scale-regiuons mode简单来说会将给定bed file范围内的结合信号做一个统计（指的是一段长度），并将基因长度统一scale到设定`regionBdoyLength`的长度，加上统计基因上游和下游Xbp的信号（`beforeRegionStartLength`参数和`afterRegionStartLength`参数）

**EXAMPLE**

```
computeMatrix scale-regions -p 10 \
	-R gene19.bed geneX.bed \
	-S test1.bw test2.bw \
	-b 3000 -a 3000 \
	--regionBodyLength 5000 \	
	--skipZeros \
	-o heatmap.gz 
```
reference-point mode则是给定一个bed file，以某个点为中心开始统计信号（TSS/TES/center）。但实际上我在尝试的时候`regionBdoyLength`参数也还是可以用的，所以估计和`scale-regions`区别也不是太大，主要是作图的一点区别。

**EXAMPLE**


```
computeMatrix reference-point \ # choose the mode
       --referencePoint TSS \ # alternatives: TES, center
       -b 3000 -a 10000 \ # define the region you are interested in
       -R testFiles/genes.bed \
       -S testFiles/log2ratio_H3K4Me3_chr19.bw  \
       --skipZeros \
       -o matrix1_H3K4me3_l2r_TSS.gz \ # to be used with plotHeatmap and plotProfile
       --outFileSortedRegions regions1_H3K4me3_l2r_genes.bed
```
---
## 功能二：Tools for QC

### [plotCorrelation](http://deeptools.readthedocs.io/en/latest/content/tools/plotCorrelation.html)

### [plotPCA](http://deeptools.readthedocs.io/en/latest/content/tools/plotPCA.html)

### [plotFingerprint](http://deeptools.readthedocs.io/en/latest/content/tools/plotFingerprint.html)

### [bamPEFragmentSize](http://deeptools.readthedocs.io/en/latest/content/tools/bamPEFragmentSize.html)

### [computeGCBias](http://deeptools.readthedocs.io/en/latest/content/tools/computeGCBias.html)

### [plotCoverage](http://deeptools.readthedocs.io/en/latest/content/tools/plotCoverage.html)

>包括PCA作图，correlation作图等，都是运用`multiBamSummary`得到npz文件统计样本间的相关系数作图和PCA分析作图，没有需求故此处不做介绍。

---
## 功能三：Heatmaps and summary plots
### [plotHeatmap](http://deeptools.readthedocs.io/en/latest/content/tools/plotHeatmap.html)

### [plotProfile](http://deeptools.readthedocs.io/en/latest/content/tools/plotProfile.html)

### [plotEnrichment](http://deeptools.readthedocs.io/en/latest/content/tools/plotEnrichment.html)

## plotHeatmap
主要用来画热图（虽然没什么用）并包含聚类功能（虽然也没什么用）。	=，=
上游数据是`computeMatrix`得到的gz file
注意：作图会把之前`computeMatrix`时候提交的多个bed文件分开作图，还是很好的，如果针对单个bed file进行作图，还可以使用`kmean`参数设定clustering个数

**EXAMPLE**


```
plotHeatmap -m matrix_two_groups.gz \ #输入gz文件
     -out ExampleHeatmap2.png \ 
     --colorMap RdBu \ #指定颜色
     --whatToShow 'heatmap and colorbar' \ #指定输出geatmap和colorbar
     --zMin -3 --zMax 3 \ #指定colorbar的范围
     --kmeans 4 #设定聚类个数
```
![EXAMPLE FIGURE](http://deeptools.readthedocs.io/en/latest/_images/ExampleHeatmap2.png)


>类似于颜色，边框，legend等参数都可以调，详情请 plotHeatmap -h

## plotProfile
主要用来画密度图
上游数据是`computeMatrix`得到的gz file
注意：默认针对单个bw文件作图或者把多个bw文件画在一个图里面（`perGroup`参数），同样也可以使用`kmean`或`hclust`聚类

**EXAMPLE**


```
plotProfile -m matrix.mat.gz \
      --perGroup \
      --kmeans 2 \
      -out ExampleProfile3.png
```
![EXAMPLE FIGURE](http://deeptools.readthedocs.io/en/latest/_images/ExampleProfile3.png)


>填充方式，颜色，title，labs参数等都可以调，详情请plotProfile -h

# 结语
事实上，deeptools就是用来对单个或者多个比对好的bam文件进行信息统计并进行可视化分析的，所以包括ChIP-seq和RNA-seq及其它类型的二代测序结果都是可以借以分析的。学习结束！
