---
title: 百度Url提交的两种方式
categories: Web开发
tags: [技术笔记,记录,SEO,经验分享]
date: 2024-11-26 09:00:34
id: 0086
top_img:
swiper_index: 
cover: 
---



自从百度取消小站的sitemap权限，提交链接到百度的方式真是越来越少。
我这边找到两种方法，或者说只有一种，另外一种是基于我自己的Nas,通过青龙面板自动执行。在这里记录一下。
### 方法一：通过curl主动提交
在桌面创建一个文件夹，文件夹里面创建两个txt文档。
* 文档一：urls.txt 用来存放你的链接地址，一行一个：
* 文档二：将下面代码复制到文档内，保存，改为.bat的文件后缀。

 ```bash
    curl -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls?site=https://6mal.com&token=XXXXXXXXXXX"
    pause
 ```
PS:记得修改为自己的网站地址及token

### 方法二：python脚本提交
主要还是觉得第一种比较麻烦，每天需要复制新的链接，然后在进行上传，恰好刚开始玩NAS，于是想着青龙面板是不是也可以帮我完成这个工作，于是便有了下面的这个脚本。

这个脚本就是从sitemap.xml自动获取新的URL，提交到百度，由于我的站长权限问题，我这边限制了每天提交10条，如果你的权限更高也可以进行修改。当然这边也进行了限制，如果出现over quota也会停止运行。

```python
import requests
import xml.etree.ElementTree as ET
import time
from datetime import datetime
from urllib.parse import urlparse
import os

# 参数配置
SITEMAP_URL = 'https://6mal.com/sitemap.xml'  # 要获取的 sitemap URL
BAIDU_API_URL = 'http://data.zz.baidu.com/urls?site=https://6mal.com&token=XXXXXXXXXXXXX'  # 百度收录 API 地址
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}
MAX_SUBMISSIONS_PER_DAY = 10  # 每天最大提交条数
SUBMITTED_LINKS_FILE = 'submitted_links.txt'  # 已提交链接的文件

def log(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{timestamp} - {message}")

def get_latest_urls_from_sitemap(sitemap_url, limit=10):
    log(f"开始从 {sitemap_url} 获取最新的 URL")
    try:
        response = requests.get(sitemap_url, headers=HEADERS)
        response.raise_for_status()
        urls = []
        root = ET.fromstring(response.content)
        for loc in root.findall('.//{*}loc'):
            urls.append(loc.text)
            if len(urls) >= limit:
                break
        log(f"获取到 {len(urls)} 个 URL")
        return urls
    except Exception as e:
        log(f"从 sitemap 获取 URL 时出错: {e}")
        return []

def submit_url_to_baidu(url):
    if not url:
        log("没有要提交的 URL。")
        return None

    try:
        headers = {'Content-Type': 'text/plain; charset=UTF-8'}
        response = requests.post(BAIDU_API_URL, data=url.encode('utf-8'), headers=headers)
        response.raise_for_status()
        if response.json().get('error') == 400 and response.json().get('message') == 'over quota':
            log(f"提交 URL {url} 时达到配额限制，停止提交。")
            return None
        log(f"提交 URL {url} 成功")
        return response.json()
    except requests.exceptions.HTTPError as e:
        log(f"提交 URL {url} 时出错: {e}")
        log(f"响应状态码: {e.response.status_code}")
        log(f"响应内容: {e.response.text}")
    except Exception as e:
        log(f"提交 URL {url} 时发生其他错误: {e}")
    return None

def log_submission(url, response):
    if response:
        status_message = "提交成功" if response.get('success') == 1 else "提交失败"
        log(f"{url} 状态: {status_message}")

def check_and_submit_links():
    log("开始检查并提交链接")
    submitted_links = set()
    if os.path.exists(SUBMITTED_LINKS_FILE):
        with open(SUBMITTED_LINKS_FILE, 'r') as file:
            submitted_links = set([line.strip() for line in file.readlines()])

    new_urls = get_latest_urls_from_sitemap(SITEMAP_URL)
    unsubmitted_urls = [url for url in new_urls if url not in submitted_links]

    pending_urls = unsubmitted_urls if len(unsubmitted_urls) < MAX_SUBMISSIONS_PER_DAY else unsubmitted_urls[:MAX_SUBMISSIONS_PER_DAY]

    submitted_count = 0
    for url in pending_urls:
        if submitted_count >= MAX_SUBMISSIONS_PER_DAY:
            log("已达到每天最大提交条数，停止提交。")
            break
        response = submit_url_to_baidu(url)
        if response is None:  # 如果达到配额限制或提交失败，则停止提交
            break
        log_submission(url, response)
        submitted_count += 1
        time.sleep(2)

    with open(SUBMITTED_LINKS_FILE, 'a') as file:
        for url in pending_urls:
            file.write(url + '\n')

    log("执行结束")

if __name__ == '__main__':
    check_and_submit_links()
```


