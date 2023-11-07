title: HTML5 div article section标签区别与应用
categories: 网站百科
tags: [网站技巧]
date: 2020-06-11 14:37:42
id: 0005
---
  <p>HTML5推出了一系列新元素，被广泛应用。然而，有一些元素在使用时易与传统div元素混淆，特别是这两个新元素：&lt;section&gt;和&lt;article&gt;。 我们最常被新手问到的问题是：在什么情况下我们应该使用这些元素？以及我们应该如何正确的使用这些元素？ 今天我们就来探讨一下它们之间的区别。</p><p>一、section元素</p><p>&nbsp; &nbsp; &nbsp; &nbsp;从字面理解就是区块、部分的意思，相对于article元素更加广泛，每个区块都可以使用，比如页面里的导航菜单、文章正文、文章的评论等。</p><p>&nbsp; &nbsp; &nbsp; &nbsp;1、section元素用于对网站或应用程序中页面上的内容进行分块，section元素的作用是对页面上的内容进行分块，或者说对文章进行分段，；</p><p>&nbsp; &nbsp; &nbsp; &nbsp;2、一个section元素通常由内容及其标题组成。通常不推荐为那些没有标题的内容使用section元素，</p><p>&nbsp; &nbsp; &nbsp; &nbsp;3、section元素并非一个普通的容器元素；当一个内容需要被直接定义样式或通过脚本定义行为时，推荐使用div而非section元素；</p><p>&nbsp; &nbsp; &nbsp; &nbsp;4、如果article、nav、aside元素都符合某条件，那么就不要用section元素定义；</p><p>&nbsp; &nbsp; &nbsp; &nbsp;5、section元素中的内容可以单独存储到数据库中或输出到word文档中。</p><p>二、article元素</p><p>&nbsp; &nbsp; &nbsp; &nbsp;article元素代表文档、页面或应用程序中独立的、完整的、可以独自被外部引用的内容。它可以是一篇博客或报刊中的文章、一篇论坛帖子、一段用户评论或独立的插件，或其他任何独立的内容。除了内容部分，一个article元素通常有它自己的标题（一般放在一个header元素里面），有时还有自己的脚注。</p><p>&nbsp; &nbsp; &nbsp; &nbsp;注：article元素是可以嵌套使用的，内层的内容在原则上需要与外层的内容相关联。例如，一篇博客文章中，针对该文章的评论就可以使用嵌套article元素的方式；用来呈现评论的article元素被包含在表示整体内容的article元素里面。</p><pre class="prism-highlight prism-language-markup">&lt;article&gt;
　　&lt;header&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;h1&gt;article元素使用方法&lt;/h1&gt;
　　　&lt;p&gt;发表日期：&lt;time&nbsp;pubdate=&quot;pubdate&quot;&gt;2019/2/9&lt;/time&gt;&lt;/p&gt;
　　&lt;/header&gt;
　　&lt;p&gt;此标签里显示的是article整个文章的主要内容，，下面的section元素里是对该文章的评论&lt;/p&gt;
　　&lt;section&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;h2&gt;评论&lt;/h2&gt;
　　　&nbsp;&nbsp;&nbsp;&nbsp;&lt;article&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;header&gt;
　　　　　　　　&lt;h3&gt;发表者：yiwuku&lt;/h3&gt;
　　　　　　　　&lt;p&gt;1小时前&lt;/p&gt;
　　　　　&lt;/header&gt;&nbsp;&nbsp;
　　　　　&lt;p&gt;这篇文章很不错啊，顶一下！&lt;/p&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/article&gt;&nbsp;
　　　　&lt;article&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;header&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
　　　　　　&nbsp;&nbsp;&nbsp;&lt;h3&gt;发表者：益吾库&lt;/h3&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;p&gt;1小时前&lt;/p&gt;
　　　　　&lt;/header&gt;
　　　　&nbsp;&nbsp;&nbsp;&nbsp;&lt;p&gt;这篇文章很不错啊，对article解释的很详细&lt;/p&gt;&nbsp;&nbsp;
　　　　&lt;/article&gt;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/section&gt;
&lt;/article&gt;</pre><p>三、div元素<br /></p><p>div是html中最古老的元素之一，对应英文单词中的division，是块级元素，浏览器通常会在 div 元素之前和之后插入换行符，所以div之间内容会自动换行。div可以定义文档中的分区或节，把文档分割成独立不同的部分，是最常用的一个标签，在网页呈现中发挥着极大的作用，但div本身没有什么语义，更适合和进行样式化。</p>  