> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [blog.csdn.net](https://blog.csdn.net/qq_43659183/article/details/133697542)

中小型文件 - 使用 gdown
----------------

安装 gdown

```
pip install gdown

```

获取 Google drive 文件（不能是[文件夹](https://so.csdn.net/so/search?q=%E6%96%87%E4%BB%B6%E5%A4%B9&spm=1001.2101.3001.7020)）的`ID`  
![](https://i-blog.csdnimg.cn/blog_migrate/188a7a0094a91cb258eb301f2085c296.png)  
[复制到](https://so.csdn.net/so/search?q=%E5%A4%8D%E5%88%B6%E5%88%B0&spm=1001.2101.3001.7020)的链接大概长下面这个样子，其中加粗的部分就是文件的`ID`  
https://drive.google.com/file/d/**12LhpGHvGu4wIgXrONspNKqfGFpTfr0-p**/view?usp=drive_link

在 Python 中运行（注意下面的`url`和上面的不太一样）

```
>>> import gdown
>>> url = 'https://drive.google.com/uc?id=12LhpGHvGu4wIgXrONspNKqfGFpTfr0-p'
>>> output = 'file_name.txt'
>>> gdown.download(url, output, quiet=False)

```

这个方法对中小型文件可行，但对过大的文件（以上图中 40GB 的文件为例，文件`ID`是`1CDuzEbjK1hPbMItoJwrLIMgK25FSRM6_`），会报下面的错

```
Access denied with the following error:

        Too many users have viewed or downloaded this file recently. Please
        try accessing the file again later. If the file you are trying to
        access is particularly large or is shared with many people, it may
        take up to 24 hours to be able to view or download the file. If you
        still can't access a file after 24 hours, contact your domain
        administrator.

You may still be able to access the file from the browser:

         https://drive.google.com/uc?id=1CDuzEbjK1hPbMItoJwrLIMgK25FSRM6_

```

这时，就需要使用 Token 和[命令行](https://so.csdn.net/so/search?q=%E5%91%BD%E4%BB%A4%E8%A1%8C&spm=1001.2101.3001.7020)下载（以下内容参考自 [stackoverflow](https://stackoverflow.com/questions/65312867/how-to-download-large-file-from-google-drive-from-terminal-gdown-doesnt-work)）。

大型文件 - 命令行
----------

*   进入 [https://developers.google.com/oauthplayground/](https://developers.google.com/oauthplayground/)
    
*   找到这一条并点击，然后点下面的 `Authorize APIs`  
    ![](https://i-blog.csdnimg.cn/blog_migrate/db3a4fee03d98936cae8d5e13c19ead6.png)
    
*   再点击出现的`Exchange authorization code for tokens`
    
*   复制生成的 `Access Toekn`
    
*   在终端运行（注意，下面的`ACCESS_TOKEN`要换成刚才复制的，`FILE_ID`改成要下载的文件`ID`，`FILE_NAME`改成要保存的文件名）
    

```
curl -H "Authorization: Bearer ACCESS_TOKEN" https://www.googleapis.com/drive/v3/files/FILE_ID?alt=media -o FILE_NAME

```

然后就开始漫长的传输了。  
![](https://i-blog.csdnimg.cn/blog_migrate/40ad1f3087075ef761eb7a0a08aabf28.png)