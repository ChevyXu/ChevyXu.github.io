---
layout: post
title: group pvalue calculation and visualization using rstatix and ggpubr
subtitle: Add color to life.
date: "2024-02-19"
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
    ##  1  269. dose_1 date_1  277. 11.3  0.0409
    ##  2  285. dose_1 date_1  277. 11.3  0.0409
    ##  3  366. dose_2 date_1  339. 38.9  0.115 
    ##  4  311. dose_2 date_1  339. 38.9  0.115 
    ##  5  250. dose_3 date_1  299. 69.5  0.232 
    ##  6  349. dose_3 date_1  299. 69.5  0.232 
    ##  7  302. dose_4 date_1  295.  9.13 0.0309
    ##  8  289. dose_4 date_1  295.  9.13 0.0309
    ##  9  300. dose_5 date_1  308. 11.7  0.0380
    ## 10  317. dose_5 date_1  308. 11.7  0.0380
    ## # ℹ 20 more rows

``` r
# Using Rstatix to calculate pvalue
stat.test <- example %>% 
  rename("value" = colnames(.)[1]) %>% 
  filter(sd != 0) %>%
  group_by(dose) %>% 
  mutate(x = n()) %>% 
  filter(x >= 4) %>% 
  t_test(value ~ date) %>% 
  filter(group1 == "date_1")

stat.test
```

    ## # A tibble: 10 × 11
    ##    dose   .y.   group1 group2    n1    n2 statistic    df     p p.adj
    ##    <chr>  <chr> <chr>  <chr>  <int> <int>     <dbl> <dbl> <dbl> <dbl>
    ##  1 dose_1 value date_1 date_2     2     2     0.726  1.42 0.569 1    
    ##  2 dose_1 value date_1 date_3     2     2    -0.594  1.38 0.635 1    
    ##  3 dose_2 value date_1 date_2     2     2     1.17   1.03 0.446 0.892
    ##  4 dose_2 value date_1 date_3     2     2     0.401  1.20 0.748 0.892
    ##  5 dose_3 value date_1 date_2     2     2     0.227  1.19 0.853 1    
    ##  6 dose_3 value date_1 date_3     2     2    -0.157  1.00 0.901 1    
    ##  7 dose_4 value date_1 date_2     2     2    -4.41   1.97 0.049 0.148
    ##  8 dose_4 value date_1 date_3     2     2    -0.729  1.08 0.591 1    
    ##  9 dose_5 value date_1 date_2     2     2    -0.220  1.50 0.852 1    
    ## 10 dose_5 value date_1 date_3     2     2    -0.473  1.39 0.7   1    
    ## # ℹ 1 more variable: p.adj.signif <chr>

``` r
# adjust lable position based on dodge width
stat.test <- stat.test %>% 
    add_xy_position(x = "dose", dodge = 0.75)

stat.test
```

    ## # A tibble: 10 × 16
    ##    dose   .y.   group1 group2    n1    n2 statistic    df     p p.adj
    ##    <chr>  <chr> <chr>  <chr>  <int> <int>     <dbl> <dbl> <dbl> <dbl>
    ##  1 dose_1 value date_1 date_2     2     2     0.726  1.42 0.569 1    
    ##  2 dose_1 value date_1 date_3     2     2    -0.594  1.38 0.635 1    
    ##  3 dose_2 value date_1 date_2     2     2     1.17   1.03 0.446 0.892
    ##  4 dose_2 value date_1 date_3     2     2     0.401  1.20 0.748 0.892
    ##  5 dose_3 value date_1 date_2     2     2     0.227  1.19 0.853 1    
    ##  6 dose_3 value date_1 date_3     2     2    -0.157  1.00 0.901 1    
    ##  7 dose_4 value date_1 date_2     2     2    -4.41   1.97 0.049 0.148
    ##  8 dose_4 value date_1 date_3     2     2    -0.729  1.08 0.591 1    
    ##  9 dose_5 value date_1 date_2     2     2    -0.220  1.50 0.852 1    
    ## 10 dose_5 value date_1 date_3     2     2    -0.473  1.39 0.7   1    
    ## # ℹ 6 more variables: p.adj.signif <chr>, y.position <dbl>,
    ## #   groups <named list>, x <dbl>, xmin <dbl>, xmax <dbl>

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

![](/img/2024-02-19/unnamed-chunk-4-1.png)

## Reference

<https://www.datanovia.com/en/blog/how-to-add-p-values-onto-a-grouped-ggplot-using-the-ggpubr-r-package/>
