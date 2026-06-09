---
title: 对同文件夹内所有文件进行批量重命名
categories: 效率工具
tags: [技术笔记,记录]
date: 2024-08-09 09:00:34
id: 0080
top_img:
swiper_index: 
cover: 
---

今天将blog内容从服务器打包到自己新弄的黑群里面，准备搭一个本地的玩玩。但是发现一个问题，由于我的post都是中文命名，打包下载解压之后变成了乱码......这就有点难搞！虽然我这边链接规则是使用id,网页的链接展示都没有问题，但是看到这个还是很不习惯，于是就在网上找找有没有什么办法可以批量重命名。

批量重命名文件是一个常见的需求，可以通过多种方法实现，包括使用操作系统自带的工具、第三方软件或编写简单的脚本来完成。以下是一个基于Windows操作系统的简单批量重命名方案，使用命令提示符（CMD）来实现。

### 方案一：使用CMD的`ren`命令

假设你有一个文件夹，里面包含了一系列需要重命名的图片文件，原始文件名是`image1.jpg`, `image2.jpg`, ..., `imageN.jpg`，你想将它们重命名为`photo1.jpg`, `photo2.jpg`, ..., `photoN.jpg`。

1. 打开命令提示符（CMD）。你可以通过在开始菜单搜索“cmd”或“命令提示符”来找到它。

2. 使用`cd`命令切换到包含文件的文件夹。例如，如果文件在`D:\Photos`文件夹中，你应该输入`cd D:\Photos`并回车。

3. 现在，你可以使用`for`循环结合`ren`命令来批量重命名文件。但是，由于CMD的`for`循环在处理文件重命名时有一定的限制（特别是直接修改文件名时），我们通常会采用一种变通的方法，即先生成一个重命名列表，然后逐个执行。不过，为了简化说明，这里提供一个假设你已经知道如何生成或手动指定新文件名的示例：

   ```cmd
   for %i in (1 2 3 4 5) do ren image%i.jpg photo%i.jpg
   ```

   注意：上面的命令直接在命令行中执行时，对于批处理文件（.bat），你需要将`%i`替换为`%%i`。

   如果你有很多文件，手动列出所有数字可能不现实。在这种情况下，你可以考虑编写一个更复杂的批处理脚本来生成这些命令，或者使用其他工具。

### 方案二：使用PowerShell

PowerShell是Windows的一个更强大的命令行工具，它提供了更多的灵活性和功能来处理文件。以下是一个使用PowerShell批量重命名文件的示例：

1. 打开PowerShell。你可以通过在开始菜单搜索“PowerShell”来找到它。

2. 使用`cd`命令切换到包含文件的文件夹，就像你在CMD中做的那样。

3. 执行以下PowerShell命令来批量重命名文件：

   ```powershell
   $i = 1
   Get-ChildItem -Filter 'image*.jpg' | Rename-Item -NewName { "photo$i.jpg" } -WhatIf
   # 注意：上面的命令包含-WhatIf参数，它不会实际执行重命名操作，而是显示将要执行的操作。
   # 如果你确定要执行重命名，请移除-WhatIf参数。

   # 如果你想要递增的编号，可以这样做：
   $i = 1
   Get-ChildItem -Filter 'image*.jpg' | ForEach-Object {
       Rename-Item -Path $_.FullName -NewName ("photo{0:D2}.jpg" -f $i++)
   }
   ```

这个PowerShell脚本会遍历所有以`image`开头、以`.jpg`结尾的文件，并将它们重命名为`photo1.jpg`, `photo2.jpg`等，其中编号是递增的。注意，这里使用了`{0:D2}`来格式化编号，确保编号始终是两位数（例如，`01`, `02`等）。如果你不需要这种格式化，可以简化`Rename-Item`命令中的`-NewName`参数。

### 方案三：同样是使用PowerShell

如果你有一个更复杂重命名需求，你可以通过创建一个新的映射（比如，一个包含旧文件名和新文件名的CSV文件），你可以使用Import-Csv（如果你定义了该函数或使用了支持CSV的模块）或简单地按行读取文件并解析每一行来提取旧文件名和新文件名。

对于CSV文件，设置两列，分别命名为OldName和NewName，如下图

![mappings_csv](/img/2024/mappings.png "mappings_csv")

然后打开PowerShell：


```bash

# 设置你的工作目录（即包含要重命名文件的文件夹）  
$folderPath = "D:\source\_posts" # 注意：这里我假设文件都在_posts文件夹下  
  
# 读取CSV文件以获取文件名映射  
$mappings = Get-Content -Path "D:\source\_posts\mappings.csv" | ConvertFrom-Csv -Delimiter ','  
  
# 遍历映射并执行重命名  
foreach ($mapping in $mappings) {  
    $oldName = $mapping.OldName  
    $newName = $mapping.NewName  
  
    # 构造旧文件的完整路径（确保$folderPath是正确的）  
    $oldFilePath = Join-Path $folderPath $oldName  
  
    # 检查文件是否存在并执行重命名  
    if (Test-Path $oldFilePath) {  
        Rename-Item -Path $oldFilePath -NewName $newName  
        Write-Host "Renamed '$oldName' to '$newName'"  
    } else {  
        Write-Host "Warning: File '$oldFilePath' not found. Please check the file name and path."  
    }  
}
```