---
layout: post
title: cellranger 6.1.1使用教程
subtitle: 涓涓不塞，将为江河。
date: 2021-09-03
author: Chevy
header-img: img/46.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

# cellranger 6.1.1使用教程

> 本教程更新时间为2021-09-03
>
> 涉及Linux和R使用



## 1. cellranger 6.1.1 下载

cellranger已经预编译好了CentOS/Redhat 6.0+和Ubuntu的二进制文件。

```shell
$ curl -o cellranger-6.1.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1630508728&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzA1MDg3Mjh9fX1dfQ__&Signature=T0LF3fV9f31GeBlRc05c60kHDjZ33IVUKVsHphn8rWDcIDVf5IGgaqLGhF3q2vHrpY94SrX6UKT9yrcRti96ZNnBYKGC0VEMP~Vf-Lv4VLMZIs72gHQkwvevcaXRLm11b4SgqLX4BwpObuBQFhwkZNrpDSURybjhlgKxPH9cpujXa~KTdAL8IpgSnMyqHQseHWM4AbnYFznxgjfwaeR-Pn0I-q1awwN8tNLzzb~CCfy0-uz~QEiDmcn8XWfqXzmkMIlPSJD~9j70Al8hW1en91t0olXdYGAN2auhj9qKrnvj-r8aTjJx72-3w-O1hayyUcU17uyEjR6BAzkLDJ-EuQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
```

```shell
$ wget -O cellranger-6.1.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1630508728&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzA1MDg3Mjh9fX1dfQ__&Signature=T0LF3fV9f31GeBlRc05c60kHDjZ33IVUKVsHphn8rWDcIDVf5IGgaqLGhF3q2vHrpY94SrX6UKT9yrcRti96ZNnBYKGC0VEMP~Vf-Lv4VLMZIs72gHQkwvevcaXRLm11b4SgqLX4BwpObuBQFhwkZNrpDSURybjhlgKxPH9cpujXa~KTdAL8IpgSnMyqHQseHWM4AbnYFznxgjfwaeR-Pn0I-q1awwN8tNLzzb~CCfy0-uz~QEiDmcn8XWfqXzmkMIlPSJD~9j70Al8hW1en91t0olXdYGAN2auhj9qKrnvj-r8aTjJx72-3w-O1hayyUcU17uyEjR6BAzkLDJ-EuQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
```

```shell
# 下载还是很快的
cellranger-6.1.1.tar.gz                     100%[=========================================================================================>]   1.05G  2.64MB/s    in 5m 36s

2021-09-01 11:11:38 (3.21 MB/s) - ‘cellranger-6.1.1.tar.gz’ saved [1130164510/1130164510]

# 解压
$ tar zxvf cellranger-6.1.1.tar.gz  

# 解压后在当前文件夹下运行./cellranger，应该会出现manual信息，说明可使用
# 如果经常使用，可以添加进$PATH
$ ./cellranger
cellranger cellranger-6.1.1
Process 10x Genomics Gene Expression, Feature Barcode, and Immune Profiling data

USAGE:
    cellranger <SUBCOMMAND>

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    count               Count gene expression (targeted or whole-transcriptome) and/or feature barcode reads from a single sample and GEM well
    multi               Analyze multiplexed data or combined gene expression/immune profiling/feature barcode data
    vdj                 Assembles single-cell VDJ receptor sequences from 10x Immune Profiling libraries
    aggr                Aggregate data from multiple Cell Ranger runs
    reanalyze           Re-run secondary analysis (dimensionality reduction, clustering, etc)
    targeted-compare    Analyze targeted enrichment performance by comparing a targeted sample to its cognate parent WTA sample (used as input for targeted gene
                        expression)
    targeted-depth      Estimate targeted read depth values (mean reads per cell) for a specified input parent WTA sample and a target panel CSV file
    mkvdjref            Prepare a reference for use with CellRanger VDJ
    mkfastq             Run Illumina demultiplexer on sample sheets that contain 10x-specific sample index sets
    testrun             Execute the 'count' pipeline on a small test dataset
    mat2csv             Convert a gene count matrix to CSV format
    mkref               Prepare a reference for use with 10x analysis software. Requires a GTF and FASTA
    mkgtf               Filter a GTF file by attribute prior to creating a 10x reference
    upload              Upload analysis logs to 10x Genomics support
    sitecheck           Collect linux system configuration information
    help                Prints this message or the help of the given subcommand(s)
```

## 2. cellranger测试运行

```shell
# 运行下面的代码如果成功就说明安装没有问题了
$ ./cellranger testrun --id=tiny

# 输出信息
Martian Runtime - v4.0.6
Serving UI at http://cas399.pi.sjtu.edu.cn:44270?auth=fGo6T9Q3ncr9ebZUBCzgGpqmsWD8UUe7hWhKF5C8LKo

Running preflight checks (please wait)...
Checking sample info...
Checking FASTQ folder...
Checking reference...
Checking reference_path (/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/cellranger-6.1.1/external/cellranger_tiny_ref/3.0.0) on cas399.pi.sjtu.edu.cn...
Checking optional arguments...
mrc: v4.0.6

mrp: v4.0.6

Anaconda: Python 3.8.2

numpy: 1.19.2

scipy: 1.6.2

pysam: 0.16.0.1

h5py: 3.2.1

pandas: 1.2.4

STAR: 2.7.2a

samtools: samtools 1.10
Using htslib 1.10.2
Copyright (C) 2019 Genome Research Ltd.
...
...
...
...
...
...
...
...
...
...
Waiting 6 seconds for UI to do final refresh.
Pipestance completed successfully!

2021-09-01 22:16:57 Shutting down.
```



## 3. 参考基因组下载

```shell
$ wget https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38-2020-A.tar.gz
```

下载后解压，其中包括了基因组文件，注释文件和STAR的index文件：

```shell
.
├── refdata-gex-GRCh38-2020-A
│   ├── fasta
│   │   ├── genome.fa
│   │   └── genome.fa.fai
│   ├── genes
│   │   └── genes.gtf
│   ├── pickle
│   │   └── genes.pickle
│   ├── reference.json
│   └── star
│       ├── chrLength.txt
│       ├── chrNameLength.txt
│       ├── chrName.txt
│       ├── chrStart.txt
│       ├── exonGeTrInfo.tab
│       ├── exonInfo.tab
│       ├── geneInfo.tab
│       ├── Genome
│       ├── genomeParameters.txt
│       ├── SA
│       ├── SAindex
│       ├── sjdbInfo.txt
│       ├── sjdbList.fromGTF.out.tab
│       ├── sjdbList.out.tab
│       └── transcriptInfo.tab
├── sequence.fasta
├── sequence.gff3
└── sequence.gtf
```

其中的sequence文件是我自定义的用户文件，用来给参考基因组增加我们自定义的基因和注释。

```shell
# 构建加入自定义基因的genome.fa
$ cp  refdata-gex-GRCh38-2020-A/fasta/genome.fa ./
$ cat sequence.fasta >> genome.fa

# 构建加入自定义基因的genes.gtf
$ cp refdata-gex-GRCh38-2020-A/genes/genes.gtf ./
# ../cellranger-6.1.1/cellranger mkgtf sequence.id.gtf sequence.filtered.gtf  --attribute=gene_biotype:protein_coding
$ cat sequence.gtf | grep -v 'HHV4_LMP-2A' | grep -v 'HHV4_LMP-2B' | grep 'gene_id' > sequence.filtered.gtf
$ cat sequence.filtered.gtf >> genes.gtf
```



## 3. cellranger mkref 命令

```shell
$ ../cellranger-6.1.1/cellranger mkref --genome=EBV_output_genome --fasta=genome.fa --genes=genes.gtf
```

运行信息如下：

```shell
['/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/cellranger-6.1.1/bin/rna/mkref', '--genome=EBV_output_genome', '--fasta=genome.fa', '--genes=genes.gtf']
Creating new reference folder at /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/reference_cellranger/EBV_output_genome
...done

Writing genome FASTA file into reference folder...
...done

Indexing genome FASTA file...
...done

Writing genes GTF file into reference folder...
...done

Generating STAR genome index (may take over 8 core hours for a 3Gb genome)...
Sep 01 16:55:21 ..... started STAR run
Sep 01 16:55:21 ... starting to generate Genome files
Sep 01 16:56:28 ... starting to sort Suffix Array. This may take a long time...
Sep 01 16:56:34 ... sorting Suffix Array chunks and saving them to disk...
Sep 01 17:42:43 ... loading chunks from disk, packing SA...
Sep 01 17:43:28 ... finished generating suffix array
Sep 01 17:43:28 ... generating Suffix Array index
Sep 01 17:45:22 ... completed Suffix Array index
Sep 01 17:45:23 ..... processing annotations GTF
Sep 01 17:45:50 ..... inserting junctions into the genome indices
Sep 01 17:53:31 ... writing Genome to disk ...
Sep 01 17:53:51 ... writing Suffix Array to disk ...
Sep 01 17:54:14 ... writing SAindex to disk
Sep 01 17:54:20 ..... finished successfully
...done.

Writing genome metadata JSON file into reference folder...
Computing hash of genome FASTA file...
...done

Computing hash of genes GTF file...
...done

...done

>>> Reference successfully created! <<<

You can now specify this reference on the command line:
cellranger --transcriptome=/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/reference_cellranger/EBV_output_genome ...
```

其reference文件夹结构如下：

```shell
.
├── fasta
│   ├── genome.fa
│   └── genome.fa.fai
├── genes
│   └── genes.gtf.gz
├── reference.json
└── star
    ├── chrLength.txt
    ├── chrNameLength.txt
    ├── chrName.txt
    ├── chrStart.txt
    ├── exonGeTrInfo.tab
    ├── exonInfo.tab
    ├── geneInfo.tab
    ├── Genome
    ├── genomeParameters.txt
    ├── SA
    ├── SAindex
    ├── sjdbInfo.txt
    ├── sjdbList.fromGTF.out.tab
    ├── sjdbList.out.tab
    └── transcriptInfo.tab

3 directories, 19 files
```



## 4. 下载数据和运行cellranger

```shell
# 可以使用sunselector进行下载
# https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP224614&o=acc_s%3Aa
```

```shell
# 更改文件名符合cellranger格式
$ mv SRR10238682_1.fastq.gz SRR10238682_S1_L001_R1_001.fastq.gz
$ mv SRR10238682_2.fastq.gz SRR10238682_S1_L001_R2_001.fastq.gz
```

```shell
# 开始使用cellranger count提取数据
$ ../cellranger-6.1.1/cellranger count --id=SRR10238682 --transcriptome=/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/reference_cellranger/EBV_output_genome --fastqs=/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs --sample=SRR10238682 --expect-cells=10000 --localcores=8 --localmem=64
```

**运行信息如下：**

```shell
../cellranger-6.1.1/cellranger count --id=SRR10238682 --transcriptome=/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/reference_cellranger/EBV_output_genome --fastqs=/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs --sample=SRR10238682 --expect-cells=10000 --localcores=8 --localmem=64
Martian Runtime - v4.0.6
2021-09-02 10:08:35 [jobmngr] WARNING: User-supplied amount 64 GB is higher than the detected cgroup memory limit of 18.4 GB
Serving UI at http://cas411.pi.sjtu.edu.cn:41546?auth=V7D2bRiSDsgDnRtRzqA2uQZbIRAkHQSX7NF1oO3dZcs

Running preflight checks (please wait)...
Checking sample info...
Checking FASTQ folder...
Checking reference...
Checking reference_path (/lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/reference_cellranger/EBV_output_genome) on cas411.pi.sjtu.edu.cn...
Checking optional arguments...
mrc: v4.0.6

mrp: v4.0.6

Anaconda: Python 3.8.2

numpy: 1.19.2

scipy: 1.6.2

pysam: 0.16.0.1

h5py: 3.2.1

pandas: 1.2.4

STAR: 2.7.2a

samtools: samtools 1.10
Using htslib 1.10.2
Copyright (C) 2019 Genome Research Ltd.
...
...
...
...
...
...
Outputs:
- Run summary HTML:                         /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/web_summary.html
- Run summary CSV:                          /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/metrics_summary.csv
- BAM:                                      /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/possorted_genome_bam.bam
- BAM index:                                /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/possorted_genome_bam.bam.bai
- Filtered feature-barcode matrices MEX:    /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/filtered_feature_bc_matrix
- Filtered feature-barcode matrices HDF5:   /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/filtered_feature_bc_matrix.h5
- Unfiltered feature-barcode matrices MEX:  /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/raw_feature_bc_matrix
- Unfiltered feature-barcode matrices HDF5: /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/raw_feature_bc_matrix.h5
- Secondary analysis output CSV:            /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/analysis
- Per-molecule read information:            /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/molecule_info.h5
- CRISPR-specific analysis:                 null
- CSP-specific analysis:                    null
- Loupe Browser file:                       /lustre/home/acct-clssxj/clssxj-xch/scRNAseq_NN/cellranger/runs/SRR10238682/outs/cloupe.cloupe
- Feature Reference:                        null
- Target Panel File:                        null
- Probe Set File:                           null

Waiting 6 seconds for UI to do final refresh.
Pipestance completed successfully!
```

## 5. 查看数据结果

所有的结果都存放在out文件夹下，点击web_summary.html可以查看数据的overview

下载GEO页面提供的原始counts数据[GSM4110026_HLH_T1_counts.txt.gz](https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSM4110026&amp;format=file&amp;file=GSM4110026%5FHLH%5FT1%5Fcounts%2Etxt%2Egz)

```shell
# 整合数据到csv文件
$ ~/scRNAseq_NN/cellranger/cellranger-6.1.1/cellranger mat2csv ./filtered_feature_bc_matrix SRR10238682.csv

    WARNING: this matrix has 36696 x 863 (31668648 total) elements, 96.352373% of which are zero.
    Converting it to dense CSV format may be very slow and memory intensive.
    Moreover, other programs (e.g. Excel) may be unable to load it due to its size.
    To cancel this command, press <control key> + C.

    If you need to inspect the data, we recommend using Loupe Browser.
```

然后在R语言里面随机提取数据进行横向比对：

```R
data_old <- read.table("GSM4110026_HLH_T1_counts.txt")
dim(data_old)

data_new <- read.csv("outs/SRR10238682.csv", row.names = 1)
dim(data_new)

MALAT1_new <- data_new["ENSG00000251562",][5:10]
colnames(MALAT1_new) <- unlist(strsplit(names(MALAT1_new), split = ".1", fixed = T))
t(MALAT1_new)

MALAT1_old <- data_old["MALAT1", paste0("PP1_", unlist(strsplit(names(MALAT1_new), split = ".1", fixed = T)))]
colnames(MALAT1_old) <- matrix(unlist(strsplit(names(MALAT1_old), split = "PP1_", fixed = T)), byrow = T, ncol = 2)[, 2]
t(MALAT1_old)
```

输出结果如下：

```R
> dim(data_old)
[1] 12669   841

> dim(data_new)
[1] 36696   863

> t(MALAT1_new)
                 ENSG00000251562
AAACGGGTCAGCCTAA             374
AAACGGGTCCGCATAA             239
AAAGATGAGCTCCTTC              83
AAAGTAGAGACCGGAT             206
AAAGTAGAGTCCCACG             379
AAATGCCTCACATACG             359

> t(MALAT1_old)
                 MALAT1
AAACGGGTCAGCCTAA    374
AAACGGGTCCGCATAA    238
AAAGATGAGCTCCTTC     83
AAAGTAGAGACCGGAT    204
AAAGTAGAGTCCCACG    378
AAATGCCTCACATACG    357
```

**最后得出结论，我们提取的数据没有问题。**



## 6. 检查我们加入基因的表达

```R
library(tidyverse)
t(data_new) %>% as.data.frame() %>% select(starts_with("gene")) %>% colSums() %>% as.data.frame()
```

输出结果为：

```R
> t(data_new) %>% as.data.frame() %>% select(starts_with("gene")) %>% colSums() %>% as.data.frame(col.names = "number")
                          .
gene-HHV4_BNRF1           0
gene-HHV4_BCRF1.1         0
gene-HHV4_EBNA-2          0
gene-HHV4_EBNA-3A         0
gene-HHV4_EBNA-3B/EBNA-3C 0
gene-HHV4_EBNA-1.1        0
gene-HHV4_BWRF1.1         0
gene-HHV4_EBNA-LP         0
gene-HHV4_BWRF1.2         0
gene-HHV4_BWRF1.3         0
gene-HHV4_BWRF1.4         0
gene-HHV4_BWRF1.5         0
gene-HHV4_BWRF1.6         0
gene-HHV4_BWRF1.7         0
gene-HHV4_BWRF1.8         0
gene-HHV4_BHLF1           0
gene-HHV4_BHRF1           0
gene-HHV4_BFLF2           0
gene-HHV4_BFLF1           0
gene-HHV4_BFRF1A          0
gene-HHV4_BFRF1           0
gene-HHV4_BFRF2           0
gene-HHV4_BFRF3           0
gene-HHV4_BPLF1           0
gene-HHV4_EBNA-1.2        0
gene-HHV4_BOLF1           0
gene-HHV4_BORF1           0
gene-HHV4_BORF2           0
gene-HHV4_BaRF1.1         0
gene-HHV4_BMRF1           0
gene-HHV4_BMRF2           0
gene-HHV4_BSLF2/BMLF1     0
gene-HHV4_BSLF1           0
gene-HHV4_BSRF1           0
gene-HHV4_BLLF3           0
gene-HHV4_BLRF1           0
gene-HHV4_BLRF2           0
gene-HHV4_BLLF1           0
gene-HHV4_BLLF2           0
gene-HHV4_BZLF2           0
gene-HHV4_BZLF1           0
gene-HHV4_BRLF1           0
gene-HHV4_BRRF1           0
gene-HHV4_BRRF2           0
gene-HHV4_BKRF2           0
gene-HHV4_BKRF3           0
gene-HHV4_BKRF4           0
gene-HHV4_BBLF4           0
gene-HHV4_BBRF1           0
gene-HHV4_BBRF2           0
gene-HHV4_BBLF2/BBLF3     0
gene-HHV4_BBRF3           0
gene-HHV4_BBLF1           0
gene-HHV4_BGLF5           0
gene-HHV4_BGLF4           0
gene-HHV4_BGLF3.5         0
gene-HHV4_BGLF3           0
gene-HHV4_BGRF1/BDRF1     0
gene-HHV4_BGLF2           0
gene-HHV4_BGLF1           0
gene-HHV4_BDLF4           0
gene-HHV4_BDLF3.5         0
gene-HHV4_BDLF3           0
gene-HHV4_BDLF2           0
gene-HHV4_BDLF1           0
gene-HHV4_BcLF1           0
gene-HHV4_BcRF1.2         0
gene-HHV4_BTRF1           0
gene-HHV4_BXLF2           0
gene-HHV4_BXLF1           0
gene-HHV4_BXRF1           0
gene-HHV4_BVRF1           0
gene-HHV4_BVLF1           0
gene-HHV4_BVRF2           0
gene-HHV4_BdRF1           0
gene-HHV4_BILF2           0
gene-HHV4_RPMS1           0
gene-HHV4_LF3             0
gene-HHV4_LF2             0
gene-HHV4_LF1             0
gene-HHV4_BILF1           0
gene-HHV4_BALF5           0
gene-HHV4_A73             0
gene-HHV4_BALF4           0
gene-HHV4_BALF3           0
gene-HHV4_BARF0           0
gene-HHV4_BALF2           0
gene-HHV4_BALF1           0
gene-HHV4_BARF1.2         0
gene-HHV4_LMP-1           0
gene-HHV4_BNLF2b          0
gene-HHV4_BNLF2a          0
```

**结论：该数据未有自定义基因表达**

## 6. 常见问题

- STAR要求较多的计算资源，所以如果资源不够的话任务会被终端
- 分析时，未能自动识别3'还是5'建库，需要添加--Chemistryc参数
- 采用低版本(3.0以下)的cellranger可能无法识别新版本建库
- 参考基因组用错
