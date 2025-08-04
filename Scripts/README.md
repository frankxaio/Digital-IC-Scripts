# Scripts Directory

This directory contains various Python and shell scripts for synthesis and utility tasks.

## Directory Structure

```
Scripts/
├── README.md              # This file
├── config.py              # Common configuration and utilities
├── synthesis/             # Synthesis-related scripts
│   ├── check_syn.py       # Check synthesis results
│   └── cycle_syn.py       # Modify synthesis cycle time
├── utils/                 # Utility scripts
│   ├── gen_rtl_sim.py     # Generate RTL simulation file list
│   └── gen_gate_sim.py    # Generate gate simulation file list
├── tests/                 # Test scripts
│   ├── test_rich.py       # Test rich output functionality
│   └── test_check_syn_rich.py # Test check_syn rich output
├── print_report.py        # Print synthesis reports
├── clk.zsh               # Clock-related shell script
├── cd.zsh                # Directory navigation script
└── check_syn.zsh         # Shell wrapper for check_syn.py
```

## Script Categories

### 🔧 **Core Configuration**
- `config.py` - Common utilities, rich console setup, and environment management

### 🏗️ **Synthesis Scripts** (`synthesis/`)
- `check_syn.py` - Analyze synthesis results and generate reports
- `cycle_syn.py` - Modify cycle time in synthesis files

### 🛠️ **Utility Scripts** (`utils/`)
- `gen_rtl_sim.py` - Generate file list for RTL simulation
- `gen_gate_sim.py` - Generate file list for gate-level simulation

### 🧪 **Test Scripts** (`tests/`)
- `test_rich.py` - Demonstrate rich output capabilities
- `test_check_syn_rich.py` - Test check_syn output formatting

### 📊 **Report Scripts**
- `print_report.py` - Print synthesis reports with formatting

### 🐚 **Shell Scripts**
- `clk.zsh` - Clock management utilities
- `cd.zsh` - **Digital IC Design Flow Navigation** - Quick directory switching for IC design workflow
- `check_syn.zsh` - Shell wrapper for synthesis checking

### 🚀 **Digital IC Design Flow Navigation (`cd.zsh`)**

The `cd.zsh` script provides convenient directory navigation for digital IC design workflow:

```bash
# Quick navigation to design flow directories
0  # → 00_TESTBED (testbench and simulation files)
1  # → 01_RTL (RTL design files)
2  # → 02_SYN (synthesis files and scripts)
3  # → 03_GATE (gate-level simulation)
4  # → 04_LAYOUT (layout files)
5  # → 05_DRC (design rule check)
6  # → 06_POST (post-layout simulation)
7  # → 07_LVS (layout vs schematic)
8  # → 08_PEX (parasitic extraction)
9  # → 09_FINAL (final verification)
m  # → Memory (memory-related files)
```

**Usage**: `source cd.zsh <number>` or use aliases `0`, `1`, `2`, etc.

## Usage

### 🚀 **Project Integration (`project.zsh`)**
The main entry point for digital IC design workflow:

```bash
# Source the project bootstrap script
source ~/Dotfiles/project.zsh

# This provides:
# - Directory navigation (0, 1, 2, 3, etc.)
# - Workflow commands (rtl, syn, gate, post, check_syn)
# - Utility functions (genrtl, gengate, cycle_syn)
# - Help system (prj_help, scripts_info, test_scripts)
```

### Python Scripts
All Python scripts use the conda environment and rich for beautiful output:

```bash
# Run synthesis check
./synthesis/check_syn.py

# Modify cycle time
./synthesis/cycle_syn.py syn.tcl design.sdc 10.0

# Generate simulation files
./utils/gen_rtl_sim.py
./utils/gen_gate_sim.py

# Test rich output
./tests/test_rich.py
```

### Shell Scripts
```bash
# Source shell scripts for navigation
source cd.zsh
source clk.zsh
```

### 🎯 **Quick Start**
1. Navigate to your IC design project root
2. Run: `source ~/Dotfiles/project.zsh`
3. Use `0`, `1`, `2`, etc. to navigate between design flow directories
4. Use `rtl`, `syn`, `gate`, `post` for workflow execution
5. Use `check_syn` for synthesis analysis
6. Use `prj_help` for command reference

## Dependencies

- **Python**: Conda environment with `rich` package
- **Environment**: `ROOT_PATH` must be set
- **Permissions**: All Python scripts are executable

## Features

- **Rich Output**: Beautiful, colored terminal output
- **Error Handling**: Consistent error reporting
- **Modular Design**: Organized by functionality
- **Cross-platform**: Works on Linux with conda 