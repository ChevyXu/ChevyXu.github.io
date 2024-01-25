---
layout: post
title: Install Rstudio Server introduction
subtitle: 君子欲讷于言而敏于行。
date: 2024-01-22
author: Chevy
header-img: img/055.png
catalog: true
header-mask: 20%
tags:
  - 技术学习笔记
style: plain
---

> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [claudiu.psychlab.eu](https://claudiu.psychlab.eu/post/install-r-rstudio-rstudioserver-ubuntu-linux/)

##  Tutorials from Claudiu's blog

### Install R (`r-base`)

##### 1. Install helper software `software-properties-common` and `dirmngr`

*   `software-properties-common` for managing the repositories that you install software from.
    
*   `dirmngr` for managing and downloading certificate revocation lists and for downloading the certificates themselves.
    

```shell
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
```

##### 2. Set repository

R (`r-base`) can be installed by simply running `apt install`, but the version of R in the default repository is usually not up-to-date. So we are going to tell `apt install` to obtain the latest version from a CRAN repository.

To do this we can make an entry in `/etc/apt/sources.list` file by running `sudo nano /etc/apt/sources.list` and pasting in `deb https://<my.favorite.cran.mirror>/bin/linux/ubuntu <code-name-adjective>-cran40/` (where _<my.favorite.cran.mirror>_ may be `https://cloud.r-project.org` and _`<code-name-adjective>`_ is the Ubuntu release code name adjective). After, we only need to add the key so that `apt` can perform signature checking of the Release File for the added repository to verify its authenticity. The CRAN repository for Ubuntu is signed with the key of “Michael Rutter [marutter@gmail.com](mailto:marutter@gmail.com){.email}”.

Fortunately, all of this can be done by running the following:

```shell
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
```

We use `lsb_release -cs` to access which Ubuntu flavor the machine is running. For this example, I am running Impish Indri (21.10, amd64 only), so I could have typed `impish` instead of `$(lsb_release -cs)`.

##### 3. Install `r-base`

Install R and its dependencies by running:

```
sudo apt install --no-install-recommends r-base


```

Up until this point, everything we done is the step-by-step installation provided by [official CRAN Brief Instructions](http://cran.rstudio.com/bin/linux/ubuntu/) (it is a good idea to also check the [full README](https://cran.rstudio.com/bin/linux/ubuntu/fullREADME.html)).

Now we just run R inside the terminal by just calling `R`.

### Install R packages

##### 1. Install `r-base-dev`

R packages can be installed the `install.packages()` function in R, but it depends on `r-base-dev` package to compile source code for some R packages.

```
sudo apt install r-base-dev


```

##### 2. Install system dependencies

Some R packages have system dependencies. Here we will install the system dependencies for the [`tidyverse`](https://www.tidyverse.org/) collection of packages.

```
sudo apt install libcurl4-openssl-dev libssl-dev libxml2-dev


```

Now we can install `tidyverse` from within R by running `install.packages("tidyverse")`.

##### 3. Handling the _is not writable_ error

This error is very old and still persistent (see [here](https://stackoverflow.com/questions/32540919/library-is-not-writable) and [here](https://stat.ethz.ch/pipermail/r-help/2021-April/470787.html)).

```
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
Warning in install.packages :
  'lib = "/usr/local/lib/R/site-library"' is not writable


```

There are multiple ways around it (see [here](https://stat.ethz.ch/pipermail/r-help/2021-April/470792.html) for adding user to group, [here](https://stat.ethz.ch/pipermail/r-help/2021-April/470788.html) for installing as root, [here](https://stat.ethz.ch/pipermail/r-help/2021-April/470793.html) for using per-project libraries) and although it may create problems with multi-user multi-project workflows, we will just use a **personal library** (advised [here](https://stat.ethz.ch/pipermail/r-help/2021-April/470790.html)).

Just accept when R asks if you would like to create a personal library.

### Install RStudio

##### 1. Install `gdebi-core`

To install both RStudio and RStudio Server we will need `gdebi-core` to install them from `.deb` archive files.

```
sudo apt update

dpkg -l | grep gdebi

sudo apt -y install gdebi-core


```

##### 2. Install RStudio

RStudio IDE official download page is [here](https://www.rstudio.com/products/rstudio/download/#download).

The installation is as straight forward as:

```
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2022.02.3-492-amd64.deb
sudo gdebi rstudio-2022.02.3-492-amd64.deb


```

But I like to manually download the `.deb` files in `./Download` folder and install from there:

```
cd ./Download
sudo gdebi $(ls | grep rstudio-2022)


```

### Install RStudio Server

RStudio Server provides a browser based interface to R running on a remote Linux server.

It is important to note from the very begining that RStudio Server by default does not allows system users (such as root) to authenticate, so we need a normal user account with sudo privilege on the server.

As mentioned above, to install both RStudio and RStudio Server we will need `gdebi-core` to install them from `.deb` archive files. Check that you have it installed.

```
sudo apt update

dpkg -l | grep gdebi


```

RStudio Server official download page is [here](https://www.rstudio.com/products/rstudio/download-server/).

The installation is simple (see [official CRAN guide](https://www.rstudio.com/products/rstudio/download-server/debian-ubuntu/)):

```
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.3-492-amd64.deb
sudo gdebi rstudio-server-2022.02.3-492-amd64.deb


```

By default RStudio Server runs on port 8787 and accepts connections from all remote clients. After installation you should therefore be able to navigate a web browser to the following address to access the server: `http://<server-ip>:8787`.

In the browser it will look like this:

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAACbklEQVRoQ+2aMU4dMRCGZw6RC1CSSyQdLZJtKQ2REgoiRIpQkCYClCYpkgIESQFIpIlkW+IIcIC0gUNwiEFGz+hlmbG9b1nesvGW++zxfP7H4/H6IYzkwZFwQAUZmpJVkSeniFJKA8ASIi7MyfkrRPxjrT1JjZ8MLaXUDiJuzwngn2GJaNd7vyP5IoIYY94Q0fEQIKIPRGS8947zSQTRWh8CwLuBgZx479+2BTkHgBdDAgGAC+fcywoyIFWqInWN9BSONbTmFVp/AeA5o+rjKRJ2XwBYRsRXM4ZXgAg2LAPzOCDTJYQx5pSIVlrC3EI45y611osMTHuQUPUiYpiVooerg7TWRwDAlhSM0TuI+BsD0x4kGCuFSRVzSqkfiLiWmY17EALMbCAlMCmI6IwxZo+INgQYEYKBuW5da00PKikjhNNiiPGm01rrbwDwofGehQjjNcv1SZgddALhlJEgwgJFxDNr7acmjFLqCyJuTd6LEGFttpmkYC91Hrk3s1GZFERMmUT01Xv/sQljjPlMRMsxO6WULwnb2D8FEs4j680wScjO5f3vzrlNJszESWq2LYXJgTzjZm56MCHf3zVBxH1r7ftU1splxxKYHEgoUUpTo+grEf303rPH5hxENJqDKQEJtko2q9zGeeycWy3JhpKhWT8+NM/sufIhBwKI+Mta+7pkfxKMtd8Qtdbcx4dUQZcFCQ2I6DcAnLUpf6YMPxhIDDOuxC4C6djoQUE6+tKpewWZ1wlRkq0qUhXptKTlzv93aI3jWmE0Fz2TeujpX73F9TaKy9CeMk8vZusfBnqZ1g5GqyIdJq+XrqNR5AahKr9CCcxGSwAAAABJRU5ErkJggg==)

A couple of notes related to user authentication (from [RStudio Getting Starded guide](https://support.rstudio.com/hc/en-us/articles/200552306-Getting-Started)):

*   RStudio Server will not permit logins by system users (those with user ids lower than 100).
    
*   User credentials are encrypted using RSA as they travel over the network.
    
*   You can manage users with standard Linux user administration tools like `useradd,` `userdel`, etc.
    
*   Each user needs to be created with a home directory.
    

**RStudio Server Commands**

See info on:

*   [Getting Started](https://support.rstudio.com/hc/en-us/articles/200552306-Getting-Started),
    
*   [Configuring the Server](https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server),
    
*   [Managing the Server](https://support.rstudio.com/hc/en-us/articles/200532327-Configuring-the-Server),
    
*   [Running with a Proxy](https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy).
    

Also, here we are using the free RStudio Server, but the docs on Rstudio Workbench (formally known as RStudio Server Pro - the paid product offered by RStudio) on [Administration](https://docs.rstudio.com/ide/server-pro/server_management/core_administrative_tasks.html) provide good information for both.

##### Stopping and Starting

```
sudo rstudio-server stop
sudo rstudio-server start
sudo rstudio-server restart

sudo rstudio-server status 

sudo rstudio-server reload 


```

##### Managing Active Sessions

```
sudo rstudio-server active-sessions 

sudo rstudio-server suspend-session <pid> 
sudo rstudio-server force-suspend-session <pid> 
sudo rstudio-server force-suspend-all  

sudo rstudio-server kill-session <pid>  
sudo rstudio-server kill-all   


```

##### Taking the Server Offline

```
sudo rstudio-server offline
sudo rstudio-server online


```

##### Special tip: Rstudio Server webapp

If you prefer the RStudio Desktop look to the in-browser one when working on RStudio Server, you can create a webapp launcher for it (see [here](https://stackoverflow.com/questions/26141396/can-rstudio-desktop-be-used-as-a-client-to-rstudio-server-instead-of-the-web-i) and [here](https://askubuntu.com/questions/31427/how-do-i-put-a-web-application-on-the-launcher)).

Disclaimer: I am not sure why you would like to do this, if you are working remotely on the server and if you are not just use RStudio Desktop.

Steps:

1.  Login to the rstudio server from the browser (<server_ip>:8787).
    
2.  On the menu bar, go to File (or Tools in some cases) -> Create application shortcut. A dialogue box will appear for the shortcut.
    
3.  Add it to your desktop by selecting and run it as if you’re running Rstudio Desktop.





## Rstudio Server 的安装和使用（附常见问题） - 简书

在本地使用 Rstudio 有很多的限制，不能够长时间跑程序，而服务器上能够满足 R 的很多条件，通过在服务器端安装 Rstudio 能够和本地一样使用 Rstudio。服务器的 Rstudio Server 通过浏览器输入 IP 地址完成。



**注意：我这里使用的是 centos 7，需要服务器的 root 权限。**



#### 1. Rstudio Server 的安装



1.1 Rstudio Server

```
wget https://download2.rstudio.org/rstudio-server-rhel-1.1.456-x86_64.rpm
sudo yum install rstudio-server-rhel-1.1.456-x86_64.rpm
```



1.2 创建配置文件

```
sudo vi /etc/rstudio/rserver.conf
sudo vi /etc/rstudio/rsession.conf   

###在两个配置文件中添加以下语句
rsession-which-r=/usr/bin/R  ##系统的R程序所在位置，如果个人目录下有利用anaconda安装R，可能会报错。
www-port=8787 ### 通过ip的8787端口连接
```



1.3 在防火墙配置文件中添加 8787 端口

```
sudo vi /etc/sysconfig/iptables

###在文件中添加以下语句：
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 8787 -j ACCEPT

### 重启防火墙
sudo service iptables restart
sudo netstat -anp ###查看开放的端口信息
```



1.4 检查 Rstudio-server 是否能够运行并启动服务

```
#检查配置是否完整
sudo rstudio-server verify-installation

#启动服务
sudo rstudio-server start
#查看状态，当出现active是，配置完成
sudo rstudio-server status
#[root@ lib64]#  rstudio-server status
#● rstudio-server.service - RStudio Server
#  Loaded: loaded (/etc/systemd/system/rstudio-server.service; enabled; vendor preset: disabled)
# Active: active (running) since Tue 2020-07-21 10:22:57 CST; 4s ago
```



1.5 打开本地的浏览器，输入 IP：端口号，会出现输入用户名和密码的提示。这里的用户名和密码就是每个用户自己的用户名和密码。



![img](http://upload-images.jianshu.io/upload_images/14359635-3d5827ba10b05247.png)

成功的网页截图



#### 2. 常见的问题及解决的方法



需要根据上面的步骤，打开 rstudio 的服务以及对应的网络端口。



2.1 RStudio Server 安装完成后，浏览器无法打开 ip:8787 登录页，显示无法访问。



这是因为没有正确的配置网络端口，根据 1.3 修改相关的配置



![img](http://upload-images.jianshu.io/upload_images/14359635-789bfd242969a7ac.png)

无法打开网页



2.2 Rstudio server "Unable to connect to service"。在输入用户名和密码后，rstudio 没有能够加载出来，并包以上出错。



通过 **rstudio-server verify-installation** 检查 Rstudio 相关的服务，并排除故障。



2.3 Rstudio 服务重启的问题。



**rstudio-server** 有三个命令可以管理 rstudio 的服务



**rstudio-server status**: 查看 rstudio 的服务情况，看是否报错**rstudio-server start/restart**: 启动（start）或者重启（restart）服务。**rstudio-server stop**: 结束服务。



**rstudio-server** 在重启的过程中，经常会遇到端口占用的问题，报错 **Address already in use**。这个错误是因为原有的进程占用已经设置好的端口，解决的方法是关闭所有占用该端口的进程。解决方案可以参考 [https://blog.csdn.net/qq_43561095/article/details/109535143](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2Fqq_43561095%2Farticle%2Fdetails%2F109535143) 这个网址。



![img](http://upload-images.jianshu.io/upload_images/14359635-4e6cfcafd52547db.png)

报错端口占用. png



2.3.1 查看端口占用情况，这里我们是默认的 8787 端口



```
lsof -i tcp:8787
```



![img](http://upload-images.jianshu.io/upload_images/14359635-987b1e871ee632d8.png)

image.png



2.3.2 结束对应的进程。这里关闭所有 LISTEN 相关的进程



```
kill -9 45551  54567 58358 92824
```



至此，问题解决。



3 参考网址
3.1 https://www.jianshu.com/p/44169741bd22
3.2 [https://www.bioinfo-scrounger.com/archives/435/](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.bioinfo-scrounger.com%2Farchives%2F435%2F)
3.3 [https://community.rstudio.com/t/rstudio-server-unable-to-connect-to-service/40600](https://links.jianshu.com/go?to=https%3A%2F%2Fcommunity.rstudio.com%2Ft%2Frstudio-server-unable-to-connect-to-service%2F40600)



### Linux 使用 iptables 配置防火墙提示：unrecognized service_iptables: unrecognized service_很简单_的博客 - CSDN 博客

[Ubuntu](https://so.csdn.net/so/search?q=Ubuntu&spm=1001.2101.3001.7020) 默认安装是没有开启任何防火墙的。



当使用 `service iptables status` 时发现提示 `iptables:unrecoginzed service`。意思是无法识别的服务。



以下方法来自 http://blog.csdn.net/lywzgzl/article/details/39938689，但是测试发现，此方法已经无法在 Ubuntu 中使用



**在 ubuntu 中由于不存在 / etc/init.d/iptales 文件，所以无法使用 service 等命令来启动 iptables，需要用 modprobe 命令。**



```
#启动iptables
modprobe ip_tables
#关闭iptables（关闭命令要比启动复杂）
iptables -F
iptables -X
iptables -Z
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
modprobe -r ip_tables
#依次执行以上命令即可关闭iptables，否则在执行modproble -r ip_tables时将会提示
#FATAL: Module ip_tables is in use.
```



**`注：通过以上方法，最终无法解决，通过研究发现，以上的命令已经是旧版，在新版中iptables本身不是一个服务。`**



而如果要继续使用 [iptables](https://so.csdn.net/so/search?q=iptables&spm=1001.2101.3001.7020) 配置，可以通过来自 http://www.cnblogs.com/general0878/p/5757377.html 的方法去实现：



```
1、查看系统是否安装防火墙
sudo whereis iptables

# 出现如上提示表示已经安装iptables，如果没有安装，可以通过以下命令安装
sudo apt-get install iptables

2、查看防火墙的配置信息
sudo iptables -L

3、新建规则文件
#先新建目录，本身无此目录
mkdir /etc/iptables
vi /etc/iptables/rules.v4

# 两条合起来的命令可以简化成以下写法
mkdir /etc/iptables & vi /etc/iptables/rules.v4
```



**添加以下内容（备注：80 是指 web 服务器端口，3306 是指 MySQL 数据库链接端口，22 是指 SSH 远程管理端口）**



```
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:syn-flood - [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
-A INPUT -p icmp -m limit --limit 100/sec --limit-burst 100 -j ACCEPT
-A INPUT -p icmp -m limit --limit 1/s --limit-burst 10 -j ACCEPT
-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A syn-flood -p tcp -m limit --limit 3/sec --limit-burst 6 -j RETURN
-A syn-flood -j REJECT --reject-with icmp-port-unreachable
COMMIT
```



```
4、使防火墙生效
iptables-restore < /etc/iptables/rules.v4

5、创建文件，添加以下内容，使防火墙开机启动
vi /etc/network/if-pre-up.d/iptables

#!/bin/bash
iptables-restore < /etc/iptables/rules.v4


6、添加执行权限
chmod +x /etc/network/if-pre-up.d/iptables

7、查看规则是否生效
iptables -L -n

`通过以上方法可以在Ubuntu上正常通过，并且可以清晰的知道其依赖关系。`
```



再或者如果要折腾 iptables 的用法，可以参考以下收集的文章进行配置：
https://serverfault.com/questions/129086/how-to-start-stop-iptables-on-ubuntu
https://help.ubuntu.com/community/IptablesHowTo



**经过研究发现，在 Ubuntu/Debian 系统上有一个防火墙的简化版，叫做 UFW，原理还是 iptables，但是由于 iptables 需要操作的表和关系很多，所以使用 UFW 来简化这些操作。**