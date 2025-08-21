#!/bin/bash

# =============================================================================
# Git Hooks 安装脚本
# =============================================================================
# 安装项目所需的 git hooks

set -e

# 定义颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Git Hooks 安装脚本 ===${NC}"

# 获取项目根目录
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
HOOKS_DIR="$REPO_ROOT/.git/hooks"
SCRIPTS_DIR="$REPO_ROOT/scripts"

# 检查是否在 git 仓库中
if [[ ! -d "$REPO_ROOT/.git" ]]; then
    echo -e "${RED}错误: 当前目录不是 git 仓库${NC}"
    exit 1
fi

# 检查 scripts 目录是否存在
if [[ ! -d "$SCRIPTS_DIR" ]]; then
    echo -e "${RED}错误: scripts 目录不存在: $SCRIPTS_DIR${NC}"
    exit 1
fi

# 安装 pre-commit hook
echo -e "安装 pre-commit hook..."
if [[ -f "$SCRIPTS_DIR/pre-commit" ]]; then
    cp "$SCRIPTS_DIR/pre-commit" "$HOOKS_DIR/pre-commit"
    chmod +x "$HOOKS_DIR/pre-commit"
    echo -e "${GREEN}✓ pre-commit hook 已安装${NC}"
else
    echo -e "${YELLOW}⚠ 警告: pre-commit hook 脚本不存在: $SCRIPTS_DIR/pre-commit${NC}"
fi

# 检查转换脚本是否存在
if [[ -f "$SCRIPTS_DIR/convert_fullwidth.sh" ]]; then
    chmod +x "$SCRIPTS_DIR/convert_fullwidth.sh"
    echo -e "${GREEN}✓ 转换脚本权限已设置${NC}"
else
    echo -e "${YELLOW}⚠ 警告: 转换脚本不存在: $SCRIPTS_DIR/convert_fullwidth.sh${NC}"
fi

echo -e ""
echo -e "${GREEN}=== 安装完成 ===${NC}"
echo -e "现在当您提交包含 JSON 文件的更改时，系统会自动检查并转换全角符号为半角符号。"
echo -e ""
echo -e "如需手动运行转换脚本，请使用："
echo -e "  ${BLUE}./scripts/convert_fullwidth.sh <文件路径>${NC}"
