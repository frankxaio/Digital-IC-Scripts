#!/bin/zsh

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get and export the current working directory as ROOT_PATH
ROOT_PATH="$(pwd)"
export ROOT_PATH

echo "ROOT_PATH: ${ROOT_PATH}"
echo "cd.zsh: use 0~5, 9, m to switch folders"
echo "check_syn: summarize synthesis results"

# ---- Define the function to change directories
source ~/Script/cd.zsh



#==================================================
# ================ Function =======================
#==================================================


# --------- Directory Switching ---------
alias 0="source ~/Script/cd.zsh 0"
alias 1="source ~/Script/cd.zsh 1"
alias 2="source ~/Script/cd.zsh 2"
alias 3="source ~/Script/cd.zsh 3"
alias 4="source ~/Script/cd.zsh 4"
alias 5="source ~/Script/cd.zsh 5"
alias 6="source ~/Script/cd.zsh 6"
alias 7="source ~/Script/cd.zsh 7"
alias 8="source ~/Script/cd.zsh 8"
alias 9="source ~/Script/cd.zsh 9"


# # --------- Script Runner ---------
# check_syn() {
#   source ~/Script/cd.zsh 2 && source ~/Script/check_syn.zsh
# }

# # --------- Make Targets ---------
# rtl() {
#   source ~/Script/cd.zsh 1 && make -f "${ROOT_PATH}/01_RTL/Makefile" rtl 2>&1 | grc -c ~/.grc/vcs.conf cat
# }

# syn() {
#   source ~/Script/cd.zsh 2 && make -f "${ROOT_PATH}/02_SYN/Makefile" syn
# }

# gate() {
#   source ~/Script/cd.zsh 3 && make -f "${ROOT_PATH}/03_GATE/Makefile" gate 2>&1 | grc -c ~/.grc/vcs.conf cat
# }



# check
alias check_syn="2 && source ~/Script/check_syn.zsh"

# Front-end design
alias rtl="1 && make -f ${ROOT_PATH}/01_RTL/Makefile rtl 2>&1 | grc -c ~/.grc/vcs.conf cat"
alias syn="2 && make -f ${ROOT_PATH}/02_SYN/Makefile syn"
alias gate="3 && make -f ${ROOT_PATH}/03_GATE/Makefile gate 2>&1 | grc -c ~/.grc/vcs.conf cat"