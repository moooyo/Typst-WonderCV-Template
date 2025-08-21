# CLAUDE.md

This file provides comprehensive guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a professional bilingual (Chinese/English) resume management system built with Typst, a modern typesetting engine. The system features a sophisticated modular template architecture with separated data management, where resume data is intelligently split into multiple JSON files for optimal organization, maintenance, and scalability.

### Key Features
- **Intelligent Build System**: Timestamp-based incremental compilation with dependency tracking
- **Modular Data Architecture**: Resume data separated into logical modules (basic, education, experience, projects)
- **Cross-Platform Font Management**: Project-level font system ensuring consistent output across environments
- **Automated Environment Setup**: One-command initialization supporting Ubuntu/Debian/Arch Linux
- **Professional Typesetting**: Modern layout with Typst's advanced typography capabilities

## Essential Commands

### Core Build Commands
- `make init` - **CRITICAL FIRST STEP**: Automated environment setup including Typst installation, font installation, and dependency management (supports Ubuntu/Debian/Arch Linux)
- `make build` - Build both Chinese and English PDFs with intelligent dependency checking
- `make zh` - Build Chinese resume only (with smart timestamp checking across all data files)
- `make en` - Build English resume only (with smart timestamp checking across all data files)
- `make clean` - Remove all generated files from dist/ directory
- `make help` - Comprehensive command reference with detailed explanations

### Development Workflow
- **Initial Setup**: Always run `make init` first on new environments
- **Testing Changes**: Use `make zh` or `make en` for rapid iteration during development
- **Production Build**: Use `make build` for final output generation
- **Verification**: Check generated PDFs in `dist/` directory (resume-zh.pdf, resume-en.pdf)

### Smart Build Features
- Dependency tracking includes: .typ files, all JSON data files, common template files
- Skips compilation when output is newer than all dependencies
- Provides clear feedback about build necessity and file timestamps

## Architecture

### Advanced Template System
- **Modular Design**: Highly maintainable template structure in `src/common/`
  - `template.typ` - Core resume template function with advanced layout logic
  - `style.typ` - Reusable component styling functions (sections, items, headers)
  - `settings.typ` - Centralized configuration system with `get-style-params()` function
  
- **Intelligent Data Layer**: Logically separated JSON files optimized for maintenance
  - `src/data/zh/` - Chinese resume data files with complete localization
    - `basic.json` - Personal information, contact details, and language configuration
    - `education.json` - Academic background with structured institution data
    - `experience.json` - Professional work history with detailed descriptions
    - `projects.json` - Technical project portfolio with tech stack information
  - `src/data/en/` - English resume data files (identical structure for consistency)
  - **Entry Points**: Language-specific compilation entry points in `src/{zh,en}/resume.typ`

- **Professional Font Management**: Enterprise-grade font system for consistency
  - `fonts/` - Curated font collection (Source Code Pro, Source Han Sans SC)
  - `scripts/install_fonts.sh` - Automated font installation with user directory management
  - Project-level font priority ensures consistent rendering across different environments

### Advanced Design Patterns

1. **Configuration-Driven Styling**: All visual parameters centralized in `settings.typ`
   - Accessed via `get-style-params()` function for consistent theming
   - Supports easy customization without template modification
   
2. **Intelligent Language Detection**: Template behavior adapts based on `is-chinese` boolean
   - Automatic font selection, spacing adjustments, and layout optimization
   - Language-specific formatting rules applied consistently
   
3. **Incremental Build Optimization**: Advanced dependency tracking system
   - Monitors changes across all template files, data files, and common components
   - Provides clear feedback about build necessity and file modification times
   
4. **Modular Data Architecture**: Resume content logically separated for scalability
   - `basic.json` - Personal information, contact details, and localization settings
   - `education.json` - Academic background with institution details and achievements
   - `experience.json` - Professional work history with comprehensive descriptions
   - `projects.json` - Technical project portfolio with technology stack details
   
5. **Font System Priority**: Project fonts override system fonts ensuring cross-environment consistency
   - Automated installation to user font directory
   - Fallback font handling for missing system fonts

### Core Template Functions
- `resume-template()` - Main template orchestrator accepting modular data parameters
- `section-header()` - Professionally styled section headers with visual dividers
- `experience-item()` / `project-item()` / `education-item()` - Specialized content blocks with consistent formatting
- `page-setup()` - Language-aware page configuration and font initialization

## Advanced File Editing Guidelines

### Data Management Best Practices
Edit the appropriate JSON files in `src/data/zh/` or `src/data/en/` following the established schema:
- **basic.json**: Update personal information, contact details, and language-specific configurations
- **education.json**: Add/modify educational entries with comprehensive details
- **experience.json**: Manage work experience with detailed accomplishment descriptions  
- **projects.json**: Maintain project portfolio with technology stacks and outcomes

### Comprehensive Data Structure Schemas

#### Basic Information Schema
```json
{
  "name": "Full Name",
  "contact": {
    "email": "contact@example.com",
    "phone": "+1-555-0123",
    "github": "https://github.com/username",
    "linkedin": "https://linkedin.com/in/profile",
    "website": "https://personal-website.com"
  },
  "lang_config": {
    "education_title": "Education / 教育背景",
    "experience_title": "Experience / 工作经历", 
    "projects_title": "Projects / 项目经历"
  }
}
```

#### Education Schema
```json
[
  {
    "institution": "University Name",
    "degree": "Master of Science in Computer Science",
    "duration": "2020 - 2024",
    "location": "City, Country",
    "details": ["Relevant coursework", "Academic achievements", "Research projects"]
  }
]
```

#### Experience Schema  
```json
[
  {
    "company": "Company Name",
    "position": "Senior Software Engineer",
    "duration": "2023.06 - Present",
    "location": "City, Country",
    "description": [
      "Led development of microservices architecture",
      "Improved system performance by 40%",
      "Mentored junior developers"
    ]
  }
]
```

#### Projects Schema
```json
[
  {
    "name": "Project Name",
    "description": "Brief project description highlighting key features",
    "tech-stack": "React, Node.js, PostgreSQL, Docker",
    "details": [
      "Implemented real-time data processing",
      "Achieved 99.9% uptime",
      "Deployed to production serving 10k+ users"
    ]
  }
]
```

### Advanced Styling Customization
Modify parameters in `src/common/settings.typ` for comprehensive visual control:
- **Color Schemes**: Primary, secondary, accent colors with accessibility considerations
- **Typography**: Font sizes, line heights, spacing parameters
- **Layout**: Margins, section spacing, page dimensions
- **Components**: Header styles, bullet points, divider appearances

Always use the `get-style-params()` function to access configuration values rather than hardcoding.

### Template System Modifications
- **Layout Changes**: Edit `src/common/template.typ` for structural modifications
- **Component Styling**: Modify `src/common/style.typ` for visual component adjustments
- **Data Integration**: Templates read from multiple JSON files - maintain import structure consistency
- **Language Support**: Ensure modifications work correctly with both Chinese and English configurations

## Comprehensive Dependencies

### Core Requirements
- **Typst** (primary requirement) - Modern typesetting engine
  - Installation: `sudo pacman -S typst` (Arch Linux) or via Cargo
  - Version: Latest stable recommended
- **GNU Make** (build system) - Smart dependency management and build orchestration
- **Node.js & npm** (optional) - For development tooling and package management

### Font Dependencies
- **Download Tools**: `wget` or `curl` for font acquisition
- **Font Processing**: `unzip` for font archive extraction
- **Font Cache**: `fc-cache` for system font cache management
- **Font Management**: Automatic installation via `scripts/install_fonts.sh`

### System Requirements
- **Operating Systems**: Ubuntu 20.04+, Debian 11+, Arch Linux, Manjaro
- **Shell**: Bash/Zsh with standard Unix utilities
- **Permissions**: User-level font directory access (`~/.local/share/fonts/`)

## Advanced Font System

### Professional Font Selection
The project employs carefully selected fonts for optimal readability and professional appearance:
- **Chinese Typography**: Source Han Sans SC (思源黑体) - Comprehensive CJK character support
- **Latin Typography**: Source Code Pro - Clean, readable monospace-inspired design
- **Font Weights**: Regular, Medium, Bold variants for hierarchical typography

### Font Management Architecture
- **Project-Level Storage**: All fonts stored in `fonts/` directory for version control
- **User Installation**: Fonts installed to `~/.local/share/fonts/resume-project/`
- **System Integration**: Automatic font cache refresh and validation
- **Cross-Platform Consistency**: Identical rendering across different Linux distributions

## Output and Distribution

### Generated Files
Professional-grade PDF output with consistent formatting:
- `dist/resume-zh.pdf` - Chinese version with proper CJK typography
- `dist/resume-en.pdf` - English version with optimized Latin typography
- **Quality**: Production-ready with proper font embedding and vector graphics

### File Characteristics
- **Format**: PDF/A-1b compliance for archival quality
- **Fonts**: Embedded for universal compatibility
- **Size**: Optimized for both digital viewing and printing
- **Accessibility**: High contrast ratios and readable font sizes

## Migration and Maintenance Guide

### Data Migration Best Practices
When migrating from legacy single-file structures:

1. **Schema Analysis**: Examine existing data structure and mapping requirements
2. **File Splitting**: Systematically separate data into logical modules:
   ```bash
   # Example migration strategy
   basic.json     ← name, contact, lang_config from original data.json
   education.json ← education array from original data.json
   experience.json ← experience array from original data.json
   projects.json  ← projects array from original data.json
   ```
3. **Template Updates**: Modify `resume.typ` files to import from new modular structure
4. **Build System**: Update Makefile dependencies to track all data files
5. **Validation**: Ensure template functions handle new data structure correctly

### Maintenance Workflows
- **Regular Updates**: Keep Typst version updated for latest features
- **Font Verification**: Periodically verify font installation integrity
- **Template Testing**: Test both language versions after template modifications
- **Data Validation**: Ensure JSON syntax validity after content updates

## Development Environment Setup

### First-Time Setup Checklist
1. ✅ Run `make init` for automated environment preparation
2. ✅ Verify Typst installation: `typst --version`
3. ✅ Confirm font installation: Check `~/.local/share/fonts/resume-project/`
4. ✅ Test build system: `make build`
5. ✅ Validate output: Review generated PDFs in `dist/`

### Development Best Practices
- **Incremental Development**: Use `make zh` or `make en` for rapid iteration
- **Version Control**: Commit both source files and generated PDFs for history
- **Testing**: Verify changes in both language versions
- **Documentation**: Update comments in templates for complex modifications

## Response Guidelines
Always respond in Chinese when providing assistance or explanations.