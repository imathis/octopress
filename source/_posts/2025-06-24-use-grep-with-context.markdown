---
layout: post
title: "使用 grep 查找关键字并显示上下文行"
date: 2025-06-24 10:30
comments: true
categories: Linux Shell grep 
---

## 背景

排查日志时，常需要定位关键字并带上一两行上下文确认语义。`grep` 内建的上下文选项可以直接满足需求，不必再手动 `sed -n '19,21p'`。

<!--more-->

## 快速示例

假设想在 `app.log` 中找出包含 `Fatal error` 的行，并且同时看到上一行与下一行：

```bash
grep -n -C 1 "Fatal error" app.log
```

- `-n` 会显示行号，便于定位。
- `-C 1` 等价于 `--context=1`，表示向前向后各多带 1 行。想多看几行时调整数字即可。

输出中，命中的行以冒号分隔行号与内容，上下文行则以短横线 `-` 连接，快速区分重点。

## 控制上下文范围

`grep` 提供三个粒度化参数：

- `-C <N>`：两侧各 N 行，是最常用的形式。
- `-B <N>`：只带前 N 行（Before）。
- `-A <N>`：只带后 N 行（After）。

例如只关心关键字后面的调用栈，可使用：

```bash
grep -n -A 4 "NullPointerException" stacktrace.txt
```

再配合 `-m 1`（匹配一次后退出）可以缩短复杂日志的搜索时间。

## 与常见参数组合

- `-i`：忽略大小写，处理大小写不一致的告警信息很方便。
- `-E`：启用扩展正则，可直接写 `grep -E "(WARN|ERROR)"`。
- `--color=auto`：高亮命中关键字，在终端阅读更直观。

将这些参数组合成 Shell 函数，后续排查直接调用。例如在 `~/.bashrc` 中定义：

```bash
gctx() {
  local keyword="$1" file="$2" lines="${3:-1}"
  grep -n --color=always -C "$lines" "$keyword" "$file"
}
```

执行 `gctx "timeout" service.log 2`，即可得到行号、关键字高亮、上下文行的结果。

## 小结

- `-C/-A/-B` 是获取上下文的核心选项，记住数字表示行数即可。
- 搭配 `-n`、`--color`、`-m` 等参数可以提升排查效率。
- 如果命中结果过多，将命令与 `less -R` 或 `fzf` 管道组合，能够在终端中进行二次筛选，让排查体验更顺滑。
