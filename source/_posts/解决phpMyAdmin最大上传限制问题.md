title: 解决phpMyAdmin最大上传限制问题
categories: 网站百科
tags: [网站技巧]
date: 2020-06-11 14:38:00
id: 0032
---
phpMyAdmin使用方便，已成为大多数站长的常用工具，对于小型网站来讲phpmyadmin已经绰绰有余。大文件导入mysql一直以来都是个问题，一般情况下，phpMyAdmin默认最大限制上传2M以内的文件，但是当网站运营一段时间后，即使把sql格式的数据库压缩成zip格式，也可能无法控制在2M以内。

通常行业内并不推荐使用phpMyAdmin来导入大数据库，因为大多数用户使用的是虚拟主机，很多文件没有服务器权限是无法修改的，而且phpMyAdmin对大数据库的执行效率也非常低，容易出现错误。但对于只是大于2M而并非上百兆的文件，我们仍可以通过phpMyAdmin来进行数据库导入操作。网上已经有很多相关教程，但大多数都不全，只解决了一部分问题，所以今天益吾库整理出了相对比较靠谱的两种方案，希望对大家有所帮助。
<p style="margin: 0.67em 0px; padding: 0px; border: none; font-weight: normal;"><strong>解决方案一：</strong></p>
打开phpMyAdmin安装目录下的配置文件config.inc.php并查找：
<blockquote>$cfg['UploadDir'] = ”;

$cfg['SaveDir'] = ”;</blockquote>
这两个参数值默认为空，我们首先将其进行赋值：
<blockquote>$cfg['UploadDir'] = ‘upload’;

$cfg['SaveDir'] = ‘save’;</blockquote>
某些特殊情况下，修改后可能会提示“配置文件现在需要绝密的短语密码(blowfish_secret)”，此时我们就需要按照提示来，在配置文件里设置一个密码，打开phpmyadmin的配置文件 phpmyadmin/config.inc.php（注：php5.0为config.sample.inc.php），查找 $cfg['blowfish_secret'] 参数值并修改，任意数字字母都可以，也就是错误信息中提到的设置短语密码，然后重启Apache即可。

然后在 phpMyAdmin 的目录下创建两个空目录，upload 和 save，并且把要导入的sql文件（必须是sql格式，非zip格式），上传到 upload 目录下，重新刷新打开登录phpMyAdmin，点导入（import） 发现多了一个网站服务器上传文件夹，如下图所示：

<img title="1.png" src="http://www.v-li.com/img/2020/201804231524453296552576.png" />

<strong><span style="font-family: 微软雅黑, 宋体, Arial, Helvetica, sans-serif; font-size: 14px;">解决方案二：</span></strong>

首先打开PHP安装目录中的配置文件php.ini，查找 upload_max_filesize 和 post_max_size 两项参数，并将值修改大一点即可。如果上传的文件很大，还需对以下参数值进行修改，max_execution_time（php页面执行最大时间）、max_input_time（php页面接受数据最大时间）、memory_limit（php页面占用的最大内存）。因为phpmyadmin上传大文件时，php页面的执行时间、内存占用也势必变得更长更大，其需要php运行环境的配合，所以仅修改上传文件大小限制是不够的。

接下来打开 phpmyadmin 安装目录下的 config.inc.php 文件，查找 $cfg［‘ExecTimeLimit’］配置选项，默认值是300，需要修改为0，即没有时间限制。

然后打开 phpmyadmin 目录下的 import.php 文件 修改 $memory_limit 的值：

<img title="2.jpg" src="http://www.v-li.com/img/2020/201804231524453297614275.jpg" />

说明：首选读取php.ini配置文件中的内存配置选项memory_limit，如果为空则默认内存大小限制为2M，如果没有限制则内存大小限制为10M，你可以结合你php.ini配置文件中的相关信息修改这段代码。

&nbsp;