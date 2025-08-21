#!/bin/bash

# 简历项目字体安装脚本
# 将项目中的字体文件安装到系统中，确保编译结果一致

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FONTS_DIR="$PROJECT_DIR/fonts"
USER_FONTS_DIR="$HOME/.local/share/fonts/resume-project"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查字体目录是否存在
check_fonts_dir() {
    if [ ! -d "$FONTS_DIR" ]; then
        print_error "字体目录不存在: $FONTS_DIR"
        exit 1
    fi
    
    # 检查是否有字体文件
    if [ ! "$(ls -A $FONTS_DIR/*.ttf $FONTS_DIR/*.otf 2>/dev/null)" ]; then
        print_error "字体目录中没有找到字体文件"
        exit 1
    fi
}

# 创建用户字体目录
create_user_fonts_dir() {
    print_info "创建用户字体目录: $USER_FONTS_DIR"
    mkdir -p "$USER_FONTS_DIR"
}

# 清理旧的字体链接
clean_old_fonts() {
    if [ -d "$USER_FONTS_DIR" ]; then
        print_info "清理旧的字体链接..."
        rm -f "$USER_FONTS_DIR"/*
    fi
}

# 安装字体文件
install_fonts() {
    print_info "安装字体文件..."
    
    local font_count=0
    
    # 安装项目字体 (支持 .ttf 和 .otf)
    for font in "$FONTS_DIR"/*.ttf "$FONTS_DIR"/*.otf; do
        if [ -f "$font" ]; then
            local font_name=$(basename "$font")
            print_info "  → 安装字体: $font_name"
            ln -sf "$font" "$USER_FONTS_DIR/$font_name"
            font_count=$((font_count + 1))
        fi
    done
    
    if [ $font_count -eq 0 ]; then
        print_error "没有找到可安装的字体文件"
        exit 1
    fi
    
    print_success "已安装 $font_count 个字体文件"
}

# 刷新字体缓存
refresh_font_cache() {
    print_info "刷新系统字体缓存..."
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f -v "$USER_FONTS_DIR" >/dev/null 2>&1
        print_success "字体缓存已更新"
    else
        print_warning "未找到 fc-cache 命令，请手动刷新字体缓存"
    fi
}

# 验证字体安装
verify_fonts() {
    print_info "验证字体安装..."
    
    # 检查思源黑体字体
    if fc-list | grep -i "source.*han.*sans\|lantinghei" >/dev/null 2>&1 || ls "$USER_FONTS_DIR"/SourceHanSansSC* >/dev/null 2>&1; then
        print_success "  ✓ 思源黑体字体: 可用"
    else
        print_warning "  ! 思源黑体字体: 可能未正确安装"
    fi
    
    # 检查Inter字体
    if fc-list | grep -i "inter" >/dev/null 2>&1 || ls "$USER_FONTS_DIR"/Inter* >/dev/null 2>&1; then
        print_success "  ✓ Inter字体: 可用"
    else
        print_warning "  ! Inter字体: 可能未正确安装"
    fi
    
    # 验证Typst是否能识别字体
    if command -v typst >/dev/null 2>&1; then
        print_info "验证Typst字体识别..."
        if typst fonts | grep -i "inter" >/dev/null 2>&1; then
            print_success "  ✓ Typst能识别Inter字体"
        fi
        if typst fonts | grep -i "source.*han.*sans" >/dev/null 2>&1; then
            print_success "  ✓ Typst能识别思源黑体字体"
        fi
        print_success "  ✓ Typst字体系统工作正常"
    fi
}

# 显示安装信息
show_install_info() {
    print_success "字体安装完成！"
    print_info "字体安装位置: $USER_FONTS_DIR"
    print_info "安装的字体:"
    
    for font in "$USER_FONTS_DIR"/*.ttf "$USER_FONTS_DIR"/*.otf; do
        if [ -f "$font" ]; then
            local font_name=$(basename "$font")
            print_info "  • $font_name"
        fi
    done
    
    echo
    print_info "现在可以在简历编译中使用以下字体:"
    print_info "  • 中文字体: Source Han Sans SC (思源黑体)"
    print_info "  • 英文字体: Inter"
    echo
    print_info "运行 'make zh' 或 'make en' 来编译简历"
}

# 主函数
main() {
    print_info "开始安装简历项目字体..."
    
    check_fonts_dir
    create_user_fonts_dir
    clean_old_fonts
    install_fonts
    refresh_font_cache
    verify_fonts
    show_install_info
}

# 运行主函数
main "$@"
