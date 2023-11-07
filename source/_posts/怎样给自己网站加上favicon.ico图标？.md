title: 怎样给自己网站加上favicon.ico图标？
categories: 网站百科
tags: [网站技巧]
date: 2020-06-11 14:38:36
id: 0011
---
我们先来认识下favicon，它是英文Favorites Icon的缩写，顾名思义，其本意是让浏览器的收藏夹中除显示相应的文字标题外，还能以图标的方式区别不同的网站。一般业界中文俗称站标，现在多数浏览器都已支持直接在窗口标签上或地址栏中显示站标。一个好的网站想在推广方面取得成功，不仅需要良好的页面设计、令人印象深刻的网站Logo，也应该有独树一帜的favicon站标。今天我们就针对新手站长来探讨一下，如何为自己网站添加favicon.ico站标？

实际上favicon.ico就是一个特殊格式的图片，按照既定规则准备好这样的图片放到网站，浏览器就能识别并显示出来，网站站标favicon.ico的尺寸通常是64X64、48X48、32X32像素这几种规格。既然是图片，那么我们首先就需要用制图软件设计出来，要求高的话还可以请专业设计人员制作，有的制图软件可以直接保存为.ico格式，如果不能也可以通过在线转换工具将jpg、png等格式转为ico格式。
<p style="text-align: center;"><img class="aligncenter" title="20171108100751.png" src="https://www.v-li.com/img/2020/201711081510107620813955.png" alt="20171108100751.png" /></p>
现在我们来说一下规则，一般情况下浏览器只能识别名为favicon.ico的图标文件作为站标，且必须是真实的.ico格式（扩展名），只改扩展名可能导致浏览器无法识别。将favicon.ico文件放在网站根目录下（到底什么是网站根目录？），也就是网站首页文件（如index.html/index.php等）所在目录（注意与模板目录区别开），浏览器就能自动读取。如果需要考虑兼容相对老旧浏览器，则可以在网站首页或头部模板文件head部分加上如下声明代码：
<blockquote>&lt;link rel="shortcut icon" href="favicon.ico" type="image/x-icon"&gt;

&lt;link rel="icon" href="favicon.ico" type="image/x-icon"&gt;</blockquote>
以上代码需加在&lt;/head&gt;标签之前，第一行为必须且所有浏览器都支持，第二行仅在需要区别IE和标准浏览器并使用不同图标时使用，使用声明代码后，站标图片文件则可以不必限于favicon.ico名称，使用GIF 文件type应为 image/gif， PNG 文件则为 image/png，也可以放在其它目录，同时也可以为不同目录的首页文件各自声明不同的站标。

随着老旧浏览器的淘汰，现在各种较新版本浏览器基本都能自动识别网站根目录下的favicon.ico站标，所以也有很多站长已不再使用声明代码这种方式，而且大家比较公认的通常做法也是将favicon.ico文件上传到网站根目录，这种方式对同一域名下全站目录有效。

对于站标到底要不要放根目录、要不要起另外的名称，可以参考看看以下知名网站的站标：

https://www.baidu.com/favicon.ico

https://www.taobao.com/favicon.ico

http://www.qq.com/favicon.ico

http://www.163.com/favicon.ico

http://www.sina.com.cn/favicon.ico

下面我们顺便讲一下Apple设备私有的apple-touch-icon图标属性：
<blockquote>&lt;link rel="apple-touch-icon" href="appleicon.png"&gt;</blockquote>
添加该语句后，在iPhone,iPad,iTouch的safari浏览器上可以使用添加到主屏按钮将网站添加到主屏幕上，方便用户从主屏中随时点击访问，相当于Windows系统的桌面快捷方式。实现方法是在HTML文档的&lt;head&gt;标签加入以上代码即可。

apple-touch-icon 标签支持sizes属性，可以用来放置对应不同的设备：57×57（默认值）的图标对应320×640的iphone老设备、72×72对应ipad、114×114对应retina屏的iPhone及iTouch、ipad3对应144×144的高分辨率。

所以，理论上完善的写法是：
<blockquote>&lt;link rel="apple-touch-icon" sizes="57x57" href="touch-icon-iphone.png"&gt;

&lt;link rel="apple-touch-icon" sizes="72x72" href="touch-icon-ipad.png"&gt;

&lt;link rel="apple-touch-icon" sizes="114x114" href="touch-icon-iphone4.png"&gt;

&lt;link rel="apple-touch-icon" sizes="144x144" href="apple-touch-icon-ipad3-144.png"&gt;</blockquote>
但实际上很多网站并没有用到sizes属性，而是只预置了一种尺寸的图标让其自动缩放。虽然苹果官方都用的png图片做说明，但实际测试jpg格式也可用（不推荐），图片无需做圆角和高光效果，同Native App一样，系统会自动为图标添加圆角及高光。如果不想系统对图标添加该效果，可以用apple-touch-icon-precomposed代替apple-touch-icon，为了独具特色就可以自己做圆角和高亮效果了。

如果您的网站是由ZBlogPHP程序架构，那么以上知识大致读读就好，这里安利一款由本站站长制作的《Favicon站标设置》免费插件，不必修改模板代码就可以轻松实现站标的设置和添加操作，可以在自己网站后台应用中心搜索“Favicon站标设置”找到插件直接下载启用。