---
title: git 使用记录
categories: 知识充电
tags: [技术笔记,git]
date: 2023-11-06 15:38:03
id: 0043
---

## Git本地仓库设置与操作指南
#### 1. 设置Git本地仓库

* **选择一个目录作为本地仓库**：首先，确定一个目录作为你的本地Git仓库。
* **进入该目录**：打开终端或命令行界面，并导航到所选目录。
* **初始化本地仓库**：在该目录下运行`git init`命令来初始化一个新的Git仓库。
```
git init
```
这会在当前目录下创建一个隐藏的.git目录,用来跟踪版本信息。
#### 2. 设置用户信息（可选）

在开始使用Git之前，你可以设置你的姓名和电子邮件地址，这些信息将会与你的提交记录关联。


```bash
git config user.name "Your Name"
git config user.email "email@example.com"
```
#### 3. 添加文件到版本控制

* 使用`git add`命令将文件添加到暂存区。
```bash
git add file1 file2 
```
或者添加所有文件:
```bash
git add .
```
#### 4. 提交文件到本地仓库

* 使用`git commit`命令提交暂存区的更改到本地仓库，并添加提交信息。
```bash
git commit -m "first commit"
```
#### 5. 查看仓库状态和历史记录

* 使用`git status`命令查看当前仓库的状态。
```
git status
```
* 使用`git log`命令查看提交历史记录。
```bash 
git log
```
#### 6. 关联远程仓库

* 使用`git remote add`命令关联一个远程仓库。


```bash
git remote add origin <远程仓库URL>
```
例如：

```bash 
git remote add origin https://github.com/clarance2018/blog.git
``` 
#### 7. 推送文件到远程仓库

* 使用`git push`命令将本地仓库的更改推送到远程仓库。


```bash
git push origin <分支名>
```
当你完成了在本地的工作并想要将更改推送到远程仓库时，可以使用git push命令。要推送当前分支的更改，可以运行以下命令：

```bash 
git remote add origin https://github.com/clarance2018/blog.git
``` 
如果你想推送所有分支的更改，可以运行git push -u origin all。
#### 8. 从远程仓库拉取更新

* 使用`git pull`命令从远程仓库拉取最新的更改并合并到本地仓库。


```bash
git pull origin <分支名>
```

## Git分支管理中有哪些常见操作？
在Git中，分支是一个非常重要的功能，它允许你创建一个独立的开发线（称为“分支”），以便进行实验或开发新功能。Git分支管理中常见的操作包括：

### 查看分支
使用 `git branch` 命令可以查看当前仓库的所有分支。如果想要查看包含远程分支的完整列表，可以使用 `git branch -a` 命令。
### 创建分支
使用 `git branch` 命令加上新分支的名称可以创建一个新的分支。例如，`git branch new_branch` 会在当前提交上创建一个名为 `new_branch` 的新分支。
### 切换分支
使用 `git checkout` 命令加上分支名称可以切换到另一个分支。例如，`git checkout new_branch` 会将当前工作目录切换到 `new_branch` 分支。
### 合并分支
使用 `git merge` 命令可以将一个分支的更改合并到当前分支。例如，`git merge feature_branch` 会将 `feature_branch` 分支的更改合并到当前分支。
### 删除分支
删除Git本地和远程分支的步骤:

#### 查看
当前所有本地分支:
```bash 
git branch
``` 
远程分支:
```bash 
git branch -r
``` 
#### 删除
本地分支:
```bash 
git branch -d <branch name>
``` 
例如:
```bash 
git branch -d feature-branch
``` 
远程分支:
```bash 
git push origin --delete <branch name> 
``` 
例如:
```bash 
git push origin --delete feature-branch
``` 
#### 强制删除
本地分支(包含未合并的commit):
```bash 
git branch -D <branch name>
``` 
远程分支:
```bash 
git push origin :<branch name>
``` 
#### 删除本地和远程同时进行
```bash 
git branch -d <branch name> 
git push origin --delete <branch name>
``` 
删除分支后,如果分支代码还需要,可以使用git branch <new branch name> <branch name>命令重新建立分支。
### 创建并切换分支
使用 `git checkout -b` 命令加上新分支的名称可以创建一个新分支并立即切换到该分支。这通常是开始新特性或修复bug时的常用操作。
### 分支重命名
使用 `git branch -m` 命令可以重命名当前分支。例如，`git branch -m new_name` 会将当前分支重命名为 `new_name`。
### 查看分支差异
使用 `git show-branch` 命令可以查看不同分支之间的差异。
### 追踪远程分支
使用 `git branch --set-upstream-to` 命令可以设置本地分支追踪远程分支，以便在执行 `git pull` 或 `git push` 时知道与哪个远程分支进行交互。
### 推送和拉取分支
使用 `git push` 命令可以将本地分支推送到远程仓库，而 `git pull` 命令则可以从远程仓库拉取分支的更新。

这些操作是Git分支管理中常见的任务，它们帮助开发者在项目中并行工作，保持代码的整洁和可维护性。

**注意**：在执行任何Git命令之前，请确保你已经在正确的目录下，并且了解每个命令的作用和可能的影响。







## 将仓库克隆到非空目录处理方案

错误信息表明，您尝试将仓库克隆到名为`my_blog`的目录，但该目录已经存在，并且不是空目录。Git不允许您将仓库克隆到已存在且非空的目录中，因为这可能会导致数据丢失或覆盖。

要解决这个问题，您可以采取以下几种方法之一：

1. **删除已存在的目录**：
   如果`my_blog`目录中的内容不重要，或者您可以安全地删除它，您可以使用`rm -rf`命令来删除整个目录。请确保在执行此操作前备份任何重要数据。

   ```bash
   rm -rf my_blog
   git clone ssh://git@github.com/clarance2018/blog.git my_blog
   ```

2. **使用不同的目录名**：
   如果您不想删除现有的`my_blog`目录，您可以尝试将仓库克隆到一个不同的目录中。

   ```bash
   git clone ssh://git@github.com/clarance2018/blog.git my_blog_new
   ```

3. **清空已存在的目录**：
   如果您想保留`my_blog`目录，但想要清空其内容以便克隆新仓库，您可以使用以下命令：

   ```bash
   rm -rf my_blog/*
   git clone ssh://git@github.com/clarance2018/blog.git my_blog
   ```

   这将删除`my_blog`目录下的所有文件和子目录，但不会删除`my_blog`目录本身。

4. **检查仓库URL**：
   在尝试克隆之前，请确保仓库的URL是正确的。虽然您提供的URL看起来是正确的，但总是好的习惯再次确认。

请注意，使用`rm -rf`命令时要格外小心，因为它会无条件地删除文件和目录，且不会询问确认。确保您指定的路径是正确的，以避免不必要的数据丢失。

## 服务器拉取仓库更新

要拉取线上的更新，您可以按照以下步骤进行操作：

1. 首先，确保您已经在本地仓库的目录中。您可以使用`cd`命令切换到该目录。

2. 使用`git fetch`命令从远程仓库获取最新的代码和分支信息。这将从远程仓库拉取更新，但不会自动合并到您的本地分支。

   ```bash
   git fetch origin
   ```

   这里的`origin`通常是远程仓库的别名，它应该在您之前执行`git clone`命令时自动设置。

3. 检查远程仓库的更新情况。使用`git log`命令可以查看本地和远程仓库的提交历史记录，以便了解有哪些更新。

   ```bash
   git log origin/master..master
   ```

   上面的命令将显示本地`master`分支上尚未合并到远程`master`分支的提交。

4. 如果您想要将远程仓库的更新合并到您的本地分支，可以使用`git merge`命令。在合并之前，请确保您当前的工作目录是干净的，即没有未提交的更改。

   ```bash
   git merge origin/master
   ```

   这将合并远程`master`分支到您的当前本地分支。

5. 如果在合并过程中出现冲突，您需要手动解决冲突并提交更改。使用`git status`查看冲突文件，编辑文件解决冲突，然后使用`git add`将解决后的文件标记为已解决状态，并使用`git commit`提交更改。

   ```bash
   git status
   git add <conflicted_file>
   git commit -m "Resolve merge conflicts"
   ```

6. 最后，如果您想要将本地仓库的更改推送到远程仓库，可以使用`git push`命令。

   ```bash
   git push origin master
   ```
这将把您的本地`master`分支的更改推送到远程仓库的`master`分支。

请注意，上述步骤中的`master`分支应替换为您实际使用的分支名称。如果您在使用其他分支进行开发，请相应地更改分支名称。

此外，如果您只想拉取远程仓库的更新并覆盖本地的更改，您可以使用`git reset`和`git pull`命令组合。

   ```bash
   git fetch origin
   git reset --hard origin/master
   git pull origin master
   ```

这将重置您的本地分支到远程`master`分支的状态，并拉取最新的代码。但是，请注意，这将丢弃您本地的所有未提交的更改，因此请确保您已经备份或保存了重要的更改。
















