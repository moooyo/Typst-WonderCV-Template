# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

WonderCV is a modern bilingual (Chinese/English) resume management system built on Typst typesetting engine. It features modular architecture with JSON-based data management, cross-platform font management, and intelligent build system.

## Common Development Commands

### Core Build Commands
- `make init` - **Required first step**: Auto-installs all dependencies (Typst, Node.js, fonts)
- `make build` - Build both Chinese and English versions (PDF + SVG + PNG)
- `make zh` - Build Chinese resume with intelligent incremental compilation
- `make en` - Build English resume with intelligent incremental compilation
- `make clean` - Clean all generated files in dist/ directory
- `make watch` - File monitoring mode for development
- `make help` - Show all available commands

### NPM Scripts
- `npm run build` - Equivalent to `make build`
- `npm run build:zh` - Build Chinese version only
- `npm run build:en` - Build English version only
- `npm run clean` - Clean generated files

### Development Tools
- `make convert-fullwidth` - Convert fullwidth punctuation to halfwidth in JSON files

## Architecture and Code Structure

### Template System Architecture
The project uses a three-layer template architecture:

1. **Data Layer** (`src/data/`): JSON files containing resume content
   - `basic.json` - Personal information and language configuration
   - `education.json` - Education history
   - `experience.json` - Work experience
   - `projects.json` - Project portfolio

2. **Template Layer** (`src/common/`):
   - `template.typ` - Main template with modern Typst syntax and grid layouts
   - `style.typ` - Style definitions and theme configuration
   - `settings.typ` - Centralized configuration management

3. **Language Layer** (`src/zh/`, `src/en/`):
   - `resume.typ` - Language-specific entry points that import data and apply templates

### Key Design Patterns

**Modular Data Management**: Resume sections are separated into individual JSON files for maintainability. Each section can be independently edited without affecting others.

**Configuration-Driven Styling**: All styling parameters (colors, fonts, spacing, grid layouts) are centralized in `settings.typ`, allowing easy theme customization.

**Intelligent Build System**: The Makefile implements timestamp-based incremental compilation that checks dependencies across template files, data files, and common modules.

**Bilingual Support**: Template functions accept `is-chinese` parameter to handle language-specific formatting (indentation, font selection, labels).

### Font Management
- Uses project-local font system with Inter (English) and Source Han Sans SC (Chinese)
- Fonts are installed to user directory via `scripts/install_fonts.sh`
- Font configuration is handled in `settings.typ`

### Build Dependencies
The build system tracks these dependency relationships:
- Template files depend on: `src/common/*.typ`
- Resume compilation depends on: language-specific data files (`src/data/{zh,en}/*.json`)
- Multi-format output: Each build generates PDF, SVG (for web), and PNG (300 DPI)

## Development Workflow

1. **Initial Setup**: Always run `make init` first to install Typst and dependencies
2. **Data Editing**: Modify JSON files in `src/data/{zh,en}/` for content changes
3. **Template Customization**: Edit `src/common/*.typ` files for layout/styling
4. **Testing Changes**: Use `make zh` or `make en` for quick incremental builds
5. **Full Build**: Use `make build` before final distribution

## Important Notes

- The build system supports Ubuntu/Debian/Arch Linux only
- Typst compilation requires proper font installation via `make init`
- JSON data files support both array and string formats for descriptions
- The template uses modern Typst syntax with named parameters and grid layouts
- Git hooks automatically run fullwidth-to-halfwidth conversion on commit