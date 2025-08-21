# WonderCV - Typst Resume Template

一个基于 Typst 的现代化双语（中英文）简历模板系统，采用模块化设计，支持数据与模板分离，实现简历内容的高效管理和自动化构建。

## 🎯 项目特色

- **🌐 双语支持**：完整的中英文简历生成支持
- **📝 现代化排版**：基于 Typst 引擎的专业级排版效果
- **🔧 模块化设计**：数据与模板分离，便于维护和定制
- **⚡ 智能构建**：基于文件时间戳的增量编译系统
- **🎨 一致性保证**：项目级字体管理，确保跨环境一致性
- **🚀 一键部署**：自动化环境初始化，支持主流 Linux 发行版

## 📁 项目结构

```
typst-resume-wondercv/
├── README.md              # 项目说明文档
├── CLAUDE.md             # AI 开发助手指南
├── package.json          # Node.js 项目配置
├── Makefile             # 构建系统配置
├── fonts/               # 项目字体文件
│   ├── SourceCodePro-*.ttf        # 英文字体
│   └── SourceHanSansSC-*.otf      # 中文字体
├── scripts/
│   ├── install_fonts.sh   # 字体安装脚本
│   ├── install_hooks.sh   # Git hooks 安装脚本
│   ├── convert_fullwidth.sh # 全角符号转换脚本
│   └── pre-commit         # Pre-commit hook 脚本
├── src/
│   ├── common/          # 共用模板和样式
│   │   ├── template.typ # 主模板文件
│   │   ├── style.typ    # 样式组件
│   │   └── settings.typ # 配置参数
│   ├── data/            # 简历数据文件
│   │   ├── zh/          # 中文数据
│   │   │   ├── basic.json      # 基本信息
│   │   │   ├── education.json  # 教育背景
│   │   │   ├── experience.json # 工作经历
│   │   │   └── projects.json   # 项目经历
│   │   └── en/          # 英文数据（结构相同）
│   ├── zh/              # 中文简历入口
│   │   ├── resume.typ   # 中文简历编译入口
│   │   └── resume.pdf   # 生成的中文简历
│   └── en/              # 英文简历入口
│       ├── resume.typ   # 英文简历编译入口
│       └── resume.pdf   # 生成的英文简历
└── dist/                # 构建输出目录（自动生成）
    ├── resume-zh.pdf    # 中文简历输出
    └── resume-en.pdf    # 英文简历输出
```

## 🚀 快速开始

### 环境要求

支持的操作系统：
- Ubuntu / Debian
- Arch Linux / Manjaro

### 一键初始化

```bash
# 克隆项目
git clone <repository-url>
cd typst-resume-wondercv

# 自动安装所有依赖（包括 Typst、字体等）
make init
```

`make init` 会自动完成：
- ✅ 检测操作系统并更新包管理器
- ✅ 安装基础依赖（curl, fontconfig, nodejs, npm）
- ✅ 安装 Typst 排版引擎
- ✅ 安装 Node.js 项目依赖
- ✅ 安装项目专用字体

### 构建简历

```bash
# 构建所有简历（中文 + 英文）
make build

# 仅构建中文简历
make zh

# 仅构建英文简历
make en

# 清理生成文件
make clean

# 转换全角符号为半角符号
make convert-fullwidth

# 查看所有可用命令
make help
```

### 🔄 全角符号自动转换

为了确保简历数据格式的一致性，项目提供了自动全角符号转换功能：

#### 手动转换
```bash
# 转换所有 JSON 数据文件中的全角符号
make convert-fullwidth

# 或直接使用脚本
./scripts/convert_fullwidth.sh

# 转换指定文件
./scripts/convert_fullwidth.sh src/data/zh/basic.json
```

#### 自动转换（Git Hook）
项目提供了 Git pre-commit hook，会在每次提交前自动检查和转换全角符号：

- **自动检测**：提交时自动扫描暂存的 JSON 文件
- **智能转换**：发现全角符号时自动转换为半角符号
- **友好提示**：转换后会重新暂存文件并提示用户检查

**安装 Git Hooks：**
```bash
# 安装 pre-commit hook（推荐）
./scripts/install_hooks.sh
```

安装后，每次 `git commit` 时会自动运行转换检查。

#### 支持的转换符号
```
全角 → 半角
（）  → ()
，。  → ,.
：；  → :;
！？  → !?
【】  → []
｛｝  → {}
＋－＝ → +=-
　    → (space)
...等常见标点符号
```

#### 自定义转换规则
如需添加更多转换规则，请编辑 `scripts/convert_fullwidth.sh` 文件中的 sed 替换命令。

## 📝 使用指南

### 1. 编辑简历数据

简历数据采用模块化 JSON 格式存储，便于维护：

#### 基本信息 (`src/data/zh/basic.json`)
```json
{
  "name": "您的姓名",
  "contact": {
    "email": "your.email@example.com",
    "phone": "+86 138-0013-8000",
    "github": "https://github.com/yourusername",
    "linkedin": "https://linkedin.com/in/yourprofile"
  },
  "lang_config": {
    "education_title": "教育背景",
    "experience_title": "工作经历",
    "projects_title": "项目经历"
  }
}
```

#### 教育背景 (`src/data/zh/education.json`)
```json
[
  {
    "institution": "大学名称",
    "degree": "学位信息",
    "duration": "2020 - 2024",
    "location": "城市，国家",
    "details": ["专业课程", "获得荣誉"]
  }
]
```

#### 工作经历 (`src/data/zh/experience.json`)
```json
[
  {
    "company": "公司名称",
    "position": "职位名称",
    "duration": "2023.06 - 至今",
    "location": "城市，国家",
    "description": ["工作职责和成就描述"]
  }
]
```

#### 项目经历 (`src/data/zh/projects.json`)
```json
[
  {
    "name": "项目名称",
    "description": "项目简短描述",
    "tech-stack": "技术栈",
    "details": ["项目详细信息和成果"]
  }
]
```

### 2. 自定义样式

修改 `src/common/settings.typ` 中的参数来调整样式：

```typst
// 示例：修改颜色主题
#let color-theme = (
  primary: rgb("#2E86AB"),    // 主色调
  secondary: rgb("#A23B72"),  // 次色调
  text: rgb("#333333")        // 文本色
)
```

### 3. 智能构建系统

构建系统会自动检查文件依赖关系：
- 📄 源文件：`.typ` 模板文件
- 📊 数据文件：所有 `.json` 数据文件
- 🎨 样式文件：`common/` 目录下的模板文件

只有当源文件比输出文件新时才会重新编译，提高构建效率。

## 🎨 字体系统

项目使用专门的字体确保输出一致性：

- **中文字体**：Source Han Sans SC（思源黑体）
- **英文字体**：Source Code Pro

字体文件存储在 `fonts/` 目录中，通过 `make init` 自动安装到用户字体目录。

## 🔧 开发指南

### 添加新内容

1. **编辑数据**：修改对应的 JSON 文件
2. **更新模板**：如需修改布局，编辑 `src/common/template.typ`
3. **调整样式**：修改 `src/common/settings.typ` 中的参数
4. **构建测试**：运行 `make build` 生成 PDF

### 模板架构

- `template.typ`：主模板函数 `resume-template()`
- `style.typ`：样式组件函数
- `settings.typ`：集中式配置管理

### 数据迁移

从单文件结构迁移到模块化结构：

1. 将原 `data.json` 拆分为四个文件
2. 更新 `resume.typ` 的导入语句
3. 更新 Makefile 依赖跟踪
4. 确保模板函数兼容新数据结构

## 📋 可用命令

| 命令 | 功能 | 说明 |
|------|------|------|
| `make init` | 环境初始化 | 自动安装所有依赖和字体 |
| `make build` | 构建所有简历 | 同时生成中英文 PDF |
| `make zh` | 构建中文简历 | 智能检查，避免重复构建 |
| `make en` | 构建英文简历 | 智能检查，避免重复构建 |
| `make clean` | 清理文件 | 删除所有生成的 PDF |
| `make help` | 显示帮助 | 查看所有可用命令详情 |

## 🛠 技术栈

- **排版引擎**：[Typst](https://typst.app/) - 现代化排版系统
- **构建系统**：GNU Make - 智能依赖管理
- **数据格式**：JSON - 结构化数据存储
- **字体管理**：项目级字体确保一致性
- **版本控制**：Git - 代码版本管理

## 📖 输出示例

生成的简历将保存在以下位置：
- `dist/resume-zh.pdf` - 中文简历
- `dist/resume-en.pdf` - 英文简历

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'Add amazing feature'`
4. 推送分支：`git push origin feature/amazing-feature`
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 💡 获取帮助

- 🐛 **问题反馈**：[Issues](../../issues)
- 💬 **功能建议**：[Discussions](../../discussions)
- 📚 **Typst 文档**：[Typst Documentation](https://typst.app/docs/)

---

**Made with ❤️ and Typst**
