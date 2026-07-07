#!/bin/bash
# ============================================================
# Claude Code 智能任务完成通知脚本
# Smart Notification Hook for Claude Code
# ============================================================
# 功能：仅在 Claude Code 终端不在前台时，发送任务完成通知
# 适用平台：macOS
# ============================================================

# 获取当前最前台的应用程序名称
CURRENT_APP=$(osascript -e 'tell application "System Events" to return name of first application process whose frontmost is true')

# ============================================================
# ⚠️ 修改这里为你使用的终端应用名称
# 常见终端名称：
#   - kitty       → "kitty"
#   - iTerm2      → "iTerm2"
#   - Terminal    → "Terminal"（系统自带终端）
#   - Warp        → "Warp"
#   - Alacritty   → "Alacritty"
#   - Ghostty     → "Ghostty"
#   - WezTerm     → "WezTerm"
#   - Hyper       → "Hyper"
#   - VS Code 终端 → "Code"
#   - Cursor 终端  → "Cursor"
# ============================================================
CLAUDE_TERMINAL="kitty"

# 如果当前前台应用不是 Claude Code 所在的终端，则发送通知
if [[ "$CURRENT_APP" != "$CLAUDE_TERMINAL" ]]; then
    # macOS 系统通知（后台，非阻塞）
    osascript -e 'display notification "Claude Code 已完成任务" with title "Claude Code"' &
    # 语音播报（后台，非阻塞 — 放在弹窗前，确保和通知同时触发）
    say "Claude 已完成任务" &
    # macOS 弹窗对话框（阻塞 — 必须放在最后，否则会卡住前面的通知和语音）
    osascript -e 'display dialog "Claude Code 已完成任务" buttons {"确定"} default button "确定"'
fi
