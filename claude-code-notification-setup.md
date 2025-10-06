# Claude Code 任务完成通知：别再盯着屏幕傻等了

## 写在前面

用过 Claude Code 的同学应该都遇到过这种情况：

- 让 Claude 跑个测试、编译个项目，然后你切到浏览器看会儿文档
- 过了几分钟想起来："诶，Claude 跑完了吗？"
- 切回终端一看：早就执行完了，自己在那儿傻等了半天

或者更糟的情况：

- 让 Claude 执行一个耗时任务，去泡杯咖啡
- 回来发现 Claude 10 分钟前就完成了，还在等你的下一步指令
- 时间就这样白白浪费了

如果你也有这些痛点，那今天这篇文章就是为你准备的。咱们来聊聊怎么配置 Claude Code 的通知系统，让它在任务完成后主动"喊"你一声。

## 问题的本质：异步任务与注意力切换

先说说为什么需要这个功能。

Claude Code 在执行任务时，特别是运行测试、编译代码、安装依赖这些操作，往往需要等待几秒到几分钟不等。作为开发者，你不可能一直盯着终端等它跑完，这太浪费时间了。

合理的工作流应该是：
1. 给 Claude 下达任务
2. 切换到其他工作（看文档、回消息、喝水）
3. 任务完成后收到通知
4. 回到 Claude Code 继续下一步

但默认情况下，Claude Code 执行完任务后只是静默地等待，不会主动通知你。这就是我们要解决的问题。

## Hooks：Claude Code 的事件钩子系统

Claude Code 提供了一个强大的机制：**Hooks（钩子）**。

简单来说，Hooks 就是在特定事件发生时自动执行的脚本。有点类似：
- Git 的 pre-commit、post-commit 钩子
- React 的 useEffect 钩子
- Webpack 的 plugin 系统

Claude Code 支持多种类型的 Hook，其中最实用的就是 **Stop Hook**。

### Stop Hook 是什么

**Stop Hook** 会在 Claude Code 完成一次响应后触发。

具体来说：
- Claude 执行完所有工具调用（Bash、Read、Write 等）
- Claude 完成最终回复
- 此时 Stop Hook 被触发

注意：如果你手动中断（Ctrl+C），Stop Hook **不会**触发，这是合理的设计。

## 快速开始：最简单的通知配置

废话不多说，咱们直接上代码。

### macOS 系统配置

编辑 `~/.claude/settings.json`，添加以下配置：

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code task completed\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

保存后重启 Claude Code，搞定！

**效果**：每次 Claude 完成任务后，macOS 右上角会弹出系统通知。

### 显示项目名称的配置

如果你想在通知中显示当前项目名称，可以用这个配置：

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Tool completed in '$(basename \"$PWD\")'\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

**工作原理**：
- 使用 `$(basename "$PWD")` 获取当前目录名
- 通知会显示类似 "Tool completed in my-blog-project" 的消息

这样你就能一眼看出是哪个项目完成了任务！

## 配置详解：每个字段的含义

咱们来拆解一下配置文件，理解每个部分的作用。

### 基本结构

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "你的命令"
          }
        ]
      }
    ]
  }
}
```

**字段说明**：

#### 1. `hooks` 对象

顶层的 `hooks` 对象包含所有类型的钩子配置。Claude Code 支持多种钩子类型：
- `Stop`: 任务完成时触发
- `Notification`: 需要权限或用户输入时触发
- 其他类型（参考官方文档）

#### 2. `Stop` 数组

`Stop` 是一个数组，可以配置多个不同的 Stop Hook。每个元素是一个规则对象。

#### 3. `matcher` 字段

用于匹配特定的工具调用。可选值：
- `"*"`: 匹配所有工具（最常用）
- `"Bash"`: 只匹配 Bash 命令
- `"Read"`: 只匹配文件读取
- `"Bash(git *)"`: 只匹配 git 相关的 Bash 命令

**示例**：只在执行测试命令后通知

```json
{
  "matcher": "Bash(npm test)",
  "hooks": [...]
}
```

#### 4. `hooks` 数组（内层）

这是真正要执行的钩子命令列表。每个钩子有：
- `type`: 固定为 `"command"`（目前只支持命令类型）
- `command`: 要执行的 shell 命令

### 关于命令的执行环境

**重要**：`command` 字段中的命令会在当前工作目录下执行，继承当前 shell 的环境变量。

这意味着：
- 可以使用环境变量（如 `$PWD`、`$HOME`）
- 可以使用 shell 的控制结构（`if`、`&&`、`||`）
- 可以执行任何可执行文件或脚本

## 进阶玩法：更智能的通知

基础配置能用，但咱们可以做得更好。

### 1. 显示项目名称

在通知中显示当前项目，方便你知道是哪个项目完成了：

```bash
osascript -e 'display notification "Task completed in '$(basename "$PWD")'" with title "Claude Code"'
```

效果：`Task completed in my-blog-project`

### 2. 添加声音提示

macOS 可以在通知时播放声音：

```bash
osascript -e 'display notification "Task completed" with title "Claude Code" sound name "Glass"'
```

可用的系统声音：`Glass`、`Bottle`、`Frog`、`Ping`、`Pop`、`Submarine` 等。

在 `/System/Library/Sounds/` 目录下可以找到所有可用的声音文件。

### 3. 根据任务类型使用不同通知

你可以配置多个 Hook，针对不同的任务显示不同的通知：

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "Bash(npm test)",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Tests completed\" with title \"Claude Code\" sound name \"Glass\"'"
          }
        ]
      },
      {
        "matcher": "Bash(npm run build)",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Build completed\" with title \"Claude Code\" sound name \"Bottle\"'"
          }
        ]
      },
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Task completed\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

**注意顺序**：Claude Code 会按顺序匹配，使用第一个匹配的规则。把特定的规则放在前面，通用规则（`"*"`）放在最后。

### 4. 使用自定义脚本

如果通知逻辑比较复杂，建议写成独立脚本。

创建 `~/.claude/scripts/notify.sh`：

```bash
#!/bin/bash

# 读取 Claude Code 传入的上下文信息（JSON 格式）
INPUT=$(cat)

# 提取项目目录
PROJECT=$(echo "$INPUT" | jq -r '.workspace.project_dir // "unknown"' | xargs basename)

# 获取任务耗时（如果有的话）
DURATION=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
DURATION_SEC=$((DURATION / 1000))

# 构建通知消息
if [ "$DURATION_SEC" -gt 0 ]; then
    MESSAGE="Task completed in $PROJECT (took ${DURATION_SEC}s)"
else
    MESSAGE="Task completed in $PROJECT"
fi

# 发送通知
osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
```

添加执行权限：

```bash
chmod +x ~/.claude/scripts/notify.sh
```

在 `settings.json` 中引用：

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/你的用户名/.claude/scripts/notify.sh"
          }
        ]
      }
    ]
  }
}
```

## 原理深入：Hook 的执行机制

好奇宝宝们可能想问："Claude Code 是怎么调用我的脚本的？传了什么数据？"

### 执行流程

1. **Claude 完成响应**
   - 所有工具调用执行完毕
   - 最终文本回复生成完成

2. **触发 Stop Hook**
   - Claude Code 遍历所有 Stop Hook 配置
   - 按顺序匹配 `matcher`

3. **执行钩子命令**
   - 设置工作目录为当前项目目录
   - 通过 stdin 传入 JSON 格式的上下文数据
   - 执行 `command` 字段中的命令
   - 默认超时时间：60 秒

4. **处理执行结果**
   - 如果命令返回非零退出码，记录错误（但不影响 Claude Code 主流程）
   - stdout 和 stderr 会被记录到日志文件

### 传入的 JSON 数据结构

Claude Code 会通过 stdin 传入一个 JSON 对象，结构类似：

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

如果你的脚本需要这些信息，可以用 `jq` 解析：

```bash
INPUT=$(cat)
PROJECT=$(echo "$INPUT" | jq -r '.workspace.project_dir' | xargs basename)
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd')
```

### 超时和错误处理

**默认超时**：60 秒

如果你的脚本执行时间超过 60 秒，会被强制终止。所以：
- 避免在 Hook 中执行耗时操作
- 如果需要长时间任务，使用后台任务（`&`）

**错误处理**：

Hook 脚本应该始终成功退出（返回 0），即使遇到错误。例如：

```bash
#!/bin/bash

# 尝试发送通知，失败也不影响
osascript -e 'display notification "Task completed"' 2>/dev/null || true

exit 0
```

## 实战技巧和最佳实践

### 1. 避免通知疲劳

如果每次 Claude 响应都弹通知，会很烦。可以添加一些过滤条件：

```bash
#!/bin/bash

# 只在任务耗时超过 10 秒时通知
INPUT=$(cat)
DURATION=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
DURATION_SEC=$((DURATION / 1000))

if [ "$DURATION_SEC" -gt 10 ]; then
    osascript -e 'display notification "Long task completed" with title "Claude Code"'
fi
```

### 2. 通知内容包含关键信息

让通知一眼就能看出发生了什么：

```bash
PROJECT=$(basename "$PWD")
LINES_ADDED=$(echo "$INPUT" | jq -r '.cost.total_lines_added // 0')
MESSAGE="$PROJECT: +$LINES_ADDED lines"

osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
```

### 3. 调试 Hook 脚本

如果 Hook 不工作，添加日志来调试：

```bash
#!/bin/bash

LOG_FILE="$HOME/.claude/hook.log"

echo "=== $(date) ===" >> "$LOG_FILE"
echo "PWD: $PWD" >> "$LOG_FILE"
cat >> "$LOG_FILE"  # 记录 stdin 输入

# 你的通知逻辑
osascript -e 'display notification "Task completed"' 2>> "$LOG_FILE"

exit 0
```

然后查看日志：

```bash
tail -f ~/.claude/hook.log
```

### 4. 结合 Do Not Disturb

macOS 的勿扰模式可以在脚本中检测：

```bash
# macOS 检测勿扰模式
if defaults read com.apple.controlcenter "NSStatusItem Visible DoNotDisturb" | grep -q "1"; then
    # 勿扰模式开启，不发送通知
    exit 0
fi

# 正常发送通知
osascript -e 'display notification "Task completed"'
```

### 5. 项目特定配置

不同项目可能需要不同的通知策略，使用项目级配置文件：

在项目根目录创建 `.claude/settings.local.json`：

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/custom-notify.sh"
          }
        ]
      }
    ]
  }
}
```

这样每个项目可以有自己的通知脚本。

## 常见问题

### Q: 通知没有弹出怎么办？

**A**: 检查以下几点：

1. **脚本路径是否正确**
   ```bash
   # 测试命令是否能执行
   osascript -e 'display notification "Test"'
   ```

2. **权限问题**
   - 确保终端有通知权限（系统偏好设置 → 通知）

3. **JSON 语法错误**
   ```bash
   # 验证 settings.json 格式
   jq . ~/.claude/settings.json
   ```

4. **查看日志**
   - Claude Code 的日志文件位于 `~/.claude/logs/`

### Q: 通知太频繁，能限制一下吗？

**A**: 可以在脚本中添加频率限制：

```bash
#!/bin/bash

LOCK_FILE="/tmp/claude-notify.lock"
COOLDOWN=30  # 30 秒冷却时间

# 检查上次通知时间
if [ -f "$LOCK_FILE" ]; then
    LAST_NOTIFY=$(cat "$LOCK_FILE")
    NOW=$(date +%s)
    DIFF=$((NOW - LAST_NOTIFY))

    if [ "$DIFF" -lt "$COOLDOWN" ]; then
        # 冷却时间内，不发送通知
        exit 0
    fi
fi

# 发送通知
osascript -e 'display notification "Task completed"'

# 记录本次通知时间
date +%s > "$LOCK_FILE"
```

### Q: 能在通知上添加按钮吗？

**A**: macOS 的 `osascript` 不支持通知按钮，但可以使用第三方工具：

安装 `terminal-notifier`：

```bash
brew install terminal-notifier
```

使用示例：

```bash
terminal-notifier \
  -title "Claude Code" \
  -message "Task completed" \
  -open "file://$PWD" \
  -sound Glass
```

点击通知会打开项目目录。

## 总结

今天我们聊了 Claude Code 通知配置的：

- **核心原理**：通过 Stop Hook 在任务完成时触发自定义命令
- **基础配置**：macOS 系统通知的简单配置方案
- **进阶玩法**：智能通知、项目名称显示、项目特定配置
- **实现细节**：JSON 数据结构、执行流程、错误处理
- **最佳实践**：避免通知疲劳、添加关键信息、调试技巧

掌握了这些，你就可以让 Claude Code 在完成任务后主动通知你，不用再盯着屏幕傻等了。

你可以从最简单的配置开始，然后根据需要逐步扩展，添加声音、显示项目名、任务耗时等信息。

记住：工具是为人服务的，配置成你最舒服的样子才是最好的。

去试试吧，让 Claude Code 成为你更好的助手！

## 参考资料

- [Claude Code 官方文档 - Hooks](https://docs.claude.com/en/docs/claude-code/hooks)
- [macOS osascript 文档](https://ss64.com/osx/osascript.html)
- [jq 命令行 JSON 处理器](https://stedolan.github.io/jq/)

---

*本文示例代码均已在 macOS 14.0+ 环境下测试通过。*