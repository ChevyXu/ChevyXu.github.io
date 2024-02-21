---
layout: post
title: Create your R package
subtitle: (Connect Rstudio to Github and push project to Github)
date: "2024-02-21"
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

# 1. Use Rstudio to create a new project for package

[Reference:R Package
Development](https://www.youtube.com/watch?v=79s3z0gIuFU&ab_channel=JohnMuschelli)
\> Start from a brand new environment.

# 2. Connecting Rstudio to Github

[Reference:how-to-use-git-github-with-r](https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r)

``` r
# 1. create token from github
usethis::create_github_token()

# 2. set token to Rstudio, paste the PAT to Rstudio window
# gitcreds::gitcreds_set()
credentials::set_github_pat()

# 3. create repo based on local repo and push to github
usethis::use_github()

# 4. create a vignette
usethis::use_vignette(name = "chunhui_vignette", title = "This is a vignette")
```
