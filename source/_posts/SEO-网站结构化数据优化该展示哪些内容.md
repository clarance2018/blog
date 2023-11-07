title: SEO|网站结构化数据优化该展示哪些内容
categories: 技术笔记
tags: [SEO,结构化数据]
date: 2023-01-31 09:05:25
id: 0002
---
一、什么是网站结构化数据优化？

这个最开始是主要是google那边用得多，简单理解就是不再是搜索单一标题和描述，做了这个搜索相关评价等数据也会显示出来，让搜索用户了解更多。

百度2013年上线该功能，一是描述摘要是在普通摘要基础上增加了一些结构化内容，给用户提供更丰富的摘要内容。比如问答类结果中的回复数、提问时间，资料下载中的资料大小，下载条件，软件下载类结果中的软件大小、更新时间等。

百度针对此推出的结构化数据工具是百度引入优质结构化数据的入口，现在互联网中的资源类型越来越多，内容越来越丰富，为了给用户展示更丰富的搜索结果，同时给予网站内容更合适的展现，提高搜索结果的点击率。


百度站长资源平台结构化数据工具
二、提交的结构化数据都会展现结构化摘要吗？

百度对已提交的结构化数据，不保证一定会展现。展现结构化摘要的条件包括但不限于：

1、结构化字段表述准确，符合规范。

2、结构化字段内容与页面相应内容一致。

3、页面内容质量高，如问答页，答案需有助于提问者解决疑问。

4、url已被百度收录。

三、各类型网站结构化数据优化代码

1、短视频类

    <!--必填-->
    
    <meta property=”og:type” content="video"/>
    
    <meta property="og:title” content="视频的显示名称"/>
    
    <meta property="og:description” content="视频的文字描述"/>
    
    <meta property="og:image" content="视频的显示图片"/>
    
    <!--选填-->
    
    <meta property="og:video" content="视频播放地址"/>
    
    <meta property="og:url" content="页面URL地址"/>
    
    <meta property="og:video:duration" content="视频播放的时长，秒"/>
    
    <meta property="og:video:pix" content="视频清晰度，1: 流畅; 2: 标清; 3: 高清; 4: 超清"/>
    
    <meta property="og:video:release_date" content="视频的创建时间"/>
    
    <meta property="og:video:update_date" content="视频的更新时间"/>
    
    <meta property="og:video:actor" content="视频演员"/>
    
    <meta property="og:video:director" content="视频导演"/>

2、影视信息类

    <!--必填-->
    
    <meta property="og:type" content="videolist"/>
    
    <meta property="og:title" content="视频的显示名称"/>
    
    <meta property="og:description" content="视频的文字描述"/>
    
    <meta property="og:image" content="视频的显示图片"/>
    
    <!--选填-->
    
    <meta property="og:url" content="页面URL地址"/>
    
    <meta property="og:video" content="视频播放地址，若是更新中的电视剧，填最新剧集的url，若是更新完的电视剧，填第一集url"/>
    
    <meta property="og:video:actor" content="视频主演"/>
    
    <meta property="og:video:director" content="视频导演"/>
    
    <meta property="og:video:duration" content="视频播放的时长，秒"/>
    
    <meta property="og:video:pix" content="视频清晰度，1: 流畅; 2: 标清; 3: 高清; 4: 超清"/>
    
    <meta property="og:video:release_date" content="视频的上映时间"/>
    
    <meta property="og:video:update_date" content="视频的更新时间"/>
    
    <meta property="og:video:alias" content="视频别名"/>
    
    <meta property="og:video:area" content="地区"/>
    
    <meta property="og:video:score" content="评分"/>
    
    <meta property="og:video:base_score" content="评分总分，如9分，总分是10分"/>
    
    <meta property="og:video:update_new" content="最新剧集，如10，表示更新到第10集"/>
    
    <meta property="og:video:update_total" content="总剧集数"/>
    
    <meta property="og:video:tv" content="出品视频的电视台"/>
    
    <meta property="og:isfree:class" content="整数,1为收费"/>
    
    <meta property="og:video:class" content="视频类别，如悬疑、爱情、动作、"/>
    
    <meta property="og:video:voice_actor" content="声优，多用于动漫"/>
    
    <meta property="og:video:lecturer" content="讲师，多用于教育类视频"/>
    
    <meta property="og:video:host" content="主持人，多用于综艺主持人"/>
    
    <meta property="og:video:content_type" content="数字"/>
    
    [注：1) tv 电视剧；2) movie　电影；3)fun 综艺、娱乐节目；4) edu　教育; 5) comic　动画片、动漫; 6) documentary 记录片]
    
    <meta property="og:video:language" content="视频语言"/>

3、小说类

    <!--必填-->
    
    <meta property="og:type" content="novel"/>
    
    <meta property="og:title" content="小说名字"/>
    
    <meta property="og:description" content="小说描述"/>
    
    <meta property="og:image" content="小说封面图片"/>
    
    <meta property="og:novel:category" content="小说类别"/>
    
    <meta property="og:novel:author" content="小说作者"/>
    
    <meta property="og:novel:book_name" content="书名"/>
    
    <meta property="og:novel:read_url" content="阅读地址"/>
    
    <!--选填-->
    
    <meta property="og:url" content="页面URL地址"/>
    
    <meta property="og:novel:status" content="小说状态，如连载中"/>
    
    <meta property="og:novel:author_link" content="小说作者链接"/>
    
    <meta property="og:novel:update_time" content="更新时间"/>
    
    <meta property="og:novel:click_cnt" content="点击数"/>
    
    <meta property="og:novel:latest_chapter_name" content="最新章节"/>
    
    <meta property="og:novel:latest_chapter_url" content="最新章节url"/>
    
    <meta property="og:novel:author_other_books" content="作者其他作品"/>

4、新闻类

    <!--必填-->
    
    <meta property="og:type" content="news"/>
    
    <meta property="og:title" content="新闻标题"/>
    
    <meta property="og:description" content="新闻摘要"/>
    
    <meta property="og:image" content="新闻图片"/>
    
    <!--选填-->
    
    <meta property="og:url" content="页面URL地址"/>
    
    <meta property="og:release_date" content="发布时间"/>

5、音乐单曲

    <!--必填项-->
    
    <meta property="og:type" content="music.song"/>
    
    <meta property="og:title" content="歌曲名"/>
    
    <meta property="og:music:artist" content="歌手"/>
    
    <meta property="og:music:play" content="播放链接"/>
    
    <!-- 选填 -->
    
    <meta property="og:music:album" content="专辑名称"/>
    
    <meta property="og:image" content="海报"/>

6、音乐专辑

    <!--必填项-->
    
    <meta property="og:type" content="music.album"/>
    
    <meta property="og:image" content="专辑配图"/>
    
    <meta property="og:title" content="专辑名称"/>
    
    <meta property="og:music:artist" content="歌手"/>
    
    <meta property="og:music:album:song" content=" title=歌曲名; url=歌曲播放链接"/>(可以有 多个)

7、软件下载

    <!--必填-->
    
    <meta property="og:type" content="soft"/>
    
    <meta property="og:description" content="软件简介"/>
    
    <meta property="og:soft:file_size" content="软件大小"/>
    
    <!--选填-->
    
    <meta property="og:soft:operating_system" content="软件运行的操作系统，如windows、android、ios等"/>
    
    <meta property="og:image" content="软件的截图"/>
    
    <meta property="og:release_date" content="发布时间"/>
    
    <meta property="og:title" content="软件标题"/>
    
    <meta property="og:soft:download_count" content="软件下载次数"/>
    
    <meta property="og:soft:language" content="软件语言"/>
    
    <meta property="og:soft:license" content="软件的授权方式，如免费、收费等"/>
    
    <meta property="og:soft:url" content="软件的下载页面地址"/>

8、文档

    <!--必填-->
    
    <meta property="og:type" content="document"/>
    
    <meta property="og:release_date" content="发表时间"/>
    
    <meta property="og:title" content="文档标题"/>
    
    <meta property="og:description" content="文档摘要"/>
    
    <meta property="og:document:type" content="文档类型，如ppt\pdf\doc\txt\xls等"/>
    
    <!--选填-->
    
    <meta property="og:image" content="文档的截图或配图url"/>
    
    <meta property="og:document:page" content="文档页数"/>
    
    <meta property="og:document:cost" content="获取文档的花费，如免费、5积分等"/>

9、普通文章

    <!--必填-->
    
    <meta property="og:type" content="article"/>
    
    <meta property="og:image" content="http://exp.com/XX.jpg "/>
    
    <meta property="og:release_date" content="2021-11-21"/>
    
    <meta property="og:title" content="XXXXXXXXX"/>
    
    <meta property="og:description" content="XXXX经典语句,资料来自:XX"/>

10、图片

    <!--必填-->
    
    <meta property="og:type" content="image"/>
    
    <meta property="og:image" content="http://e.com/e.jpg"/>

11、论坛帖子

    <!--必填-->
    
    <meta property="og:type" content="bbs"/>
    
    <meta property="og:image" content="http://XX.com/XX.jpg "/>
    
    <meta property="og:title" content="XXX的方法和教程"/>
    
    <meta property="og:description" content="帖子《XXX方法和教程(图文)》"/>
    
    <meta property="og:author" content="bbbxyoiil"/>
    
    <meta property="og:release_date" content="2021-XX-XX"/>
    
    <meta property="og:bbs:replay" content="10"/>

12、博客

    <!--必填-->
    
    <meta property="og:type" content="blog"/>
    
    <meta property="og:image" content="http://XX.com/exp.jpg "/>
    
    <meta property="og:title" content="2021年电影上映时间表"/>
    
    <meta property="og:description" content="2021年电影上映时间表(内地即将上映的N部好莱坞大片)” />
    
    <meta property="og:author" content="XXX"/>
    
    <meta property="og:release_date" content="20XX-XX-XX"/>

13、商品

    <!--必填-->
    
    <meta property="og:type" content="product"/>
    
    <meta property="og:image" content="http://XX.com/XX.jpg "/>
    
    <meta property="og:title" content="XX5G智能手机"/>
    
    <meta property="og:description" content="XXXXXXXXX"/>
    
    <meta property="og:product:price" content="XXXX"/>
    
    <meta property="og:product:orgprice" content="XXX"/>
    
    <meta property="og:product:currency" content="XXX"/>
    
    <meta property="og:product:score" content="0.93"/>
    
    <meta property="og:product:base_score" content="1"/>
    
    <meta property="og:product:brand" content="XXX"/>
    
    <meta property="og:product:category" content="XX"/>
    
    <meta property="og:product:nick" content="name=移动旗舰店; url= http://XXX.html"/>

注：部分内容来源于网络，侵删！![pexels-pixabay-270637.jpg][1]


  [1]: https://www.v-li.com/img/2023/01/474932834.jpg