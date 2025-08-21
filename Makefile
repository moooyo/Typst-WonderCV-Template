# Makefile for Resume Management System

# 变量定义
TYPST = typst
SRC_DIR = src
DIST_DIR = dist
ZH_SRC = $(SRC_DIR)/zh/resume.typ
EN_SRC = $(SRC_DIR)/en/resume.typ
ZH_OUTPUT = $(DIST_DIR)/resume-zh.pdf
EN_OUTPUT = $(DIST_DIR)/resume-en.pdf

# 默认目标
.PHONY: all build zh en clean init help convert-fullwidth

# 构建所有简历
all: build

build: zh en

# 构建中文简历
zh: 
	@if [ -f "$(ZH_OUTPUT)" ] && [ "$(ZH_OUTPUT)" -nt "$(ZH_SRC)" ] && \
	   [ "$(ZH_OUTPUT)" -nt "$(SRC_DIR)/data/zh/basic.json" ] && \
	   [ "$(ZH_OUTPUT)" -nt "$(SRC_DIR)/data/zh/education.json" ] && \
	   [ "$(ZH_OUTPUT)" -nt "$(SRC_DIR)/data/zh/experience.json" ] && \
	   [ "$(ZH_OUTPUT)" -nt "$(SRC_DIR)/data/zh/projects.json" ] && \
	   ! find $(SRC_DIR)/common -name "*.typ" -newer "$(ZH_OUTPUT)" -print -quit | grep -q .; then \
		echo "✓ 中文简历已是最新版本，无需重新编译"; \
		echo "  文件: $(ZH_OUTPUT)"; \
		echo "  最后编译: $$(stat -c '%y' $(ZH_OUTPUT) 2>/dev/null | cut -d'.' -f1 || echo '未知')"; \
	else \
		$(MAKE) $(ZH_OUTPUT); \
	fi

$(ZH_OUTPUT): $(ZH_SRC) $(SRC_DIR)/data/zh/*.json $(SRC_DIR)/common/*.typ
	@echo "编译中文简历..."
	@mkdir -p $(DIST_DIR)
	$(TYPST) compile --root . $(ZH_SRC) $(ZH_OUTPUT)
	@echo "✓ 中文简历已生成: $(ZH_OUTPUT)"
	@echo "  编译时间: $$(date '+%Y-%m-%d %H:%M:%S')"

# 构建英文简历
en: 
	@if [ -f "$(EN_OUTPUT)" ] && [ "$(EN_OUTPUT)" -nt "$(EN_SRC)" ] && \
	   [ "$(EN_OUTPUT)" -nt "$(SRC_DIR)/data/en/basic.json" ] && \
	   [ "$(EN_OUTPUT)" -nt "$(SRC_DIR)/data/en/education.json" ] && \
	   [ "$(EN_OUTPUT)" -nt "$(SRC_DIR)/data/en/experience.json" ] && \
	   [ "$(EN_OUTPUT)" -nt "$(SRC_DIR)/data/en/projects.json" ] && \
	   ! find $(SRC_DIR)/common -name "*.typ" -newer "$(EN_OUTPUT)" -print -quit | grep -q .; then \
		echo "✓ 英文简历已是最新版本，无需重新编译"; \
		echo "  文件: $(EN_OUTPUT)"; \
		echo "  最后编译: $$(stat -c '%y' $(EN_OUTPUT) 2>/dev/null | cut -d'.' -f1 || echo '未知')"; \
	else \
		$(MAKE) $(EN_OUTPUT); \
	fi

$(EN_OUTPUT): $(EN_SRC) $(SRC_DIR)/data/en/*.json $(SRC_DIR)/common/*.typ
	@echo "编译英文简历..."
	@mkdir -p $(DIST_DIR)
	$(TYPST) compile --root . $(EN_SRC) $(EN_OUTPUT)
	@echo "✓ 英文简历已生成: $(EN_OUTPUT)"
	@echo "  编译时间: $$(date '+%Y-%m-%d %H:%M:%S')"

# 强制编译目标
# 环境初始化 - 自动安装所有依赖
init:
	@echo "=== 初始化简历项目环境 ==="
	@echo ""
	@echo "🔍 检测操作系统..."
	@OS_TYPE=""; \
	if [ -f /etc/os-release ]; then \
		. /etc/os-release; \
		case "$$ID" in \
			ubuntu|debian) OS_TYPE="debian" ;; \
			arch|manjaro) OS_TYPE="arch" ;; \
			*) echo "❌ 不支持的操作系统: $$ID"; \
			   echo "   目前仅支持 Ubuntu、Debian 和 Arch Linux"; \
			   exit 1 ;; \
		esac; \
	else \
		echo "❌ 无法检测操作系统类型"; \
		exit 1; \
	fi; \
	echo "✅ 检测到操作系统: $$OS_TYPE"; \
	echo ""; \
	echo "📦 更新包管理器..."; \
	case "$$OS_TYPE" in \
		debian) \
			sudo apt-get update -qq || { echo "❌ 更新包管理器失败"; exit 1; } ;; \
		arch) \
			sudo pacman -Sy --noconfirm || { echo "❌ 更新包管理器失败"; exit 1; } ;; \
	esac; \
	echo "✅ 包管理器更新完成"; \
	echo ""; \
	echo "1. 安装基础依赖..."; \
	case "$$OS_TYPE" in \
		debian) \
			echo "  → 安装 curl, fontconfig, nodejs, npm..."; \
			sudo apt-get install -y curl fontconfig nodejs npm || { echo "❌ 基础依赖安装失败"; exit 1; } ;; \
		arch) \
			echo "  → 安装 curl, fontconfig, nodejs, npm..."; \
			sudo pacman -S --noconfirm curl fontconfig nodejs npm || { echo "❌ 基础依赖安装失败"; exit 1; } ;; \
	esac; \
	echo "✅ 基础依赖安装完成"; \
	echo ""; \
	echo "2. 检查并安装 Typst..."; \
	if ! command -v $(TYPST) > /dev/null 2>&1; then \
		echo "  → Typst 未安装，正在安装..."; \
		case "$$OS_TYPE" in \
			debian) \
				if ! command -v cargo > /dev/null 2>&1; then \
					echo "    安装 Rust..."; \
					curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
					. "$$HOME/.cargo/env"; \
				fi; \
				echo "    通过 Cargo 安装 Typst..."; \
				cargo install --locked typst-cli || { echo "❌ Typst 安装失败"; exit 1; } ;; \
			arch) \
				echo "    通过 pacman 安装 Typst..."; \
				sudo pacman -S --noconfirm typst || { echo "❌ Typst 安装失败"; exit 1; } ;; \
		esac; \
		echo "✅ Typst 安装完成"; \
	else \
		echo "✅ Typst 已安装: $$($(TYPST) --version)"; \
	fi; \
	echo ""; \
	echo "3. 安装 Node.js 项目依赖..."; \
	if [ -f package.json ]; then \
		echo "  → 安装 npm 依赖..."; \
		npm install || { echo "❌ npm 依赖安装失败"; exit 1; }; \
		echo "✅ npm 依赖安装完成"; \
	else \
		echo "ℹ️  无 package.json 文件，跳过 npm 依赖安装"; \
	fi; \
	echo ""; \
	echo "4. 安装项目字体..."; \
	if [ -x scripts/install_fonts.sh ]; then \
		./scripts/install_fonts.sh || { echo "❌ 字体安装失败"; exit 1; }; \
	else \
		echo "❌ 错误: 字体安装脚本不存在或无执行权限"; \
		echo "   请确保 scripts/install_fonts.sh 存在且有执行权限"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "🎉 环境初始化完成！"; \
	echo "   所有依赖已安装:"; \
	echo "   • Typst: $$($(TYPST) --version 2>/dev/null || echo '未找到')"; \
	echo "   • Node.js: $$(node --version 2>/dev/null || echo '未找到')"; \
	echo "   • npm: $$(npm --version 2>/dev/null || echo '未找到')"; \
	echo "   • 字体: 已安装到用户目录"; \
	echo ""; \
	echo "   现在可以运行以下命令："; \
	echo "   • make zh       - 编译中文简历"; \
	echo "   • make en       - 编译英文简历"; \
	echo "   • make build    - 编译所有简历"; \
	echo "   • make help     - 查看所有可用命令"

# 转换全角符号为半角符号
convert-fullwidth:
	@echo "🔄 转换全角符号为半角符号..."
	@if [ -x scripts/convert_fullwidth.sh ]; then \
		scripts/convert_fullwidth.sh; \
	else \
		echo "❌ 转换脚本不存在或不可执行: scripts/convert_fullwidth.sh"; \
		exit 1; \
	fi

# 清理生成的文件
clean:
	@echo "清理生成文件..."
	@rm -rf $(DIST_DIR)
	@echo "✅ 清理完成"

# 显示帮助信息
help:
	@echo "WonderCV - Typst Resume Template 可用命令:"
	@echo ""
	@echo "🚀 核心命令:"
	@echo "  make init               - 自动安装所有依赖（支持Ubuntu/Debian/Arch Linux）"
	@echo "  make build              - 编译所有简历（中文+英文）"
	@echo "  make zh                 - 智能编译中文简历"
	@echo "  make en                 - 智能编译英文简历"
	@echo "  make convert-fullwidth  - 转换全角符号为半角符号"
	@echo "  make clean              - 清理所有生成文件"
	@echo ""
	@echo "🔧 环境要求:"
	@echo "  • 支持的操作系统: Ubuntu、Debian、Arch Linux"
	@echo "  • init命令会自动安装: Typst、Node.js、npm、字体、fontconfig"
	@echo "  • 首次使用请运行: make init"
	@echo ""
	@echo "💡 智能编译说明:"
	@echo "  • zh/en 命令会自动检查文件是否需要更新"
	@echo "  • 如果输出文件比所有源文件都新，将跳过编译"
	@echo "  • 检查的源文件包括: .typ文件、data.json、common模板"
	@echo ""
	@echo "🔄 全角符号转换:"
	@echo "  • convert-fullwidth 命令会自动处理所有JSON数据文件"
	@echo "  • 支持的符号: （）：，。！？【】等常见全角标点"
	@echo "  • Git提交时会自动运行pre-commit hook进行检查和转换"
	@echo ""
	@echo "📁 项目结构:"
	@echo "  src/zh/            - 中文简历模板文件"
	@echo "  src/en/            - 英文简历模板文件"
	@echo "  src/data/zh/       - 中文简历数据文件"
	@echo "  src/data/en/       - 英文简历数据文件"
	@echo "  src/common/        - 共用样式和模板"
	@echo "  fonts/             - 项目字体文件"
	@echo "  scripts/           - 字体安装脚本"
	@echo "  dist/              - 生成的PDF文件"
	@echo ""
	@echo "🎨 字体系统:"
	@echo "  • 中文字体: Source Han Sans SC (思源黑体/兰亭黑)"
	@echo "  • 英文字体: Source Code Pro"
	@echo "  • 运行 'make init' 自动安装所需字体"