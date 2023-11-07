---
title: git 使用记录
categories: 技术笔记
tags: [git]
date: 2023-11-06 15:38:03
id: 0043
---

 ## 设置Git本地仓库的步骤:
 ### 选择一个目录作为本地仓库,进入该目录下:
```
cd path/to/project-folder
```
### 初始化本地仓库:
```
git init
```
这会在当前目录下创建一个隐藏的.git目录,用来跟踪版本信息。
### 添加文件到版本控制:
```
git add file1 file2 
```
或者添加所有文件:
```
git add .
```
### 提交文件到本地仓库: 
```
git commit -m "first commit"
```
### 设置用户信息(可选):
```
git config user.name "Your Name"
git config user.email "email@example.com"
```
### 检查状态:
```
git status
```
### 查看历史记录:
``` 
git log
```
以上步骤就完成了本地仓库的初始化和文件提交。
还可以进一步:
- 关联远程仓库
- 推送文件到远程仓库
- 从远程仓库拉取更新
- 使用分支管理开发
这样就可以在本地对项目进行版本控制了。

使用Git进行版本控制时，关联远程仓库、推送文件到远程仓库、从远程仓库拉取更新以及使用分支管理开发是非常常见的操作。下面是一些基本步骤：

## 关联远程仓库：
在Git中，使用git remote命令来添加和管理远程仓库。要关联一个远程仓库，可以运行以下命令：

``` 
git remote add origin <远程仓库URL>
``` 
将<远程仓库URL>替换为你要关联的远程仓库的URL。例如：

``` 
git remote add origin https://github.com/clarance2018/blog.git
``` 
## 推送文件到远程仓库：
当你完成了在本地的工作并想要将更改推送到远程仓库时，可以使用git push命令。要推送当前分支的更改，可以运行以下命令：

``` 
git push origin <分支名>
``` 
如果你想推送所有分支的更改，可以运行git push -u origin all。
## 从远程仓库拉取更新：
如果你想从远程仓库获取最新的更改并合并到你的本地仓库，可以使用git pull命令。要拉取特定分支的更新，可以运行以下命令：

``` 
git pull origin <分支名>
``` 
这将会自动合并远程仓库的指定分支到你的本地分支。
## 使用分支管理开发：
在Git中，分支是一个非常重要的功能，它允许你创建一个独立的开发线（称为“分支”），以便进行实验或开发新功能。当你创建一个新分支时，你实际上是在创建一个指向同一个提交的指针。要创建一个新分支，可以运行以下命令：

``` 
git branch <新分支名>
``` 
要切换到新分支，可以使用git checkout命令：

``` 
git checkout <新分支名>
``` 
当你完成了一个新功能或修复了一个问题后，可以将更改合并到主分支（通常称为master或main）。首先，你需要切换到主分支：

``` 
git checkout master
``` 
然后，你可以使用git merge命令将你的分支合并到主分支：

``` 
git merge <新分支名>
``` 
这将把新分支的更改合并到主分支上。完成后，你可以将主分支的更改推送到远程仓库。


## 删除Git本地和远程分支的步骤:

### 删除本地分支

查看当前所有本地分支:
``` 
git branch
``` 
删除本地分支:
``` 
git branch -d <branch name>
``` 
例如:
``` 
git branch -d feature-branch
``` 
强制删除本地分支(包含未合并的commit):
``` 
git branch -D <branch name>
``` 
### 删除远程分支

查看所有远程分支:
``` 
git branch -r
``` 
删除远程分支:
``` 
git push origin --delete <branch name> 
``` 
例如:
``` 
git push origin --delete feature-branch
``` 
强制删除远程分支:
``` 
git push origin :<branch name>
``` 
删除本地和远程同时进行
``` 
git branch -d <branch name> 
git push origin --delete <branch name>
``` 
删除分支后,如果分支代码还需要,可以使用git branch <new branch name> <branch name>命令重新建立分支。

这就是删除Git本地和远程分支的基本命令,希望对你有帮助!