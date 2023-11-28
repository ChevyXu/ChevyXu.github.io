---
layout: post
title: Rstatix calculate correlation R2 and slope
subtitle: 君子欲讷于言而敏于行。
date: 2023-11-28
author: Chevy
header-img: img/52.png
catalog: true
tags:
  - 技术学习笔记
style: plain

---


# 测试在R里面，使用tidyverse搭配rstatix更简便的做计算，例如t.test()/cor()


```
library(tidyverse)
library(rstatix)

iris %>%
  group_by(Species) %>%
  cor_test(Sepal.Width, Sepal.Length, method = "pearson")

bdims_summary <- iris %>%
  group_by(Species) %>%
  summarize(N = n(), r = cor(Sepal.Width, Sepal.Length),
            mean_hgt = mean(Sepal.Width), 
            mean_wgt = mean(Sepal.Length),
            sd_hgt = sd(Sepal.Width), 
            sd_wgt = sd(Sepal.Length),
            slope = r*(sd_wgt/sd_hgt),
            intercept = mean_wgt - (slope*mean_hgt),
            r2 = r*r)

bdims_summary
```

## 作图

```
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~Species) +
  ggpubr::stat_cor(aes(label = paste(after_stat(rr.label), p.label, sep = "~ `,`~")), color = "brown", label.y.npc = 1) +
  ggpubr::stat_regline_equation(color = "brown", label.y.npc = 0.95)
```
  