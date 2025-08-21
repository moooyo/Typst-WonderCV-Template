#!/bin/bash

# =============================================================================
# 全角符号转半角符号脚本
# =============================================================================
# 自动将常见的全角标点符号转换为半角符号

set -e

# 定义颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 转换单个文件
convert_file() {
    local file="$1"
    local temp_file="${file}.tmp"
    local changes=0
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}错误: 文件 $file 不存在${NC}"
        return 1
    fi
    
    echo -e "${BLUE}处理文件: $file${NC}"
    
    # 创建临时文件
    cp "$file" "$temp_file"
    
    # 使用sed进行替换，一次性处理所有转换
    # 统计修改前后的差异
    local before_hash=$(md5sum "$temp_file" | cut -d' ' -f1)
    
    # 执行所有替换
    sed -i \
        -e 's/（/(/g' \
        -e 's/）/)/g' \
        -e 's/，/,/g' \
        -e 's/。/./g' \
        -e 's/；/;/g' \
        -e 's/：/:/g' \
        -e 's/？/?/g' \
        -e 's/！/!/g' \
        -e 's/【/[/g' \
        -e 's/】/]/g' \
        -e 's/｛/{/g' \
        -e 's/｝/}/g' \
        -e 's/＋/+/g' \
        -e 's/－/-/g' \
        -e 's/＝/=/g' \
        -e 's/＆/\&/g' \
        -e 's/％/%/g' \
        -e 's/＃/#/g' \
        -e 's/＠/@/g' \
        -e 's/＊/*/g' \
        -e 's/＜/</g' \
        -e 's/＞/>/g' \
        -e 's/｜/|/g' \
        -e 's/＼/\\/g' \
        -e 's/／/\//g' \
        -e 's/～/~/g' \
        -e 's/｀/`/g' \
        -e 's/＂/"/g' \
        -e 's/＇/'\''/g' \
        -e 's/￥/¥/g' \
        -e 's/　/ /g' \
        "$temp_file"
    
    local after_hash=$(md5sum "$temp_file" | cut -d' ' -f1)
    
    if [[ "$before_hash" != "$after_hash" ]]; then
        mv "$temp_file" "$file"
        echo -e "  ${GREEN}✓ 文件已更新${NC}"
        return 0
    else
        rm -f "$temp_file"
        echo -e "  ${GREEN}✓ 无需修改${NC}"
        return 1
    fi
}

# 主函数
main() {
    echo -e "${BLUE}=== 全角符号转半角符号工具 ===${NC}"
    echo
    
    local files=()
    local total_files=0
    local changed_files=0
    
    # 如果没有提供参数，处理所有 JSON 文件
    if [[ $# -eq 0 ]]; then
        echo -e "${YELLOW}未指定文件，将处理所有 JSON 数据文件...${NC}"
        readarray -t files < <(find src/data -name "*.json" -type f 2>/dev/null || true)
    else
        files=("$@")
    fi
    
    # 检查是否找到文件
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${RED}错误: 未找到要处理的文件${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}找到 ${#files[@]} 个文件待处理${NC}"
    echo
    
    # 处理每个文件
    for file in "${files[@]}"; do
        total_files=$((total_files + 1))
        if convert_file "$file"; then
            changed_files=$((changed_files + 1))
        fi
        echo
    done
    
    # 输出统计信息
    echo -e "${BLUE}=== 处理完成 ===${NC}"
    echo -e "总文件数: $total_files"
    echo -e "修改文件数: $changed_files"
    echo -e "未修改文件数: $((total_files - changed_files))"
    
    if [[ $changed_files -gt 0 ]]; then
        echo -e "${GREEN}✓ 转换完成！请检查修改的文件${NC}"
    else
        echo -e "${GREEN}✓ 所有文件都已是正确格式${NC}"
    fi
}

# 显示帮助信息
show_help() {
    cat << EOF
全角符号转半角符号工具

使用方法:
    $0 [选项] [文件...]

选项:
    -h, --help    显示此帮助信息

参数:
    文件...       要处理的文件路径（可选，默认处理所有 JSON 文件）

示例:
    $0                              # 处理所有 JSON 文件
    $0 src/data/zh/basic.json       # 处理指定文件
    $0 src/data/zh/*.json           # 处理指定目录下的所有 JSON 文件

支持的转换:
    （ ） ， 。 ； ： ？ ！ 【 】 ｛ ｝
    ＋ － ＝ ＆ ％ ＃ ＠ ＊ ＜ ＞ ｜
    ＼ ／ ～ ｀ ＂ ＇ ￥ 　
EOF
}

# 处理命令行参数
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
