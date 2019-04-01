---
layout:     post
title:	Immobilized Template Assay Record
subtitle:	初春令月，气淑风和。
date:       2019-04-01
author:     Chevy
header-img: img/5-min.png
catalog: true
tags:
    - 技术学习笔记
---

## Immobilized Template Assay Record

### Introduction

在研究基因调控时，经常会需用到功能性实验去探究特定的启动子或者增强之结合蛋白的生物学功能，例如常见的GST pulldown实验，这时在体外重现转录进程是异常有用的，这里我们对Immobilized Template Assay(以下简称ITA)进行介绍。

### Keywords

`In vitro transcription`; `Chromatin reconstitution`; `Immobilized template`

### Brief introduction

ITA旨在分析反应中转录活性和转录因子的相关性的方法，分为两个部分：

- 体外转录实验：固定模板（启动子DNA序列）通过生物素 - 链霉键连接到磁珠上（图a）
- 免疫印记分析：通过WB检查特异的转录因子是否存在于PIC(pre-initiation complex)中（图b）

![Immobilized Template Assay](\_posts\Immobilized Template Assay.assets\Immobilized Template Assay.gif)

### Brief process

所以操作的话，需要分成两步，第一步是合成带有biotin的DNA序列然后和dynabeads孵育结合，第二步就是纯化目的蛋白并和第一步的DNA序列进行孵育，洗脱后通过western blot压对应的蛋白进行检测。

> **注意事项**：
>
> 需要纯化目的蛋白，合成PCR序列也需要注意。

Protocol handbook: [Immobilized Template Assay](https://link.springer.com/referencework/10.1007/978-1-4419-9863-7) 

### Step2: In vitro protein translation

> Experimental reagent：**TnT® T7 Quick Coupled Transcription/Translation System  (L1170)**
>
> Each system contains sufficient reagents to perform approximately 40 × 50μl translation reactions. Includes:
> • 1.6ml TnT® Quick Master Mix (8 × 200μl)
> • 5μg SP6 or T7 Luciferase Control DNA (0.5μg/μl)
> • 100μl T7 TnT® PCR Enhancer (L1170 only)
> • 50μl Methionine, 1mM
> • 250μl Luciferase Assay Reagent
> • 1.25ml Nuclease-Free Water

这个步骤很简单，就是构建一个表达质粒，使用试剂盒进行简单的体外表达，表达质粒可以选用SP6/T7体系的质粒：

![T7](\_posts\Immobilized Template Assay.assets\T7.PNG)

简单来说就是把你要翻译的质粒序列插入到多克隆位点区域（当然首先要切掉luciferase sequence），然后抽提出来以后就可以进行实验了。

> 当然，使用直接PCR出来的片段进行转录也是可以的，但是并不推荐。此处不赘述

#### Step2.A.1: Get DNA plasmid

对于的plasmid DNA来说，需要**注意**一下几点：

1. 抽提的质粒不能有残留的乙醇
2. 酶切产物需要被去除
3. 1ug的DNA质粒即可，更多并不能提高产出
4. 避免在翻译序列前面出现的起始密码

#### Step2.A.2: Creating a Ribonuclease-Free Environment

实验过程中注意要避免RNase的污染

#### Step2.A.3: Handling of Lysate

除了孵育那一步，所有的操作都应该在4°条件下完成。

**不要冻融master mix超过两次**

#### Step2.B.1: General Protocl

注意事项：

1. 试剂保存在-70°，拿出来以后用手捂化Master Mix后置于冰上，其余试剂于室温融化置于冰上
2. 建议包括一个阳性control的反应

![com](\_posts\Immobilized Template Assay.assets\com.PNG)

随后在30°孵育60-90分钟就可以了，产物可以使用western blot来进行验证