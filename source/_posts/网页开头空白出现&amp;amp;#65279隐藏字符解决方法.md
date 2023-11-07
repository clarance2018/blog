title: 网页开头空白出现&amp;amp;#65279隐藏字符解决方法
categories: 网站百科
tags: [网站技巧]
date: 2020-06-11 14:38:33
id: 0020
---
网页开头莫名其妙出现一行空白，不管你怎么折腾CSS用margin、padding、border等属性值为0来定义，都不能消除，在头部有背景色的网页中尤其明显也更容易被发现。出现这种情况时，通过FireFox和Chrome浏览器开发工具审查元素查看源代码，我们可以发现body标签之后有&amp;#65279字样，空白正是由它产生，这串字符在实际网页内容中无法被查找到。那么这种情况是什么原因导致的，又该怎么处理呢？今天益吾库就来分享一些心得和经验。
<p style="text-align: center;"><img title="1.png" src="https://www.v-li.com/img/2020/201711201511161646822598.png" alt="1.png" /></p>
&amp;#65279的产生是由于文件保存的时候，被自动加入了BOM字符，一般是使用WINDOWS自带记事本工具编辑保存UTF-8网页文件导致。使用相对专业的网页代码编辑软件则不会出现这种情况，相信许多资深网页前端都曾给过初学者一些忠告，比如不要使用记事本修改UTF-8编码网页，包括禁止在某些FTP软件中直接编辑，而是使用Dreamweaver、Sublime Text、Notepad++等相对专业的工具软件。

BOM（Byte Order Mark）是指字节顺序标记，出现在文本文件头部，Unicode编码标准中用于标识文件是采用哪种格式的编码。UTF-8不需要BOM来表明字节顺序，但可以用BOM来表明编码方式。字符ZERO WIDTH NO-BREAK SPACE的编码是EF BB BF，如果接受者收到了三个不可见的字符（0xEF 0xBB 0xBF，即BOM）开头的字节流，就知道这是UTF-8编码了。 WINDOWS就是用BOM来标记文本文件的编码方式的。

BOM对一般静态网页直观影响主要就是产生空白，以及部分网页内容版面样式异常，比如TABLE表格内容文字变大等。非直观影响则有HEAD中META标签偏移到BODY中，以及可能的网站程序功能异常。例如对于PHP来说，BOM就是个大麻烦， PHP并不会忽略BOM，所以在读取、包含或者引用这些文件时，会把BOM作为该文件开头正文的一部分。根据嵌入式语言的特点，这种特殊字符将被直接执行并显示出来。受COOKIE送出机制的限制，在有这种BOM开头的文件中，COOKIE无法送出（因为在COOKIE送出前PHP已经送出了文件头），诸如登录和退出之类的功能就可能失效，基于SESSION实现的功能情况相似。

去掉&amp;#65279隐藏字符的最根本办法，就是利用Dreamweaver、Sublime Text、Notepad++等软件重新另存相关网页文件，保存时需注意去掉Unicode签名。以Dreamweaver为例，“包括Unicode签名（BOM）”选项前面的勾应该是去掉状态。
<p style="text-align: center;"><img title="20171120143348.png" src="https://www.v-li.com/img//2020/201711201511159863323384.png" alt="20171120143348.png" /></p>
另一种去掉&amp;#65279隐藏字符的方法就是使用JS代码强制替换，但这种方法治标不治本，还需要为网页额外添加无意义的代码，建议仅作应急之用。代码如下：
<pre class="prism-highlight prism-language-javascript">var a=document.body.innerHTML; 
document.body.innerHTML=a.replace(/\ufeff/g,'');</pre>