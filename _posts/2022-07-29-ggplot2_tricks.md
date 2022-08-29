---
layout: post
title: ggplot2 tricks
subtitle: 博学之，审问之，慎思之，明辨之，笃行之。
date: 2022-07-29
author: Chevy
header-img: img/055.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## ggplot2 tricks 1

### How to remove black border around plots/graphics in ggplot2?

针对`theme_clean()`这个主题我们都会遇到这个问题，画出来的图都会带一个黑框。可以在`theme()`函数里面进行解决。

```shell
library(ggplot2)
library(ggthemes)
data(mtcars)
ggplot(mtcars, aes(x = mpg)) +
  geom_point(aes(y = hp)) +
  theme_clean() +
  theme(plot.background = element_rect(
    color = "white"
  ))
```

---

## ggplot2 tricks 2

### How to save multiple plots to a PDF in R

You can use the following basic syntax :

```shell
#specify path to save PDF to
destination = 'C:\\Users\\Bob\\Documents\\my_plots.pdf'

#open PDF
pdf(file=destination)

#specify to save plots in 2x2 grid
par(mfrow = c(2,2))

#save plots to PDF
for (i in 1:4) {   
  x=rnorm(i)  
  y=rnorm(i)  
  plot(x, y)   
}

#turn off PDF plotting
dev.off() 
```

The following examples show how to use this syntax in practice.

### **Example 1: Save Multiple Plots to Same Page in PDF**

The following code shows how to save several plots to the same page in a PDF:

```shell
#specify path to save PDF to
destination = 'C:\\Users\\Bob\\Documents\\my_plots.pdf'

#open PDF
pdf(file=destination)

#specify to save plots in 2x2 grid
par(mfrow = c(2,2))

#save plots to PDF
for (i in 1:4) {   
  x=rnorm(i)  
  y=rnorm(i)  
  plot(x, y)   
}

#turn off PDF plotting
dev.off() 
```

Once I navigate to the PDF in the specified location on my computer, I find the following one-page PDF with four plots on it:

![img](https://www.statology.org/wp-content/uploads/2021/07/pdfsave1.png)

### **Example 2: Save Multiple Plots to Different Pages in PDF**

To save multiple plots to different pages in a PDF, I can simply remove the **par()** function:

```shell
#specify path to save PDF to
destination = 'C:\\Users\\Bob\\Documents\\my_plots.pdf'

#open PDF
pdf(file=destination)

#save plots to PDF
for (i in 1:4) {   
  x=rnorm(i)  
  y=rnorm(i)  
  plot(x, y)   
}

#turn off PDF plotting
dev.off() 
```

Once I navigate to the PDF in the specified location on my computer, I find the a four-page PDF with one plot on each page.

### **Additional Resources**

[How to Use the par() Function in R](https://www.statology.org/par-function-in-r/)
[How to Overlay Plots in R](https://www.statology.org/r-overlay-plots/)
