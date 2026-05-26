---
title: 多功能文本工具
date: 2025-03-30 15:57:51
description: 财务金额大写转换、字符级文本比较以及字符计数、字数、段落、句子计数等统计功能
top_img: 
background: "#f8f9fe"
comments: false
---



<link rel="stylesheet" href="/css_js/tailwind.min.css">
    <style>
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .diff-add {
            background-color: #e6ffed;
            text-decoration: none;
            color: #22863a;
        }
        .diff-remove {
            background-color: #ffeef0;
            text-decoration: line-through;
            color: #cb2431;
        }
        textarea {
            resize: vertical;
        }
        .counter-result {
            transition: all 0.3s;
        }
        @media print {
            .no-print {
                display: none;
            }
        }
    </style>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8 max-w-6xl">
        <header class="mb-8">
            <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">多功能文本工具</h1>
            <div class="flex justify-center mb-4 no-print">
                <nav class="bg-white rounded-lg shadow-md inline-flex">
                    <button id="tab-counter" class="tab-btn px-6 py-3 font-medium rounded-lg text-gray-700 hover:bg-gray-100 focus:outline-none transition active">字符计数器</button>
                    <button id="tab-compare" class="tab-btn px-6 py-3 font-medium rounded-lg text-gray-700 hover:bg-gray-100 focus:outline-none transition">文本比较</button>
                    <button id="tab-amount" class="tab-btn px-6 py-3 font-medium rounded-lg text-gray-700 hover:bg-gray-100 focus:outline-none transition">金额大写转换</button>
                </nav>
            </div>
        </header>        
        <section id="counter-section" class="tab-content active bg-white rounded-lg shadow-md p-6 mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-gray-800">字符计数器</h2>
            <div class="mb-6">
                <textarea id="counter-input" class="w-full h-64 p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="在此处键入文字，或复制并粘贴文本..."></textarea>
            </div>            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h3 class="text-lg font-medium mb-3 text-gray-700">基本统计</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">字符数</div>
                            <div id="char-count" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">单词数</div>
                            <div id="word-count" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">段落数</div>
                            <div id="paragraph-count" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">句子数</div>
                            <div id="sentence-count" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                    </div>
                </div>                
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h3 class="text-lg font-medium mb-3 text-gray-700">其他信息</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">不含空格的字符数</div>
                            <div id="char-no-space" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">独特单词数</div>
                            <div id="unique-words" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">阅读时间(分钟)</div>
                            <div id="read-time" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                        <div class="bg-white p-3 rounded shadow-sm">
                            <div class="text-sm text-gray-600">演讲时间(分钟)</div>
                            <div id="speech-time" class="counter-result text-xl font-bold text-blue-600">0</div>
                        </div>
                    </div>
                </div>
            </div>            
            <div class="bg-blue-50 p-5 rounded-lg">
                <h3 class="text-lg font-medium mb-3 text-blue-800">常见问题</h3>
                <div class="space-y-4">
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">什么是字符数？</summary>
                        <p class="mt-2 text-gray-700">虽然有人认为字符数是字母总数，但实际上它是所有字符的总数，包含空格。当文本有字符限制时，就需要统计字符数。此外，有些翻译人员按不计空格的字符数来确定翻译价格。</p>
                    </details>
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">单词数和字符数有何区别？</summary>
                        <p class="mt-2 text-gray-700">单词数是文本中的单词数量，而字符数是文本中的字符数量。如要计算文本中的字符数，需要将所有字符（包括特殊字符）计算在内。</p>
                    </details>
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">各大社交网络的字符限制如何？</summary>
                        <p class="mt-2 text-gray-700">以下是各大社交网络的字符限制：</p>
                        <ul class="list-disc list-inside mt-1 text-gray-700">
                            <li>Facebook：每帖63206个字符</li>
                            <li>Instagram：每段说明2200个字符</li>
                            <li>Twitter：每条推特280个字符</li>
                            <li>YouTube：视频标题70个字符，视频描述5000个字符</li>
                            <li>Twitch：每条150个字符</li>
                        </ul>
                    </details>
                </div>
            </div>
        </section>
        <!-- 文本比较 -->
        <section id="compare-section" class="tab-content bg-white rounded-lg shadow-md p-6 mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-gray-800">文本比较</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div>
                    <label class="block text-gray-700 mb-2 font-medium">原始文本</label>
                    <textarea id="text-original" class="w-full h-64 p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="在此处粘贴原始文本..."></textarea>
                </div>
                <div>
                    <label class="block text-gray-700 mb-2 font-medium">修改后文本</label>
                    <textarea id="text-modified" class="w-full h-64 p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="在此处粘贴修改后的文本..."></textarea>
                </div>
            </div>            
            <div class="mb-6 flex justify-center">
                <button id="compare-btn" class="px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">比较文本</button>
            </div>            
            <div id="diff-result" class="bg-gray-50 p-5 rounded-lg mb-6 hidden whitespace-pre-wrap"></div>            
            <div class="bg-blue-50 p-5 rounded-lg">
                <h3 class="text-lg font-medium mb-3 text-blue-800">使用指南</h3>
                <div class="space-y-4">
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">什么是文本比较？</summary>
                        <p class="mt-2 text-gray-700">文本比较是一种找出两个文本之间差异的方法。这个工具使用字符级比较算法，能精确显示哪些字符被添加、删除或修改，帮助您快速识别文档的变化。</p>
                    </details>
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">如何使用在线文本比较工具？</summary>
                        <p class="mt-2 text-gray-700">使用方法非常简单：</p>
                        <ol class="list-decimal list-inside mt-1 text-gray-700">
                            <li>在左侧文本框中粘贴原始文本</li>
                            <li>在右侧文本框中粘贴修改后的文本</li>
                            <li>点击"比较文本"按钮</li>
                            <li>查看下方显示的差异结果，绿色表示添加的内容，红色表示删除的内容</li>
                        </ol>
                    </details>
                </div>
            </div>
        </section>
        <!-- 金额大写转换 -->
        <section id="amount-section" class="tab-content bg-white rounded-lg shadow-md p-6 mb-8">
            <h2 class="text-2xl font-semibold mb-4 text-gray-800">财务金额大写转换</h2>
            <div class="mb-6">
                <label class="block text-gray-700 mb-2 font-medium">数字金额</label>
                <input type="text" id="amount-input" class="w-full p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="请输入数字金额，如：1234.56">
            </div>            
            <div class="mb-6 flex justify-center">
                <button id="convert-btn" class="px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 transition">转换为大写</button>
            </div>            
            <div id="amount-result" class="bg-gray-50 p-5 rounded-lg mb-6 hidden">
                <h3 class="text-lg font-medium mb-2 text-gray-700">转换结果</h3>
                <div id="amount-uppercase" class="p-4 bg-white rounded border border-gray-300 text-xl font-bold text-blue-600"></div>
            </div>            
            <div class="bg-blue-50 p-5 rounded-lg">
                <h3 class="text-lg font-medium mb-3 text-blue-800">使用说明</h3>
                <div class="space-y-4">
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">什么是财务金额大写转换？</summary>
                        <p class="mt-2 text-gray-700">财务金额大写转换是将阿拉伯数字表示的金额转换为中文大写金额的过程。在合同、财务报表等正式文件中，通常需要用中文大写表示金额，以防止篡改和确保金额清晰无误。</p>
                    </details>
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">如何使用金额大写转换工具？</summary>
                        <p class="mt-2 text-gray-700">使用方法很简单：</p>
                        <ol class="list-decimal list-inside mt-1 text-gray-700">
                            <li>在输入框中输入阿拉伯数字金额（如：1234.56）</li>
                            <li>点击"转换为大写"按钮</li>
                            <li>查看转换后的中文大写金额结果</li>
                        </ol>
                    </details>
                    <details class="bg-white p-3 rounded shadow-sm">
                        <summary class="font-medium text-blue-700 cursor-pointer">支持什么格式的金额输入？</summary>
                        <p class="mt-2 text-gray-700">本工具支持：</p>
                        <ul class="list-disc list-inside mt-1 text-gray-700">
                            <li>整数金额（如：1234）</li>
                            <li>带小数点的金额（如：1234.56）</li>
                            <li>最大支持16位数的金额转换</li>
                        </ul>
                    </details>
                </div>
            </div>
        </section>
        <footer class="text-center text-gray-600 mt-8 text-sm">
            <p>© 2025 多功能文本工具 | 一站式文本处理解决方案</p>
        </footer>
    </div>
    <script>
        // 标签切换功能
        document.addEventListener('DOMContentLoaded', function() {
            const tabs = document.querySelectorAll('.tab-btn');
            const contents = document.querySelectorAll('.tab-content');            
            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    // 移除所有活动状态
                    tabs.forEach(t => t.classList.remove('active', 'bg-blue-500', 'text-white'));
                    contents.forEach(c => c.classList.remove('active'));                    
                    // 添加活动状态
                    tab.classList.add('active', 'bg-blue-500', 'text-white');                    
                    // 显示对应内容
                    const target = tab.id.replace('tab-', '');
                    document.getElementById(`${target}-section`).classList.add('active');
                });
            });            
            // 字符计数器功能
            const counterInput = document.getElementById('counter-input');            
            function updateCounts() {
                const text = counterInput.value;                
                // 基本计数
                document.getElementById('char-count').textContent = text.length;
                document.getElementById('char-no-space').textContent = text.replace(/\s/g, '').length;                
                // 单词计数 (支持中英文)
                const words = text.trim().split(/\s+/).filter(word => word.length > 0);
                document.getElementById('word-count').textContent = words.length;                
                // 独特单词
                const uniqueWords = new Set(words.map(w => w.toLowerCase()));
                document.getElementById('unique-words').textContent = uniqueWords.size;                
                // 段落计数
                const paragraphs = text.split(/\n+/).filter(p => p.trim().length > 0);
                document.getElementById('paragraph-count').textContent = paragraphs.length;                
                // 句子计数 (支持中英文)
                const sentences = text.split(/[.!?。！？]+\s*/).filter(s => s.trim().length > 0);
                document.getElementById('sentence-count').textContent = sentences.length;                
                // 阅读时间 (假设平均阅读速度为每分钟250个单词)
                const readTime = Math.max(1, Math.ceil(words.length / 250));
                document.getElementById('read-time').textContent = readTime;                
                // 演讲时间 (假设平均演讲速度为每分钟130个单词)
                const speechTime = Math.max(1, Math.ceil(words.length / 130));
                document.getElementById('speech-time').textContent = speechTime;
            }            
            counterInput.addEventListener('input', updateCounts);            
            // 文本比较功能
            const compareBtn = document.getElementById('compare-btn');
            const textOriginal = document.getElementById('text-original');
            const textModified = document.getElementById('text-modified');
            const diffResult = document.getElementById('diff-result');            
            // 字符级差异比较实现
            function diffChars(oldText, newText) {
                if (oldText === newText) return newText;                
                const diffResult = [];
                let i = 0, j = 0;                
                // 寻找最长公共子序列
                const lcs = findLCS(oldText, newText);                
                while (i < oldText.length || j < newText.length) {
                    // 如果两字符匹配，则添加共同字符
                    if (i < oldText.length && j < newText.length && oldText[i] === newText[j] && lcs.includes(oldText[i])) {
                        diffResult.push(oldText[i]);
                        i++;
                        j++;
                    } 
                    // 否则，处理添加或删除
                    else {
                        // 探测前向匹配
                        let foundMatch = false;                        
                        // 检查是否有添加的字符
                        if (j < newText.length) {
                            diffResult.push(`<span class="diff-add">${newText[j]}</span>`);
                            j++;
                            foundMatch = true;
                        }                        
                        // 检查是否有删除的字符
                        if (i < oldText.length) {
                            diffResult.push(`<span class="diff-remove">${oldText[i]}</span>`);
                            i++;
                            foundMatch = true;
                        }                        
                        if (!foundMatch) break;
                    }
                }                
                return diffResult.join('');
            }            
            // 寻找最长公共子序列 (LCS)
            function findLCS(text1, text2) {
                const m = text1.length;
                const n = text2.length;
                const dp = Array(m + 1).fill().map(() => Array(n + 1).fill(0));                
                // 填充DP表
                for (let i = 1; i <= m; i++) {
                    for (let j = 1; j <= n; j++) {
                        if (text1[i - 1] === text2[j - 1]) {
                            dp[i][j] = dp[i - 1][j - 1] + 1;
                        } else {
                            dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                        }
                    }
                }                
                // 反向构建LCS
                let lcs = '';
                let i = m, j = n;
                while (i > 0 && j > 0) {
                    if (text1[i - 1] === text2[j - 1]) {
                        lcs = text1[i - 1] + lcs;
                        i--;
                        j--;
                    } else if (dp[i - 1][j] > dp[i][j - 1]) {
                        i--;
                    } else {
                        j--;
                    }
                }                
                return lcs;
            }            
            compareBtn.addEventListener('click', () => {
                const original = textOriginal.value;
                const modified = textModified.value;                
                if (!original && !modified) {
                    alert('请输入需要比较的文本');
                    return;
                }                
                // 分行处理，对每行进行字符级比较
                const originalLines = original.split('\n');
                const modifiedLines = modified.split('\n');                
                // 使用简化的行级比较来匹配行
                const lineResults = [];                
                // 如果行数不同，使用更复杂的行级比较
                if (originalLines.length !== modifiedLines.length) {
                    // 字符级的完整文本比较
                    lineResults.push(diffChars(original, modified));
                } else {
                    // 行数相同时，逐行进行字符级比较
                    for (let i = 0; i < originalLines.length; i++) {
                        lineResults.push(diffChars(originalLines[i], modifiedLines[i]));
                    }
                }                
                diffResult.innerHTML = lineResults.join('<br>');
                diffResult.classList.remove('hidden');
            });            
            // 金额大写转换功能
            const convertBtn = document.getElementById('convert-btn');
            const amountInput = document.getElementById('amount-input');
            const amountResult = document.getElementById('amount-result');
            const amountUppercase = document.getElementById('amount-uppercase');            
            // 数字金额转中文大写函数
            function convertToChineseUppercase(num) {
                if (!/^(0|[1-9]\d*)(\.\d+)?$/.test(num)) {
                    return '请输入有效的金额数字';
                }                
                const cnNums = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];
                const cnIntRadice = ['', '拾', '佰', '仟'];
                const cnIntUnits = ['', '万', '亿', '兆'];
                const cnDecUnits = ['角', '分', '厘', '毫'];
                const cnInteger = '整';
                const cnIntLast = '元';
                // 分离整数部分和小数部分
                const parts = num.toString().split('.');
                const integerNum = parts[0];
                const decimalNum = parts[1] || '';                
                // 处理整数部分
                let chineseStr = '';
                if (parseInt(integerNum, 10) > 0) {
                    let zeroCount = 0;
                    for (let i = 0; i < integerNum.length; i++) {
                        const n = parseInt(integerNum.charAt(i), 10);
                        const p = integerNum.length - i - 1;
                        const q = p / 4;
                        const m = p % 4;                        
                        if (n === 0) {
                            zeroCount++;
                        } else {
                            if (zeroCount > 0) {
                                chineseStr += cnNums[0];
                            }
                            zeroCount = 0;
                            chineseStr += cnNums[n] + cnIntRadice[m];
                        }                        
                        if (m === 0 && zeroCount < 4) {
                            chineseStr += cnIntUnits[q];
                        }
                    }
                    chineseStr += cnIntLast;
                }                
                // 处理小数部分
                if (decimalNum) {
                    for (let i = 0; i < decimalNum.length; i++) {
                        const n = parseInt(decimalNum.charAt(i), 10);
                        if (n !== 0) {
                            chineseStr += cnNums[n] + cnDecUnits[i];
                        }
                    }
                }                
                // 如果没有小数部分或小数部分全为0，则添加"整"
                if (!decimalNum || decimalNum.replace(/0/g, '').length === 0) {
                    chineseStr += cnInteger;
                }                
                // 如果金额为0，返回"零元整"
                if (parseInt(integerNum, 10) === 0 && (decimalNum === '' || parseInt(decimalNum, 10) === 0)) {
                    return '零元整';
                }                
                return chineseStr;
            }            
            convertBtn.addEventListener('click', () => {
                const amount = amountInput.value.trim();                
                if (!amount) {
                    alert('请输入金额');
                    return;
                }                
                const result = convertToChineseUppercase(amount);
                amountUppercase.textContent = result;
                amountResult.classList.remove('hidden');
            });            
            // 输入限制，只允许数字和小数点
            amountInput.addEventListener('input', function() {
                this.value = this.value.replace(/[^\d.]/g, '');
                // 确保只有一个小数点
                const parts = this.value.split('.');
                if (parts.length > 2) {
                    this.value = parts[0] + '.' + parts.slice(1).join('');
                }
                // 限制小数点后最多4位
                if (parts.length === 2 && parts[1].length > 4) {
                    this.value = parts[0] + '.' + parts[1].substring(0, 4);
                }
            });
        });
    </script>
</body>

