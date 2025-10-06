# Claude Code StatusLine：打造你的专属状态栏

## 写在前面

用过 Claude Code 的同学应该都注意到了，界面底部有一个状态栏，默认显示着模型名称、目录之类的信息。但你有没有想过：

- "这个状态栏能不能显示我想看的信息？"
- "能不能显示 Git 分支？当前 Context 使用情况？"
- "这玩意儿怎么自定义啊？"

如果你也有这些疑问，那今天这篇文章就是为你准备的。咱们来聊聊 Claude Code 的 StatusLine 配置，看看怎么把它改造成你最顺手的工具。

## StatusLine 是什么

先说结论：**StatusLine 就是 Claude Code 界面底部的状态栏，类似于 VS Code 的状态栏，或者 Zsh 的 Prompt。**

它的核心特点：
- **动态更新**：随着对话进行实时刷新（最快 300ms 更新一次）
- **高度可定制**：支持运行自定义脚本来生成显示内容
- **支持 ANSI 颜色**：可以用不同颜色突出重要信息
- **接收 Context 信息**：Claude 会把会话信息通过 JSON 传给你的脚本

简单来说，它就是你和 Claude Code 之间的"仪表盘"，可以随时展示你最关心的信息。

## 为什么要配置 StatusLine

你可能会问："默认的状态栏不也挺好的吗，为啥要折腾？"

来，咱们看看自定义 StatusLine 能帮你解决哪些痛点：

### 1. 实时监控 Context 使用情况

Claude Code 的 Context Window 是有限的（200K tokens），用着用着就可能爆了。默认状态栏不会提醒你这个，但自定义状态栏可以：

```
🟢████████ 35%  →  🟡████████ 78%  →  🔴████████ 95% CRIT
```

一眼就能看出 Context 还剩多少，该不该开新会话了。

### 2. Git 分支一目了然

如果你在多个分支来回切换，能在状态栏直接看到当前分支和修改状态，是不是方便多了？

```
📁 blogs 🔀 main ✓  →  🔀 feature-statusline ● (~2 +1 ?3)
```

绿色对勾表示干净的工作区，黄色圆点表示有未提交的改动，数字表示具体的修改类型和文件数量。

### 3. 会话成本实时统计

想知道这次对话花了多少钱、运行了多久、改了多少行代码？状态栏也能告诉你：

```
💰 $0.023 | ⏱ 15m | 📝 +234
```

特别适合对成本敏感的同学，或者想优化工作流程的团队。

## 怎么配置 StatusLine

说了这么多好处，咱们来看看具体怎么配置。

### 快速开始：使用内置命令

最简单的方法是使用 Claude Code 的内置命令：

```bash
/statusline
```

输入这个命令后，Claude Code 会启动一个专门的 `statusline-setup` 代理，帮你：
1. 自动检测你的需求（比如你是否在 Git 仓库中）
2. 生成配置脚本
3. 写入配置文件

这对新手来说是最友好的方式，全程智能化，不用手写配置。

### 手动配置：编辑 settings.json

如果你想完全掌控，可以手动编辑 `~/.claude/settings.json`：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/scripts/statusline.sh",
    "padding": 0
  }
}
```

配置项说明：
- **type**: 固定为 `"command"`，表示使用命令生成状态栏
- **command**: 你的脚本路径（可以是 bash、python、node 等任何可执行文件）
- **padding**: 额外的内边距，默认为 0

### 编写你的第一个 StatusLine 脚本

#### 最简单的 Bash 版本

创建 `~/.claude/scripts/statusline.sh`：

```bash
#!/bin/bash

# 读取 Claude Code 传入的 JSON 数据
INPUT=$(cat)

# 解析出模型名称和目录
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir // "unknown"' | xargs basename)

# 获取 Git 分支（如果在 Git 仓库中）
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    GIT_INFO="🔀 $BRANCH"
else
    GIT_INFO=""
fi

# 输出状态栏内容（第一行会被显示）
echo "[$MODEL] 📁 $DIR $GIT_INFO"
```

别忘了添加执行权限：

```bash
chmod +x ~/.claude/scripts/statusline.sh
```

**工作原理**：
1. Claude Code 通过 stdin 传入一个 JSON 对象
2. 脚本解析 JSON，提取需要的信息
3. 脚本的第一行 stdout 输出会成为状态栏内容

#### 进阶：带颜色和图标的版本

ANSI 颜色代码可以让状态栏更生动：

```bash
#!/bin/bash

INPUT=$(cat)
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir // "unknown"' | xargs basename)

# ANSI 颜色代码
BLUE='\033[94m'
YELLOW='\033[93m'
GREEN='\033[32m'
RESET='\033[0m'

# Git 信息（带颜色）
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

    # 检查是否有未提交的改动
    if [[ -z $(git status --porcelain) ]]; then
        GIT_COLOR=$GREEN
        GIT_STATUS="✓"
    else
        GIT_COLOR=$YELLOW
        GIT_STATUS="●"
    fi

    GIT_INFO=" ${GIT_COLOR}🔀 $BRANCH $GIT_STATUS${RESET}"
else
    GIT_INFO=""
fi

# 组合输出
echo -e "${BLUE}[$MODEL]${RESET} ${YELLOW}📁 $DIR${RESET}${GIT_INFO}"
```

效果类似这样（颜色会在终端中正常显示）：

```
[Claude Sonnet] 📁 blogs 🔀 main ✓
```

#### 高级版本：Python 脚本监控 Context

如果你想实现更复杂的功能，比如实时监控 Context 使用情况，Python 可能是更好的选择。

下面是一个完整的实现（基于我的实际配置）：

创建 `~/.claude/scripts/context-monitor.py`：

```python
#!/usr/bin/env python3
"""
Claude Code Context Monitor
实时监控 Context 使用情况、Git 状态和会话指标
"""

import json
import sys
import os
import subprocess

def parse_context_from_transcript(transcript_path):
    """从 transcript 文件解析 Context 使用情况"""
    if not transcript_path or not os.path.exists(transcript_path):
        return None

    try:
        with open(transcript_path, 'r') as f:
            lines = f.readlines()

        # 检查最后 15 行，查找 token 使用信息
        recent_lines = lines[-15:] if len(lines) > 15 else lines

        for line in reversed(recent_lines):
            try:
                data = json.loads(line.strip())

                if data.get('type') == 'assistant':
                    message = data.get('message', {})
                    usage = message.get('usage', {})

                    if usage:
                        input_tokens = usage.get('input_tokens', 0)
                        cache_read = usage.get('cache_read_input_tokens', 0)
                        cache_creation = usage.get('cache_creation_input_tokens', 0)

                        # 估算 Context 使用率（假设 200k context window）
                        total_tokens = input_tokens + cache_read + cache_creation
                        if total_tokens > 0:
                            percent_used = min(100, (total_tokens / 200000) * 100)
                            return {
                                'percent': percent_used,
                                'tokens': total_tokens
                            }

            except (json.JSONDecodeError, KeyError, ValueError):
                continue

        return None

    except (FileNotFoundError, PermissionError):
        return None

def get_context_display(context_info):
    """生成带视觉指示器的 Context 显示"""
    if not context_info:
        return "🔵 ???"

    percent = context_info.get('percent', 0)

    # 根据使用率选择颜色和图标
    if percent >= 90:
        icon, color = "🔴", "\033[31m"  # 红色 - 危险
    elif percent >= 75:
        icon, color = "🟠", "\033[91m"  # 橙色 - 警告
    elif percent >= 50:
        icon, color = "🟡", "\033[33m"  # 黄色 - 注意
    else:
        icon, color = "🟢", "\033[32m"  # 绿色 - 安全

    # 创建进度条
    segments = 8
    filled = int((percent / 100) * segments)
    bar = "█" * filled + "▁" * (segments - filled)

    reset = "\033[0m"
    return f"{icon}{color}{bar}{reset} {percent:.0f}%"

def get_git_status():
    """获取 Git 仓库状态"""
    try:
        # 检查是否在 Git 仓库中
        result = subprocess.run(['git', 'rev-parse', '--is-inside-work-tree'],
                              capture_output=True, text=True, timeout=2)
        if result.returncode != 0:
            return None

        # 获取当前分支
        branch_result = subprocess.run(['git', 'branch', '--show-current'],
                                     capture_output=True, text=True, timeout=2)
        branch = branch_result.stdout.strip() if branch_result.returncode == 0 else "unknown"

        # 获取状态
        status_result = subprocess.run(['git', 'status', '--porcelain'],
                                     capture_output=True, text=True, timeout=2)

        if status_result.returncode != 0:
            return {"branch": branch, "clean": True}

        status_lines = status_result.stdout.strip().split('\n') if status_result.stdout.strip() else []

        # 统计不同类型的改动
        modified = sum(1 for line in status_lines if line.startswith(' M') or line.startswith('M '))
        added = sum(1 for line in status_lines if line.startswith('A '))
        deleted = sum(1 for line in status_lines if line.startswith(' D') or line.startswith('D '))
        untracked = sum(1 for line in status_lines if line.startswith('??'))

        return {
            "branch": branch,
            "clean": len(status_lines) == 0,
            "modified": modified,
            "added": added,
            "deleted": deleted,
            "untracked": untracked
        }

    except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
        return None

def get_git_display(git_info):
    """生成 Git 状态显示"""
    if not git_info:
        return ""

    branch = git_info.get('branch', 'unknown')
    clean = git_info.get('clean', True)

    # 根据状态选择颜色
    if clean:
        branch_color = "\033[32m"  # 绿色 - 干净
        status_indicator = "✓"
    else:
        branch_color = "\033[33m"  # 黄色 - 有改动
        status_indicator = "●"

    branch_display = f"{branch_color}🔀 {branch} {status_indicator}\033[0m"

    # 如果有改动，添加详细统计
    if not clean:
        changes = []
        modified = git_info.get('modified', 0)
        added = git_info.get('added', 0)
        deleted = git_info.get('deleted', 0)
        untracked = git_info.get('untracked', 0)

        if modified > 0:
            changes.append(f"\033[33m~{modified}\033[0m")  # 黄色 - 修改
        if added > 0:
            changes.append(f"\033[32m+{added}\033[0m")     # 绿色 - 新增
        if deleted > 0:
            changes.append(f"\033[31m-{deleted}\033[0m")   # 红色 - 删除
        if untracked > 0:
            changes.append(f"\033[90m?{untracked}\033[0m") # 灰色 - 未跟踪

        if changes:
            branch_display += f" ({' '.join(changes)})"

    return f" {branch_display}"

def main():
    try:
        # 读取 Claude Code 传入的 JSON 数据
        data = json.load(sys.stdin)

        # 提取信息
        model_name = data.get('model', {}).get('display_name', 'Claude')
        workspace = data.get('workspace', {})
        transcript_path = data.get('transcript_path', '')
        project_dir = workspace.get('project_dir', '')

        # 解析 Context 使用情况
        context_info = parse_context_from_transcript(transcript_path)

        # 获取 Git 状态
        git_info = get_git_status()

        # 构建状态栏组件
        context_display = get_context_display(context_info)
        directory = os.path.basename(project_dir) if project_dir else "unknown"
        git_display = get_git_display(git_info)

        # 模型显示（根据 Context 使用率着色）
        if context_info:
            percent = context_info.get('percent', 0)
            if percent >= 90:
                model_color = "\033[31m"  # 红色
            elif percent >= 75:
                model_color = "\033[33m"  # 黄色
            else:
                model_color = "\033[32m"  # 绿色

            model_display = f"{model_color}[{model_name}]\033[0m"
        else:
            model_display = f"\033[94m[{model_name}]\033[0m"

        # 组合所有组件
        status_line = f"{model_display} \033[93m📁 {directory}\033[0m{git_display} {context_display}"

        print(status_line)

    except Exception as e:
        # 出错时的降级显示
        print(f"\033[94m[Claude]\033[0m \033[93m📁 {os.path.basename(os.getcwd())}\033[0m \033[31m[Error]\033[0m")

if __name__ == "__main__":
    main()
```

添加执行权限：

```bash
chmod +x ~/.claude/scripts/context-monitor.py
```

然后在 `settings.json` 中配置：

```json
{
  "statusLine": {
    "type": "command",
    "command": "/Users/你的用户名/.claude/scripts/context-monitor.py"
  }
}
```

效果示例：

```
[Claude Sonnet] 📁 blogs 🔀 main ✓ 🟢████████ 35%
[Claude Sonnet] 📁 blogs 🔀 feature ● (~2 +1 ?3) 🟡████████ 78%
[Claude Sonnet] 📁 my-project 🔀 main ✓ 🔴████████ 95%
```

## 原理深入探究

好奇宝宝们可能想问："Claude Code 是怎么把数据传给脚本的？"

### JSON 输入结构

Claude Code 通过 **stdin** 传递一个 JSON 对象给你的脚本，结构大概是这样的：

```json
{
  "session_id": "abc123...",
  "model": {
    "display_name": "Claude Sonnet 4.5",
    "id": "claude-sonnet-4-5-20250929"
  },
  "workspace": {
    "current_dir": "/Users/you/projects/blog",
    "project_dir": "/Users/you/projects/blog",
    "additional_dirs": []
  },
  "transcript_path": "/Users/you/.claude/sessions/abc123/transcript.jsonl",
  "cost": {
    "total_cost_usd": 0.023,
    "total_duration_ms": 900000,
    "total_lines_added": 234,
    "total_lines_removed": 56
  },
  "version": "0.8.0"
}
```

关键字段说明：

- **model**: 当前使用的模型信息
- **workspace**: 工作目录信息
- **transcript_path**: 会话记录文件路径（这个很关键！）
- **cost**: 会话成本和统计信息

### Transcript 文件的秘密

`transcript_path` 指向的文件是一个 **JSONL（JSON Lines）** 格式的日志文件，每一行都是一个 JSON 对象，记录了对话的每一条消息。

示例内容：

```jsonl
{"type":"user","content":"帮我写一个函数","timestamp":1234567890}
{"type":"assistant","message":{"usage":{"input_tokens":1500,"output_tokens":200,"cache_read_input_tokens":5000}},"timestamp":1234567891}
{"type":"system_message","content":"Token usage: 30000/200000; 170000 remaining","timestamp":1234567892}
```

通过解析这个文件，我们可以获取：
- **Token 使用情况**：从 `usage` 字段提取
- **Context 警告**：从 `system_message` 类型消息中提取
- **对话历史**：所有的用户和助手消息

这就是上面 Python 脚本中 `parse_context_from_transcript()` 函数的工作原理。

### 性能优化要点

StatusLine 会频繁更新（最快 300ms 一次），所以脚本的性能很重要：

1. **避免阻塞操作**
   - 使用 subprocess 时设置 timeout
   - 不要读取大文件或进行网络请求

2. **缓存机制**
   - 对不常变化的数据（如 Git 状态）可以加缓存
   - 减少重复的系统调用

3. **错误处理**
   - 任何异常都要 catch 住，提供降级显示
   - 不要让脚本崩溃导致状态栏消失

4. **只读取必要的数据**
   - Transcript 文件可能很大，只读取最后几行
   - 使用 `tail` 或倒序读取

## 实战技巧和最佳实践

### 1. 调试你的脚本

写好脚本后，先手动测试一下：

```bash
# 创建一个测试用的 JSON 输入
cat > /tmp/test-input.json << 'EOF'
{
  "model": {"display_name": "Test Model"},
  "workspace": {"project_dir": "/tmp/test"},
  "transcript_path": "",
  "cost": {}
}
EOF

# 测试脚本
cat /tmp/test-input.json | ~/.claude/scripts/statusline.sh
```

看看输出是否符合预期。

### 2. 使用环境变量

如果有些配置需要经常改，可以用环境变量：

```bash
#!/bin/bash

# 从环境变量读取配置
MAX_DIR_LENGTH=${CLAUDE_STATUSLINE_DIR_LENGTH:-30}
SHOW_GIT_STATS=${CLAUDE_STATUSLINE_GIT_STATS:-true}

# ... 后续逻辑
```

然后在 `.zshrc` 或 `.bashrc` 中设置：

```bash
export CLAUDE_STATUSLINE_DIR_LENGTH=20
export CLAUDE_STATUSLINE_GIT_STATS=false
```

### 3. 添加会话成本提醒

如果你想控制成本，可以加个成本提醒：

```python
def get_cost_display(cost_data):
    """会话成本显示"""
    cost_usd = cost_data.get('total_cost_usd', 0)

    if cost_usd >= 0.10:
        color = "\033[31m"  # 超过 0.1 刀，红色警告
        alert = "💸"
    elif cost_usd >= 0.05:
        color = "\033[33m"  # 超过 0.05 刀，黄色提醒
        alert = "💰"
    else:
        color = "\033[32m"  # 便宜，绿色
        alert = "💰"

    cost_str = f"${cost_usd:.3f}"
    return f"{color}{alert} {cost_str}\033[0m"
```

### 4. 不同项目不同配置

如果你想在不同项目使用不同的状态栏，可以在项目的 `.claude/settings.local.json` 中配置：

```json
{
  "statusLine": {
    "type": "command",
    "command": "./.claude/custom-statusline.sh"
  }
}
```

这样每个项目可以有自己的状态栏脚本。

## 常见问题

### Q: 状态栏不更新怎么办？

**A**: 检查几个点：
1. 脚本是否有执行权限（`chmod +x`）
2. 脚本路径是否正确（用绝对路径更保险）
3. 脚本是否能正常运行（手动测试一下）
4. 是否有 stderr 输出导致干扰（把 stderr 重定向到 `/dev/null`）

### Q: 颜色显示不正常？

**A**: 确保你的终端支持 ANSI 颜色。大部分现代终端都支持，但如果遇到问题，可以去掉颜色代码，只用纯文本。

### Q: 脚本执行太慢，状态栏卡顿？

**A**: 优化脚本性能：
- 减少外部命令调用
- 使用 timeout 避免阻塞
- 添加缓存机制
- 只读取必要的数据

### Q: 想要更复杂的显示效果？

**A**: 可以使用 Python、Node.js 等更强大的语言。Python 的 `rich` 库可以创建更丰富的终端界面，Node.js 的 `chalk` 库也很好用。

## 总结

今天我们聊了 Claude Code StatusLine 的：
- **基本概念**：动态更新的状态栏，可高度自定义
- **配置方法**：从内置命令到手动编写脚本
- **实战示例**：从简单的 Bash 脚本到完整的 Python 监控工具
- **原理探究**：JSON 输入结构和 Transcript 文件解析
- **最佳实践**：性能优化、调试技巧、扩展玩法

掌握了这些，你就可以打造一个真正适合自己工作流的状态栏了。

StatusLine 不只是一个显示信息的工具，它还能帮你：
- 时刻关注 Context 使用情况，避免意外中断
- 快速了解项目状态，提高工作效率
- 监控会话成本，优化使用策略

当然，StatusLine 还有很多可能性等你探索。比如：
- 显示单元测试通过率
- 集成 CI/CD 状态
- 显示 TODO 数量
- 监控系统资源使用

你的 StatusLine，你做主。去试试吧，把它改造成你最顺手的样子！

## 参考资料

- [Claude Code 官方文档 - StatusLine](https://docs.claude.com/en/docs/claude-code/statusline)
- [ANSI 颜色代码速查表](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
- [Git Status Porcelain 格式说明](https://git-scm.com/docs/git-status#_porcelain_format_version_1)

---

*本文示例代码均已在 macOS 13.0+ 和 Linux (Ubuntu 22.04) 环境下测试通过。*