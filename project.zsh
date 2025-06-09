#!/bin/zsh

# =====================================================
# Project Bootstrap Script
# =====================================================

# -------------------- Colors -------------------------
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# -------------------- Paths --------------------------
ROOT_PATH="$(pwd)"
SCRIPT_PATH="$HOME/Dotfiles"
SYN_FILE="$ROOT_PATH/02_SYN/syn.tcl"
DESIGN_MAKE=$(grep -E '^top_design=' "$ROOT_PATH/00_TESTBED/Makefile" | cut -d'=' -f2 | tr -d ' ')
DESIGN_SYN=$(grep -E '^set DESIGN ' "$SYN_FILE" | awk '{print $3}' | tr -d '"')

export ROOT_PATH

# -------------------- Info Panel ---------------------
echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
echo -e "${GREEN}| COMMAND       | DESCRIPTION                                                    |${NC}"
echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
echo -e "${BLUE}| ROOT_PATH     | ${NC}$ROOT_PATH"
echo -e "${BLUE}| DESIGN        | ${NC}Makefile: ${YELLOW}$DESIGN_MAKE${NC}, Syn File: ${YELLOW}$DESIGN_SYN${NC}"
echo -e "${BLUE}| cd.zsh        | ${NC}0~9, m to switch folders; 2r -> syn report; 2n -> syn netlist"
echo -e "${BLUE}| rtl           | ${NC}run RTL simulation"
echo -e "${BLUE}| syn           | ${NC}run synthesis"
echo -e "${BLUE}| cycle_syn     | ${NC}change synthesis cycle time, e.g. cycle_syn 10.0"
echo -e "${BLUE}| gate          | ${NC}run gate simulation"
echo -e "${BLUE}| post          | ${NC}run post simulation"
echo -e "${BLUE}| check_syn     | ${NC}summarize synthesis results"
echo -e "${BLUE}| rpt           | ${NC}cat all files in \$ROOT_PATH/02_SYN/Report/*.ext"
echo -e "${BLUE}| genrtl        | ${NC}generate rtl simulation files"
echo -e "${BLUE}| gengate       | ${NC}generate gate simulation files"
echo -e "${BLUE}| link_mk       | ${NC}link Makefile to current directory"
echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"

# -------------------- Script Source ------------------
source $SCRIPT_PATH/cd.zsh

# =====================================================
# Aliases
# =====================================================

# -- Directory Switching (0~9)
for i in {0..9}; do
  alias $i="source $SCRIPT_PATH/cd.zsh $i"
done

# -- Synthesis Directories
alias 2r="cd $ROOT_PATH/02_SYN/Report/"
alias 2n="cd $ROOT_PATH/02_SYN/Netlist/"

# -- Python Tools
alias genrtl="python3 $SCRIPT_PATH/Python_script/gen_rtl_sim.py"
alias gengate="python3 $SCRIPT_PATH/Python_script/gen_gate_sim.py"

# =====================================================
# Functions
# =====================================================

check_syn() {
  source "$SCRIPT_PATH/cd.zsh" 2
  source "$SCRIPT_PATH/check_syn.zsh"
}

rtl() {
  source "$SCRIPT_PATH/cd.zsh" 1
  make -f "$ROOT_PATH/01_RTL/Makefile" rtl 2>&1 | grc -c ~/.grc/vcs.conf cat
}

syn() {
  source "$SCRIPT_PATH/cd.zsh" 2
  make -f "$ROOT_PATH/02_SYN/Makefile" syn
}

gate() {
  source "$SCRIPT_PATH/cd.zsh" 3
  make -f "$ROOT_PATH/03_GATE/Makefile" gate 2>&1 | grc -c ~/.grc/vcs.conf cat
}

post() {
  source "$SCRIPT_PATH/cd.zsh" 6
  make -f "$ROOT_PATH/06_POST/Makefile" gate 2>&1 | grc -c ~/.grc/vcs.conf cat
}

link_mk() {
  local current_dir="${PWD##*/}"

  if [[ "$current_dir" == 0?* ]]; then
    echo "🔗 Linking Makefile from 00_TESTBED..."
    ln -sf "$ROOT_PATH/00_TESTBED/Makefile" .
  else
    echo "❌ This function only works in 0x_ folders like 01_RTL, 02_SYN."
    return 1
  fi
}

rpt() {
  local dir="$ROOT_PATH/02_SYN/Report"

  if [[ ! -d $dir ]]; then
    echo "❌ Report directory not found: $dir"
    return 1
  fi

  if [[ -z $1 ]]; then
    echo "Available extensions under $dir:"
    local exts=(${(u)${(f)"$(printf '%s\n' "$dir"/*.* | sed -E 's@.*\.@@')"}})
    for e in $exts; do echo "  .$e"; done
    return
  fi

  local ext=$1
  local files=("$dir"/*."$ext")

  if (( ${#files[@]} == 0 )); then
    echo "❌ No *.$ext files found in $dir"
    return 1
  fi

  if (( $+commands[rcat] )); then
    rcat "${files[@]}"
  else
    cat "${files[@]}"
  fi
}

cycle_syn() {
  if [[ $# -eq 0 ]]; then
    echo "${BLUE}Synthesis File: $SYN_FILE${NC}"
    GREP_COLOR='01;32' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
    return 1
  fi

  echo "${BLUE}Synthesis File: $SYN_FILE${NC}"
  CURRENT_CYCLE=$(grep -E "set CYCLE [0-9]+\.?[0-9]*" "$SYN_FILE" | grep -Eo "[0-9]+\.?[0-9]*")

  if [[ "$CURRENT_CYCLE" == "$1" ]]; then
    echo "${YELLOW}Cycle time is already $1. No change needed.${NC}"
  else
    GREP_COLOR='01;31' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
    sed -i "s/set CYCLE [0-9]\+\.\?[0-9]*/set CYCLE $1/" "$SYN_FILE"
    GREP_COLOR='01;32' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
    echo "${GREEN}Changed cycle time to $1.${NC}"
  fi
}

prj_help() {
  echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
  echo -e "${GREEN}| COMMAND       | DESCRIPTION                                                    |${NC}"
  echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
  echo -e "${BLUE}| ROOT_PATH     | ${NC}$ROOT_PATH"
  echo -e "${BLUE}| DESIGN        | ${NC}Makefile: ${YELLOW}$DESIGN_MAKE${NC}, Syn File: ${YELLOW}$DESIGN_SYN${NC}"
  echo -e "${BLUE}| cd.zsh        | ${NC}0~9, m to switch folders; 2r -> syn report; 2n -> syn netlist"
  echo -e "${BLUE}| rtl           | ${NC}run RTL simulation"
  echo -e "${BLUE}| syn           | ${NC}run synthesis"
  echo -e "${BLUE}| cycle_syn     | ${NC}change synthesis cycle time"
  echo -e "${BLUE}| gate          | ${NC}run gate simulation"
  echo -e "${BLUE}| post          | ${NC}run post simulation"
  echo -e "${BLUE}| check_syn     | ${NC}summarize synthesis results"
  echo -e "${BLUE}| rpt           | ${NC}print *.ext files in 02_SYN/Report"
  echo -e "${BLUE}| genrtl        | ${NC}generate rtl sim files"
  echo -e "${BLUE}| gengate       | ${NC}generate gate sim files"
  echo -e "${BLUE}| link_mk       | ${NC}symlink Makefile to local folder"
  echo -e "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
}
