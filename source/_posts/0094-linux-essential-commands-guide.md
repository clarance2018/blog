---
title:  Linux常用代码大集锦
categories: Docker运维
tags: [技术笔记,记录,经验分享]
date: 2025-03-01 09:00:34
id: 0094
top_img:
swiper_index: 
cover: 
---

在Linux系统中，掌握一些常用的代码命令，能够帮助我们更高效地进行文件管理、系统配置、网络操作等任务。以下是一些常用的Linux命令代码，按功能分类整理，希望对你有所帮助。

## 一、文件和目录操作

### 1. 查看当前目录文件
```bash
ls
```
- `ls -l`：以长格式显示文件和目录的详细信息，包括权限、所有者、大小、修改时间等。
- `ls -a`：显示所有文件，包括隐藏文件（以`.`开头的文件）。

### 2. 切换目录
```bash
cd /path/to/directory
```
- `cd ~`：切换到当前用户的主目录。
- `cd ..`：切换到上一级目录。

### 3. 创建目录
```bash
mkdir directory_name
```
- `mkdir -p parent/child`：递归创建多级目录，如果父目录不存在会自动创建。

### 4. 删除文件或目录
```bash
rm file_name
```
- `rm -r directory_name`：递归删除目录及其内容，需要谨慎使用，建议配合`-i`选项进行确认。
- `rm -f file_name`：强制删除文件，不提示确认。

### 5. 复制文件或目录
```bash
cp source_file destination_file
```
- `cp -r source_directory destination_directory`：递归复制目录，将源目录及其内容复制到目标目录。
- `cp -p source_file destination_file`：保留文件的权限、所有者和时间戳等属性。

### 6. 移动或重命名文件
```bash
mv source_file destination_file
```
- `mv old_name new_name`：重命名文件或目录，将文件从旧名称移动到新名称。

### 7. 查看文件内容
```bash
cat file_name
```
- `less file_name`：分页查看文件内容，支持上下翻页，使用`/`搜索关键词。
- `head -n 10 file_name`：查看文件的前10行，适合快速预览文件开头内容。
- `tail -n 10 file_name`：查看文件的最后10行，常用于查看日志文件的最新内容。

### 8. 创建文件
```bash
touch file_name
```
用于创建一个空文件，也可以用来更新文件的时间戳。

### 9. 查找文件
```bash
find /path/to/search -name "file_name"
```
- `find /home -type f -name "*.txt"`：查找`/home`目录下所有扩展名为`.txt`的文件。
- `find . -mtime -7`：查找当前目录及其子目录中最近7天内修改过的文件。

## 二、系统管理

### 1. 查看系统信息
```bash
uname -a
```
显示系统的内核名称、主机名、内核版本、硬件架构等详细信息。
- `uname -s`：仅显示内核名称。
- `uname -n`：仅显示主机名。

### 2. 查看磁盘使用情况
```bash
df -h
```
- `-h`：以人类可读的格式显示磁盘空间，如GB、MB，方便理解磁盘使用状况。

### 3. 查看文件系统详细信息
```bash
df -i
```
显示文件系统的inode（索引节点）使用情况，了解磁盘上文件和目录的存储结构。

### 4. 查看内存使用情况
```bash
free -h
```
- `-h`：以人类可读的格式显示内存使用情况，包括物理内存、交换内存（虚拟内存）等。

### 5. 查看CPU信息
```bash
lscpu
```
提供CPU的架构、内核数量、CPU速度等详细信息，了解系统的计算能力。

### 6. 查看已安装的软件包
```bash
dpkg -l  # Debian/Ubuntu系统
rpm -qa  # Red Hat/CentOS系统
```
列出系统中已安装的所有软件包，方便进行软件管理。

### 7. 更新系统
```bash
apt update && apt upgrade -y  # Debian/Ubuntu系统
yum update -y  # Red Hat/CentOS系统
```
更新系统软件包，确保系统的安全性和功能的完整性。

### 8. 安装软件包
```bash
apt install package_name  # Debian/Ubuntu系统
yum install package_name  # Red Hat/CentOS系统
```
安装指定的软件包，扩展系统的功能。

### 9. 卸载软件包
```bash
apt remove package_name  # Debian/Ubuntu系统
yum remove package_name  # Red Hat/CentOS系统
```
卸载不需要的软件包，释放系统资源。

## 三、网络管理

### 1. 查看网络接口信息
```bash
ifconfig
```
- 或使用`ip addr show`，显示网络接口的IP地址、MAC地址、子网掩码等详细信息。

### 2. 查看路由表
```bash
route -n
```
- 或使用`ip route show`，查看系统的路由表，了解数据包的转发路径。

### 3. 测试网络连通性
```bash
ping google.com
```
- `-c 4`：发送4个ICMP请求后停止，测试网络的连通性和延迟。

### 4. 查看端口占用情况
```bash
netstat -tuln
```
- `-t`：显示TCP端口
- `-u`：显示UDP端口
- `-l`：显示监听中的端口
- `-n`：以数字形式显示端口号和IP地址，不进行域名解析。

### 5. 端口扫描
```bash
nmap -p 1-65535 localhost
```
扫描本地主机的所有端口，查看哪些端口是开放的。

### 6. 测试DNS解析
```bash
nslookup google.com
```
测试域名解析到IP地址的功能，确保网络的DNS配置正确。

### 7. 查看网络连接
```bash
ss -tuln
```
显示当前的网络连接状态，包括监听的端口和服务。

## 四、文本处理

### 1. 搜索文本
```bash
grep "search_term" file_name
```
在指定文件中搜索包含特定关键词的行，支持正则表达式。
- `grep -r "search_term" /path/to/directory`：递归搜索目录中的文件，查找关键词。

### 2. 替换文本
```bash
sed -i 's/old_text/new_text/g' file_name
```
在文件中替换指定的文本内容，`-i`选项表示直接修改文件。

### 3. 统计行数、单词数和字符数
```bash
wc file_name
```
- `wc -l`：统计行数，方便了解文件的长度。
- `wc -w`：统计单词数，用于文本分析。
- `wc -c`：统计字符数，包括空格和换行符。

### 4. 排序
```bash
sort file_name
```
对文件内容进行排序，默认按字母顺序升序排列。
- `sort -n file_name`：按数值排序，适用于数字内容。
- `sort -r file_name`：逆序排序，从大到小排列。

### 5. 去重
```bash
uniq file_name
```
去除文件中重复的行，与`sort`命令结合使用，先排序后去重。

### 6. 提取列
```bash
cut -d "," -f 1 file_name
```
按指定的分隔符提取文件中的列，`-d ","`表示分隔符为逗号，`-f 1`表示提取第一列。

### 7. 合并文件
```bash
cat file1 file2 > merged_file
```
将多个文件合并成一个文件，方便数据整合和处理。

## 五、进程管理

### 1. 查看当前进程
```bash
ps aux
```
列出系统中所有进程的详细信息，包括进程ID、用户、CPU占用率、内存占用率等。
- `ps -ef`：显示所有进程的详细信息，包括父进程ID和进程启动时间。

### 2. 查找特定进程
```bash
pgrep process_name
```
根据进程名称查找对应的进程ID，方便进行进程操作。

### 3. 杀死进程
```bash
kill process_id
```
根据进程ID终止进程，`-9`信号强制终止进程。

### 4. 查看系统负载
```bash
uptime
```
显示系统的运行时间、当前时间、登录用户数和系统负载平均值，了解系统的整体运行状况。

### 5. 查看CPU和内存使用情况
```bash
top
```
实时显示系统中各个进程的资源使用情况，包括CPU占用率、内存占用率、进程状态等。按`q`键退出。

### 6. 设置进程优先级
```bash
renice -n 10 process_id
```
调整进程的优先级，数值越大优先级越低，影响进程对系统资源的占用。

## 六、权限管理

### 1. 查看文件权限
```bash
ls -l file_name
```
- 文件权限以`rwx`的形式显示，分别表示读、写、执行权限，针对用户、组和其他用户。

### 2. 修改文件权限
```bash
chmod 755 file_name
```
通过八进制数字或符号方式修改文件权限，`755`表示用户有读写执行权限，组和其他用户有读执行权限。

### 3. 修改文件所有者
```bash
chown user:group file_name
```
将文件的所有者修改为指定的用户和组，方便进行权限管理。

### 4. 修改文件所属组
```bash
chgrp group file_name
```
仅修改文件所属的用户组。

## 七、压缩和解压缩

### 1. 压缩文件
```bash
tar -cvf archive.tar file_name
```
- `-c`：创建归档文件
- `-v`：显示详细信息
- `-f`：指定归档文件名
- `tar -czvf archive.tar.gz file_name`：压缩为`.gz`格式，减小文件体积。
- `tar -cJvf archive.tar.xz file_name`：压缩为`.xz`格式，提供更好的压缩率。

### 2. 解压缩文件
```bash
tar -xvf archive.tar
```
- `-x`：解压归档文件
- `tar -xzvf archive.tar.gz`：解压`.gz`格式的文件。
- `tar -xJvf archive.tar.xz`：解压`.xz`格式的文件。

### 3. 压缩目录
```bash
tar -czvf archive.tar.gz directory_name
```
将整个目录及其内容压缩为一个文件，方便存储和传输。

### 4. 解压缩目录
```bash
tar -xzvf archive.tar.gz -C /target/directory
```
指定解压缩后文件的存储路径。

## 八、计划任务

### 1. 查看当前用户的计划任务
```bash
crontab -l
```
列出当前用户设置的所有计划任务。

### 2. 编辑计划任务
```bash
crontab -e
```
使用默认的文本编辑器（如`vi`）打开计划任务文件，添加或修改任务。

### 3. 添加计划任务
```bash
# 每天凌晨2点执行脚本
0 2 * * * /path/to/script.sh
```
按照`分 时 日 月 周`的格式设置任务的执行时间。

### 4. 删除计划任务
```bash
crontab -e  # 删除特定任务
crontab -r  # 删除所有任务
```

## 九、用户和组管理

### 1. 添加用户
```bash
useradd username
```
创建新用户，指定用户名。
- `useradd -m username`：同时创建用户的主目录。

### 2. 删除用户
```bash
userdel username
```
删除用户，如果需要删除用户的主目录，使用`-r`选项。

### 3. 添加组
```bash
groupadd groupname
```
创建新组，用于管理用户权限。

### 4. 删除组
```bash
groupdel groupname
```
删除不再需要的组。

### 5. 修改用户密码
```bash
passwd username
```
为指定用户设置或修改密码。

### 6. 切换用户
```bash
su - username
```
切换到其他用户身份，`-`表示同时切换用户的环境变量和工作目录。

## 十、日志管理

### 1. 查看系统日志
```bash
journalctl -b
```
- `-b`：显示当前启动的日志。
- `-u service_name`：查看特定服务的日志，例如`-u apache2`。

### 2. 查看特定服务日志
```bash
journalctl -u apache2
```
定位到特定服务的日志文件，快速排查服务问题。

### 3. 实时查看日志
```bash
tail -f /var/log/syslog
```
实时跟踪日志文件的更新，了解系统的动态变化。

### 4. 清除日志
```bash
journalctl --vacuum-time=1d  # 清除1天前的日志
```
清理过期的日志文件，释放存储空间。

## 十一、其他实用命令

### 1. 别名设置
```bash
alias ll='ls -l'
```
为常用命令设置别名，简化输入，提高效率。

### 2. 查看命令历史
```bash
history
```
显示之前执行过的命令历史记录，方便回顾和再次执行。

### 3. 清屏
```bash
clear
```
清除终端屏幕上的内容，保持界面整洁。

### 4. 查看当前路径
```bash
pwd
```
显示当前工作目录的完整路径，帮助确认位置。

### 5. 查看环境变量
```bash
env
```
列出所有的环境变量，了解系统的配置信息。

### 6. 设置环境变量
```bash
export VARIABLE_NAME=value
```
为特定变量赋值，可以在脚本或特定会话中使用。

### 7. 比较文件
```bash
diff file1 file2
```
比较两个文件的差异，标记出不同之处。

### 8. 计算文件校验和
```bash
md5sum file_name
```
生成文件的MD5校验和，用于验证文件的完整性和一致性。

### 9. 查看命令帮助
```bash
man command_name
```
查看命令的手册页，获取详细的使用说明和选项。

### 10. 查看命令版本
```bash
command_name --version
```
了解软件的版本信息，确保使用的工具符合项目要求。

## 总结
Linux系统提供了丰富多样的命令工具，帮助我们高效地完成各种任务。通过熟练掌握这些常用代码，不仅可以提高工作效率，还能更好地管理和维护系统。希望本文整理的内容对你有所帮助，让你在Linux世界中游刃有余。如果对某些命令还有疑问，可以随时查阅相关资料或在评论区与我互动交流，我会尽力为你解答！