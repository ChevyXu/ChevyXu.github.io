---
layout: post
title: group pvalue calculation and visualization using rstatix and ggpubr
subtitle: Add color to life.
date: "2024-02-18"
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

# 1. Get example data

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.2     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.4.3     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(rstatix)
```

    ## 
    ## 载入程辑包：'rstatix'
    ## 
    ## The following object is masked from 'package:stats':
    ## 
    ##     filter

``` r
example <- 
  tibble::tibble(
  para = rnorm(n = 30, mean = 300, sd = 20) %>% round(digits = 2),
  dose = rep(rep(c("dose_1", "dose_2", "dose_3", "dose_4", "dose_5"), each = 2), 3),
  date = rep(c("date_1", "date_2", "date_3"), each = 10)) %>% 
  group_by(dose, date) %>% 
  mutate(mean = mean(para)) %>% 
  mutate(sd = sd(para)) %>% 
  mutate(cv = sd/mean)

example
```

    ## # A tibble: 30 × 6
    ## # Groups:   dose, date [15]
    ##     para dose   date    mean    sd     cv
    ##    <dbl> <chr>  <chr>  <dbl> <dbl>  <dbl>
    ##  1  250. dose_1 date_1  300. 69.9  0.233 
    ##  2  349. dose_1 date_1  300. 69.9  0.233 
    ##  3  340. dose_2 date_1  330. 13.7  0.0415
    ##  4  320. dose_2 date_1  330. 13.7  0.0415
    ##  5  308. dose_3 date_1  301.  9.44 0.0313
    ##  6  295. dose_3 date_1  301.  9.44 0.0313
    ##  7  287. dose_4 date_1  290.  3.24 0.0112
    ##  8  292. dose_4 date_1  290.  3.24 0.0112
    ##  9  260. dose_5 date_1  283. 32.1  0.113 
    ## 10  305. dose_5 date_1  283. 32.1  0.113 
    ## # ℹ 20 more rows

# Using Rstatix to calculate pvalue

``` r
stat.test <- example %>% 
  rename("value" = colnames(.)[1]) %>% 
  filter(sd != 0) %>%
  group_by(dose) %>% 
  mutate(x = n()) %>% 
  filter(x >= 4) %>% 
  t_test(value ~ date) %>% 
  filter(group1 == "date_1")

stat.test <- stat.test %>% 
    add_xy_position(x = "dose", dodge = 0.75)
```

# get the final plot

``` r
ggplot(example, aes(x = dose, y = para, color = dose, fill = dose)) +
    geom_errorbar(aes(ymin = mean, ymax=mean + sd, alph = date), width=.2,  
                  position=position_dodge(.75), linewidth = 0.5) +
    geom_point(aes(fil = date), shape = 21, size = 3, color = "gray44",
               position = position_jitterdodge(dodge.width = 0.75, jitter.width = 0)) +
    geom_bar(data = example %>% select(-1) %>% distinct(),
             aes(y = mean, fill = dose, color = dose, alpha = date), 
             stat = "identity",  width = 0.6, position = position_dodge(width = 0.75)) +
    scale_color_manual(values =  ggsci::pal_locuszoom()(5) %>% rev()) +
    scale_fill_manual(values =  ggsci::pal_locuszoom()(5) %>% rev()) +
    scale_alpha_manual(values = c(seq(1, 9, 2))*0.1) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.1)), name = "Units") +
    # scale_y_continuous(name = plot_data %>% colnames() %>% nth(n = 1) %>% str_remove(pattern = "\\|.*\\|"), 
    #                    expand = c(0, 0), limits = c(0, max(plot_data %>% pull(1))*1.1)) +
    labs(title = "t.test example") + xlab(NULL) +
    cowplot::theme_cowplot(font_size = 10, line_size = 0.8) +
    theme(axis.title = element_text(size = 20, face = "bold"), 
          axis.text = element_text(size = 15, color = "black"), 
          axis.ticks.length = unit(.2, "cm"),
          plot.title = element_text(size = 25, hjust = 0.5, face = "bold"), 
          legend.key.size = unit(0.8, "cm"),
          axis.line = element_line(colour = "black", size = 1),
          # panel.border = element_rect(size = 1, colour = "black"),
          axis.ticks = element_line(colour = "black", size = 1),
          legend.text = element_text(size = 15), 
          plot.caption = element_text(size = 12, hjust = 1.2, face = "italic"),
          legend.title = element_text(size = 15, face = "bold"),
          strip.text = element_text(face = "bold", size = 15)) +
    ggpubr::stat_pvalue_manual(stat.test, label = "p.adj.signif", tip.length = 0.01, bracket.nudge.y = 0) +
    scale_x_discrete(labels = c("dose_1" = "0 mg/kg\nMale", 
                                "dose_2" = "0.3mg/kg\nMale", 
                                "dose_3" = "3mg/kg\nMale", 
                                "dose_4" = "30mg/kg\nMale", 
                                "dose_5" = "3mg/kg\nFemale"))
```

    ## Warning in geom_errorbar(aes(ymin = mean, ymax = mean + sd, alph = date), :
    ## Ignoring unknown aesthetics: alph

    ## Warning in geom_point(aes(fil = date), shape = 21, size = 3, color = "gray44",
    ## : Ignoring unknown aesthetics: fil

    ## Warning: The `size` argument of `element_line()` is deprecated as of ggplot2 3.4.0.
    ## ℹ Please use the `linewidth` argument instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

![](/img/2024-02-18/unnamed-chunk-3-1.png)
