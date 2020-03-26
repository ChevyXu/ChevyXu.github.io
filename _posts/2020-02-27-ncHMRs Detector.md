---
layout:	post
title:	Genome Biology文章解读：组蛋白调节因子(HMRs)只负责组蛋白修饰相关功能？如何揭示HMRs的非经典功能
subtitle:	曲水池上，小字更书年月。
date:	2020-02-27
author:	Chevy
header-img:	img/16.jpg
catalog:	true
tags:
    - 技术学习笔记

---

#### [ncHMR detector: a computational framework to systematically reveal non- classical functions of histone modification regulators](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-01953-0#MOESM1) 阅读总结
---

觉得太长不看可以直接跳到[研究思路](#研究思路)部分

---

### 前言

HMRs(Histone modification regulators)为组蛋白修饰调节因子，它可以识别、添加、去除蛋白尾端的修饰（甲基化、乙酰化、磷酸化、腺苷酸化、泛素化等），一般来说HMRs会依据其功能会被认为是组蛋白修饰的readers（识别者）, writers（写入者）或者是erasers（擦除者）。

大量的研究证明了HMRs可以导致多种类型的疾病，并且部分HMRs也被证明可以成为治疗靶点，一般来说其作用重要在于对染色质状态与基因表达的调节，而以上提及的作用被认为是HMRs的经典功能(Classical functions)；同时也有文献报道HMRs可以不依赖于它们已知的组蛋白修饰底物或者产物，与一些辅因子协作行使非经典功能(Non-Classical functions)：

- PCR2复合体可以通过甲基化转移酶EZH1/2催化H3K27的二甲基或者三甲基化，但是12年[*SCIENCE*](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3625962/)上[Shirley Liu](https://www.ncbi.nlm.nih.gov/pubmed/?term=Liu XS[Author]&cauthor=true&cauthor_uid=23239736)和[Myles Brown](https://www.ncbi.nlm.nih.gov/pubmed/?term=Brown M[Author]&cauthor=true&cauthor_uid=23239736)报道了EZH2可以不依赖PCR2复合体独立的与雄激素受体(androgen receptor)结合并且激活下游基因
- SETDB1，一个组蛋白甲基化转移酶，其经典功能为催化H3K9的三甲基化，但是在[*Genome Res*](https://www.ncbi.nlm.nih.gov/pubmed/26160163)上[Shou J](https://www.ncbi.nlm.nih.gov/pubmed/?term=Shou J[Author]&cauthor=true&cauthor_uid=26160163)和 [Zhang Y](https://www.ncbi.nlm.nih.gov/pubmed/?term=Zhang Y[Author]&cauthor=true&cauthor_uid=26160163)报道了SETDB1在mESCs( mouse embryonic stem cells)中可以不依赖于H3K9me3调节PCR2复合体对发育基因的活性

![classic function](https://imgkr.cn-bj.ufileos.com/51f022b7-571e-4cdd-b081-f26e49a7804c.PNG)


> 目前对于HMRs的鉴定方法较为多样：
>
> 1. 通过链霉亲和素磁珠对蛋白进行分离，随后进行质谱分析找到非经典功能
>    - PCR1复合体（负责催化H2A的单泛素化H2Aub1）的核心单位RNF2，可以通过与KDM1A结合发挥其非经典功能[Mol Cell Proteomics](https://www.ncbi.nlm.nih.gov/pubmed/17296600#)
>    - 中等通量
> 2. 使用ChIP配合western blot找到结合蛋白，ChIP-qPCR技术进行验证下游基因
>    - H3K9me3和H3K36me3的去甲基化转移酶KDM4B，可以结合MLL复合体调节乳腺癌相关基因[Proc Natl Acad Sci U S A](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3088624/#)
>    - 低通量
> 3. 通过对ChIP-seq数据的联合分析，集中关注HMRs的结合位点同时这些位点没有底物或产物的信号
>    - ChIP-seq技术被广泛的应用于寻找转录因子(Transcription Factors)，染色质调控子(Chromatin regulators)，组蛋白修饰(Histone Modifications)在全基因组的结合位点，提供了大量的结合位点可用以定义HMRs
>    - 优点：高通量
>
> - 下图展示了以上三种鉴定方法对应的研究成果
>    ![overview](https://imgkr.cn-bj.ufileos.com/f97e7426-3126-43da-9c88-74cc8b5ce94c.PNG)


**本文的研究痛点**目前还没有针对ncHMRs的计算工具

- 一个标准的ChIP-seq数据会拥有数以千计的peaks，而这与实验的质量关系很大，通常来说实验中很难避免某些区域作用底物或者产物的信号丢失，导致会被错认为行使非经典功能的辅因子
- 公共数据库的数据质量千差万别，需要严格的自控才可以保证数据的可依赖性
- 为了利用目前公共数据库，需要一个新的计算框架去解决以上的问题

**本文的研究亮点**开发出了ncHMR detector(non-classical functions of histone modification regulator detector)，用以预测HMR的非经典功能及其互作的辅因子

- ncHMR detector有一个筛选功能，包括需要非经典功能辅因子的高密度结合与经典底物或产物的结合信号缺失这两个条件以减少假阳性的可能
- ncHMR detector使用严格的质控保证数据的可依赖性
- ncHMR detector同时可以基于[Ostu's方法](https://ieeexplore.ieee.org/document/4310076)反馈HMR的非经典功能作用的基因区域

**本文的实例论证**作者使用ncHMR detector在多个细胞系内找出了12个HMRs的非经典功能以及候选的辅因子，并对其中一个进行了实验验证

- PRC1复合体内的CBX7可以不依赖于H3K27me3而与NANOG结合调控mESC细胞的多能性

### 研究思路

1. 作者对已经报道的LNCap-abl细胞内EZH2结合位点的H3K27me3信号进行了检视（density plot），发现EZH2结合位点的H3K27me3信号明显可以看出来为双峰模式：

     ![双峰](https://imgkr.cn-bj.ufileos.com/6eb66eba-468f-4ece-9c2f-b9a8ed2a92c9.PNG)
     
     **红色**线条为全局H3K27me3信号模式，**绿色**线条为有H3K27me3信号结合的区域，**藏蓝色**线条为H3K27me3信号弱或无区域
     
2. 同时作者发现已被报道的辅因子在EZH2 peaks区域的结合信号与H3K27me3是互斥的（可以理解为上面的藏蓝色区域与绿色区域）：

   ![互斥](https://imgkr.cn-bj.ufileos.com/1f5a71eb-2c84-48b3-8d6b-74fa6397f182.PNG)

3. 以上两点构成了的设计理论基础

   - 最好有双峰模式支持HMRs的经典/非经典功能
   - 需要有辅因子的高密度结合
   - 辅因子高密度结合区域存有低或无信号的组蛋白修饰

4. ncHMR detector的工作原理包括以下四步：

   - **第一步**，对特定的HMR统计其底物或者产物peaks前后5kb或者1kb（根据信号类型有差别）的信号值，同时统计这些peaks区域是否有其他转录因子的结合（一般来源于公共数据库，或者实验室数据）

      ![第一步](https://imgkr.cn-bj.ufileos.com/d246c94f-b6ee-4795-ae9a-ad286634068d.png)

   - **第二步**，使用penalized linear regression找出与底物或者产物信号值负相关的转录因子数据，作为初步候选辅因子

     ​	 			![第二步](https://imgkr.cn-bj.ufileos.com/84d99a22-96c8-41af-ad93-a0a19b0af054.png)


   - **第三步**，经过筛选的转录因子数据再使用单变量线性回归的方法拟合其与组蛋白修饰信号共发生的模型，留下回归系数小于零（负相关），决定系数大于等于0.1的转录因子作为可以认为是HMRs非经典作用的辅因子

     ​					![第三步](https://imgkr.cn-bj.ufileos.com/8014b09f-b7e8-4beb-b470-855533d49bd5.png)


   - **第四步**，为了反馈预测的非经典功能的作用基因位点，HMR的peaks被封为经典和非经典两类进行输出

     ​					![第四步](https://imgkr.cn-bj.ufileos.com/e5efc951-66ec-442d-aedb-644da8e98e72.png)


5. 作者针对ncHMR detector寻找辅因子较高的特异性和准确性进行了计算论证，并同已有的一些算法进行了比较（此处略去计算方面的讲解），说明了ncHMR detector的优越性

6. 作者收集了公共数据库的data使用ncHMR detector进行了HMRs非经典功能的寻找，展示了排名前列的数据：

   ![统计结果](https://imgkr.cn-bj.ufileos.com/82107147-7e29-430a-a3c2-013c8afd86e4.png)


   我们可以发现其中**EZH2**就在human cell line中被报道与E2F1存在非经典功能互作，作者的预测结果还揭示了**EZH2**在mouse ESC细胞中可能同样存在相同的非经典功能互作（通过human和mouse非经典结合位点的联合分析，作者还推测**EZH2**的非经典功能是物种保守的，行使相似的功能）。

   ![EZH2](https://imgkr.cn-bj.ufileos.com/1238716f-3172-4b0d-8997-61e12b46cac7.png)


   同时使用RNF2的mESC数据作者也成功的找出了被报道过的MED12的踪迹，也发现RNF2极有可能存在多种辅因子互作的可能（MED12和KDM1A的peak在非经典功能区域高度重合）

   ![RNF2](https://imgkr.cn-bj.ufileos.com/aa855d3b-5f05-4e15-8bfd-d885f83c76a2.png)


7. 作者对预测结果排名第一的HMR(CBX7)与其非经典功能辅因子NANOG进行了实验验证

   - CBX7是PCR1复合物的组成部分，可以识别H3K27me3和H3K9me3修饰

   - 在mESC中，CBX7的peaks中NANOG的结合信号与H3K27me3和H3K9me3修饰信号负相关

   - CBX7的peaks中NANOG的结合信号远离promoter并且与H3K27ac修饰重合（解释为非经典功能为通过enhancer的形式增强基因表达），而CBX7与H3K27me3和H3K9me3修饰信号重合大多在promoter区域，说明了CBX7的classical function和non-classical function的区别

   - CBX7的敲除实验说明了CBX7和NANOG的结合，并且论证了CBX7和NANOG的结合在*Nanog*基因上游远端形成增强子(enhancer)促进了mESC的多能行，这就是CBX7的非经典功能，且并不依赖与它的经典功能

     ![](https://imgkr.cn-bj.ufileos.com/6ee326a7-40a4-429e-b184-94525c249526.png)
     ![](https://imgkr.cn-bj.ufileos.com/f56d90f0-825a-4fed-8605-ce504f54871d.png)



### 总结

> 作者开发的工具已经[开源](https://github.com/TongjiZhanglab/ncHMR_detector)并且提供了一些已经处理好的数据（基于细胞系分类）：
>
> - K562 peak files (hg38) [Dropbox](https://www.dropbox.com/s/2l2ltsz77kfxzgr/K562_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/GM12878_peaks.tar.gz)
> - GM12878 peak files (hg38) [Dropbox](https://www.dropbox.com/s/h3mtjxeauq6bfmw/GM12878_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/GM12878_peaks.tar.gz)
> - HepG2 peak files (hg38) [Dropbox](https://www.dropbox.com/s/hpxcovw4m00sldf/HepG2_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/HepG2_peaks.tar.gz)
> - Hela peak files (hg38) [Dropbox](https://www.dropbox.com/s/rj7vjvl36sdg0pd/HeLa_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/HeLa_peaks.tar.gz)
> - human ESC peak files (hg38) [Dropbox](https://www.dropbox.com/s/p2whnzpdpvmccdq/hESC_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/hESC_peaks.tar.gz)
> - mouse ESC peak files (mm10) [Dropbox](https://www.dropbox.com/s/uc2hz9zpzl52t9k/mESC_peaks.tar.gz?dl=0) [TongjiServer](http://compbio-zhanglab.org/release/mESC_peaks.tar.gz)


### 一句话归纳

该文章给了我们认识HMR的新角度，并且可以利用该作者开发的ncHMR detectors去进行我们的data mining