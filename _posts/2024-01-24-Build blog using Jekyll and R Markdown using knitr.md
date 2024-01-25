---
layout: post
title: Posting Rmarkdowns to your Jekyll website
subtitle: 蟠木不雕饰，且将斤斧疏。
date: 2024-01-24
author: Chevy
header-img: img/052.png
catalog: true
tags:
  - 技术学习笔记
style: plain
---

## 前言
> 最近习惯使用rmarkdown来写东西，主要好处是能够兼容图片，还可以一键推送到RPubs。

但是rmakrdown写完以后，遇到一个问题，以往使用markdown写的记录，可以很方便的转到Jekyll里面的post生成blog用于记录和分享，rmakrdown是不兼容的，但是保留脚本生成的图片其实还是我的刚需，所以就Jekyll和rmarkdown的联通做了一些搜索，予以记录。

## [方案一：Rmarkdown-posts-to-Jekyll](https://jchellmuth.com/news/jekyll/website/code/2020/01/04/Rmarkdown-posts-to-Jekyll.html)

### Option 1: Uploading a complete / allinclusive html file

这个方案很简单，就是先用rmarkdown的knitr生成一个html文件，再在html文件的开头加上一段YAML：
```r
---
layout: post
title: Your blog title
---
```

缺点：
-  事实上等于把网页插入到Jekyll新生成的网页下面，嵌套了，展示效果没有到最佳情况。

### Option 2: Uploading a markdown

还有一个方案是，用knitr把rmarkdown转为markdown，并且把生成的图片转存到Jekyll的img文件夹下。

#### 阻碍一：确保保留/沿用前面的内容。
可以通过增加以下代码实现：

```r
---
layout: post
title: Your blog title
output:
  md_document:
    variant: markdown_github
    preserve_yaml: true
---
```

#### 阻碍二：修改图片文件的链接/路径，使它们能在网站上运行。

用knitr把rmarkdown转为markdown的时候，脚本生成的图片文件会被放入一个子文件夹，markdown将包含指向这些图片的链接。
默认情况下，这些链接将无法在 `Jekyll` 网站上使用，无论它们是相对链接还是绝对链接。
此外，为每篇文章建立子文件夹会挤占你的 posts 文件夹。将图片文件夹存放在主目录下的图片文件夹中更为实用——尤其是当你想在网站其他地方使用它们时。
设置以下 knitr 选项将：
- 将 Rmarkdown 转为markdown后生成的图片存储在img文件夹中
- 让markdown中的图片链接/路径在 Github/Jekyll 网站上运行

在_post文件夹下的rmd文件可以这么设置（加入Sys.Date是为了防止图片冲突）：

```
knitr::opts_knit$set(base.dir = "../../ChevyXu.github.io/", base.url = "../")
knitr::opts_chunk$set(fig.path = paste0("img/", Sys.Date(), "-"))
```

## [方案二：blogging-with-r-markdown-and-jekyll-using-knitr/](https://brooksandrew.github.io/simpleblog/articles/blogging-with-r-markdown-and-jekyll-using-knitr/)

这位博主写了一个函数 `KnitPost()` :

- 配置 KnitPost 顶部的目录，使其与你博客的文件系统相匹配。我本可以把这些作为参数，但我想我不会经常重新架构我的博客......所以我把它们硬编码了。
- 在 rmd.path 中创建 R Markdown post 并保存为 .Rmd 文件。确保包含适合 Jekyll 的 YAML 前置内容。我最初就是被这个问题绊倒的。我忘了把日期从 knitr 风格的日期（"月，日 YYYY"）改为 Jekyll 风格的日期（"YYYY-MM-DD"）。
- 运行 `KnitPost()` 发布 R Markdown 文件

```r
KnitPost <- function(site.path='/pathToYourBlog/', overwriteAll=F, overwriteOne=NULL) {
  if(!'package:knitr' %in% search()) library('knitr')
  
  ## Blog-specific directories.  This will depend on how you organize your blog.
  site.path <- site.path # directory of jekyll blog (including trailing slash)
  rmd.path <- paste0(site.path, "_Rmd") # directory where your Rmd-files reside (relative to base)
  fig.dir <- "assets/Rfig/" # directory to save figures
  posts.path <- paste0(site.path, "_posts/articles/") # directory for converted markdown files
  cache.path <- paste0(site.path, "_cache") # necessary for plots
  
  render_jekyll(highlight = "pygments")
  opts_knit$set(base.url = '/', base.dir = site.path)
  opts_chunk$set(fig.path=fig.dir, fig.width=8.5, fig.height=5.25, dev='svg', cache=F, 
                 warning=F, message=F, cache.path=cache.path, tidy=F)   
  

  setwd(rmd.path) # setwd to base
  
  # some logic to help us avoid overwriting already existing md files
  files.rmd <- data.frame(rmd = list.files(path = rmd.path,
                                full.names = T,
                                pattern = "\\.Rmd$",
                                ignore.case = T,
                                recursive = F), stringsAsFactors=F)
  files.rmd$corresponding.md.file <- paste0(posts.path, "/", basename(gsub(pattern = "\\.Rmd$", replacement = ".md", x = files.rmd$rmd)))
  files.rmd$corresponding.md.exists <- file.exists(files.rmd$corresponding.md.file)
  
  ## determining which posts to overwrite from parameters overwriteOne & overwriteAll
  files.rmd$md.overwriteAll <- overwriteAll
  if(is.null(overwriteOne)==F) files.rmd$md.overwriteAll[grep(overwriteOne, files.rmd[,'rmd'], ignore.case=T)] <- T
  files.rmd$md.render <- F
  for (i in 1:dim(files.rmd)[1]) {
    if (files.rmd$corresponding.md.exists[i] == F) {
      files.rmd$md.render[i] <- T
    }
    if ((files.rmd$corresponding.md.exists[i] == T) && (files.rmd$md.overwriteAll[i] == T)) {
      files.rmd$md.render[i] <- T
    }
  }
  
  # For each Rmd file, render markdown (contingent on the flags set above)
  for (i in 1:dim(files.rmd)[1]) {
    if (files.rmd$md.render[i] == T) {
      out.file <- knit(as.character(files.rmd$rmd[i]), 
                      output = as.character(files.rmd$corresponding.md.file[i]),
                      envir = parent.frame(), 
                      quiet = T)
      message(paste0("KnitPost(): ", basename(files.rmd$rmd[i])))
    }     
  }
  
}
```