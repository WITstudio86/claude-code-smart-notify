# Claude Code 智能任务完成通知 🧠🔔

> 仅在 Claude Code 终端不在前台时，才发送 macOS 系统通知 + 弹窗 + 语音播报。
> 当你在终端里看着 Claude Code 工作时，不会再被多余的弹窗打扰。

## 效果

| 你在看什么 | 会通知吗？ |
|-----------|----------|
| 在 kitty 终端里盯着 Claude Code | ❌ 不通知 |
| 切到浏览器 / IDE / 其他应用 | ✅ 通知 + 弹窗 + 语音 |

## 快速开始

### 1. 下载脚本

```bash
curl -o ~/.claude/smart-notify.sh https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-smart-notify/main/smart-notify.sh
chmod +x ~/.claude/smart-notify.sh
```

> 把 `YOUR_USERNAME` 替换为你的 GitHub 用户名，或直接复制仓库中的 `smart-notify.sh` 文件。

### 2. 修改终端名称（重要！）

打开 `~/.claude/smart-notify.sh`，找到这一行：

```bash
CLAUDE_TERMINAL="kitty"
```

把 `"kitty"` 改成你使用的终端应用名称：

| 你的终端 | 改成 |
|---------|------|
| **kitty** | `"kitty"` |
| **iTerm2** | `"iTerm2"` |
| **系统终端** | `"Terminal"` |
| **Warp** | `"Warp"` |
| **Alacritty** | `"Alacritty"` |
| **Ghostty** | `"Ghostty"` |
| **WezTerm** | `"WezTerm"` |
| **Hyper** | `"Hyper"` |
| **VS Code 内置终端** | `"Code"` |
| **Cursor 内置终端** | `"Cursor"` |

> 💡 不确定你的终端名称？在终端里运行这个命令查看：
> ```bash
> osascript -e 'tell application "System Events" to return name of first application process whose frontmost is true'
> ```
> 把终端切到前台，运行上面的命令，输出的就是你要填的名称。

### 3. 配置 Claude Code Hook

打开 Claude Code 的配置文件：

```bash
# 编辑用户级配置（对所有项目生效）
vim ~/.claude/settings.json
```

在 `hooks.Stop` 中添加（或替换现有配置）：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/smart-notify.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
```

> ⚠️ 如果你已经有其他 hook，请合并而不是覆盖。

### 4. 完成！

下次 Claude Code 完成任务时，智能通知就会生效了。

---

## 如果你不想用外部脚本

也可以直接在 `settings.json` 中写内联命令：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "CURRENT_APP=$(osascript -e 'tell application \"System Events\" to return name of first application process whose frontmost is true'); CLAUDE_TERMINAL=\"kitty\"; if [[ \"$CURRENT_APP\" != \"$CLAUDE_TERMINAL\" ]]; then osascript -e 'display notification \"Claude Code 已完成任务\" with title \"Claude Code\"' -e 'display dialog \"Claude Code 已完成任务\" buttons {\"确定\"} default button \"确定\"'; say \"Claude 已完成任务\"; fi",
            "async": true
          }
        ]
      }
    ]
  }
}
```

把 `"kitty"` 换成你的终端名称即可。

---

## 自定义通知内容

修改脚本中的以下内容：

- **通知文字**：改 `"Claude Code 已完成任务"` 和 `"Claude Code"`
- **语音播报**：改 `say "Claude 已完成任务"`，也可以删除这行
- **去掉弹窗**：删除 `display dialog` 那行，只保留通知
- **去掉语音**：删除 `say` 那行
- **增加提示音**：添加 `afplay /System/Library/Sounds/Glass.aiff`

---

## 原理

1. Claude Code 任务完成时触发 `Stop` hook
2. Hook 异步执行脚本
3. 脚本通过 AppleScript 获取当前前台应用名称
4. 如果前台应用**不是**你指定的终端 → 发送通知
5. 如果前台应用**就是**终端 → 静默跳过（你已经在看了，不需要打扰）

---

## 常见问题

**Q: 通知不弹？**
A: 检查 macOS 的「系统设置 → 通知」，确保允许「脚本编辑器」(osascript) 发送通知。

**Q: 终端名称不对？**
A: 运行 `osascript -e 'tell application "System Events" to return name of first application process whose frontmost is true'` 查看实际名称。

**Q: 在 VS Code 里用 Claude Code？**
A: 把 `CLAUDE_TERMINAL` 设为 `"Code"`，这样在 VS Code 里时不会弹通知，切到浏览器等应用时会弹。

---

## License

MIT
