title: 如何为typecho&amp;wordpress添加og标签
categories: 技术笔记
tags: [SEO]
date: 2023-02-03 10:11:00
id: 0029
---
og标签用于社交分享时第三方网站获取网页基本信息，诸如网页封面图片、网页标题、网页描述等。

Open Graph Protocol（开放图谱协议），简称 OG 协议或 OGP。它是 Facebook 在 2010 年 F8 开发者大会公布的一种网页元信息（Meta Information）标记协议，是一种制定一套Metatags的规格，用来标注你的页面，即这种协议可以让网页成为一个“富媒体对象”。是一种 Meta 标签。作用就是为社交分享而生的 Meta 标签。它是目前社交媒体优化（SMO）的基本操作。

更多og标签设置：[SEO|网站结构化数据优化该展示哪些内容][1] 

### 如何为wordpress添加og标签？

    function sk_og_meta() { 
        if(is_single()){
            $og_image = catch_that_image(); //如果是文章页面，把文章中的第一张图片作为og:image
        }
        if(!$og_image){
            $og_image = 'image_url'; //把image_url换成你的默认og:image图片的链接
        }
        ?>
        <meta name="og:title" contect="<?php echo get_the_title(); ?>">
        <meta name="og:image" contect="<?php echo $og_image; ?>">
        <meta name="og:url" contect="<?php echo get_permalink(); ?>">
        <meta name="og:type" contect="article">
        <meta name="og:site_name" contect="你的网站名称">
    <?php }
    function catch_that_image() {
    	global $post, $posts;
    	$first_img = '';
    	ob_start();
    	ob_end_clean();
    	$output = preg_match_all('/<img.+src=[\'"]([^\'"]+)[\'"].*/iU', $post->post_content, $matches);
    	$first_img = $matches[1][0];
    	return $first_img;
    }

把上面的代码放入wordpress主题文件夹中的function.php文件最后，然后在主题的head处调用sk_og_meta()即可。如果是文章页，会把把文章中的第一张图片作为og:image，如果不是文章页面或者文章中没有图片，则使用默认图片作为og:image。

比如我使用的是neve主题，只要在以上代码块下面添加一行：

    add_action( 'neve_head_start_after', 'sk_og_meta' );

### 如何为typecho 添加og标签？
在主题header.php中，在<head>标签里合适的位置添加代码：

只在文章页添加，is('post')进行判断：

        <?php if ($this->is('post')) : ?>
    <!--内页seo优化-->
        <meta property="og:site_name" content="<?php $this->options->title() ?>" />
    <!-- 表明当前页面所在网站名称 -->
        <meta property="og:type" content="article" />
    <!-- 表明当前页面类型符合OG协议中的文章作品类型 -->
        <meta property="og:url" content="<?php $this->permalink() ?>" />
    <!-- 表明当前页面的url地址 -->
        <meta property="og:title" content="<?php $this->title() ?>" />
    <!-- 表明当前页面标题 -->
        <meta property="og:description" content="<?php $this->description(); ?>" />
    <!-- 表明当前页面的缩略图 此处请根据自己的情况自己调整代用代码-->
        <meta property="og:category" content="<?php $this->category(',', false); ?>" />
    <!-- 表明当前页面所在的栏目 非星火计划支持，单独添加的-->
        <meta property="article:author" content="<?php $this->author(); ?>" />
    <!-- 表明当前页面的作者署名字段，需要在页面做展示-->
        <meta property="article:publisher" content="<?php $this->options->siteUrl(); ?>" />
    <!-- 表明当前页面的发布者 一般放网址-->
        <meta property="article:published_time" content="<?php $this->date('c'); ?>" />
    <!-- 表明当前页面最早发布时间，该字段必选，可以不在页面中做展示，内容格式要求符合ISO8601规范的UTC格式，标准格式应当是“YYYY-MM-DDTHH:MM:SS+时区” 此处请根据自己的情况自己调整代用代码-->
        <meta property="article:published_first" content="<?php $this->options->title() ?>, <?php $this->permalink() ?>" />
    <!-- 表明当前页面的原发媒体名称和链接，用于区分原创和转载，该字段为可选。原创时，链接与自身相同；转载时，链接是另外不同的地址-->
        <meta property="article:tag" content="<?php $this->keywords(',');?>" />
    <!-- 表明当前页面的TAG标签， 非星火计划支持，单独添加的-->
    <?php endif; ?>  


  [1]: https://www.v-li.com/Technical-Notes/174.html