# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


######################################################
# Environment Variables
#######################################################

###Synopsys
export SNPSLMD_LICENSE_FILE=27000@localhost.localdomain
# export LM_LICENSE_FILE=/usr/Synopsys/scl/2021.03/admin/license/Synopsys.dat
# alias ins='/usr/Synopsys/installer/setup.sh'
#vcs
export VCS_HOME=/usr/Synopsys/vcs/T-2022.06
export PATH=$PATH:$VCS_HOME/bin

#verdi
export LD_LIBRARY_PATH=/usr/Synopsys/verdi/T-2022.06/share/PLI/VCS/LINUX64
export VERDI_HOME=/usr/Synopsys/verdi/T-2022.06
export PATH=$PATH:$VERDI_HOME/bin

export NOVAS=${VERDI_HOME}/share/PLI/VCS/LINUX64
export novas_args='-P ${NOVAS}/novas.tab ${NOVAS}/pli.a'

#scl
export SCL_HOME=/usr/Synopsys/scl/2021.03
export PATH=$PATH:$SCL_HOME/linux64/bin
export VCS_ARCH_OVERRIDE=linux

#dc
export DC_HOME=/usr/Synopsys/syn/T-2022.03-SP2
export PATH=$PATH:/usr/Synopsys/syn/T-2022.03-SP2/bin

## Spyglass
export SPYGLASS_HOME=/usr/Synopsys/spyglass/T-2022.06-1/SPYGLASS_HOME
export PATH=$PATH:$SPYGLASS_HOME/bin
export SPYGLASS_DC_PATH=/usr/Synopsys/syn/T-2022.03-SP2

#coortools
export PATH="/usr/Synopsys/coretools/T-2022.06/bin":$PATH
alias ct="coreConsultant"
export DESIGNWARE_HOME=/home/autumn/Desktop/IP

#fm
export FM_HOME=/usr/Synopsys/fm/T-2022.03
export PATH=$PATH:$FM_HOME/bin

#pt
export PT_HOME=/usr/Synopsys/prime/T-2022.03
export PATH=$PATH:$PT_HOME/bin

#icc2
export ICC2_HOME=/usr/Synopsys/icc2/T-2022.03
export PATH=$PATH:$ICC2_HOME/bin

#icc
export ICC_HOME=/usr/Synopsys/icc/T-2022.03
export PATH=$PATH:$ICC_HOME/bin

#dft shell
export TESTMAX_MAX=/usr/Synopsys/testmax/S-2021.06-SP5
export PATH=$PATH:$TESTMAX_MAX/bin
#txs
export TXS_HOME=/usr/Synopsys/txs/R-2020.09-SP3
export PATH=$PATH:$TXS_HOME/bin
alias tmax='/usr/Synopsys/txs/R-2020.09-SP3/bin/tmax'
#starrc
export STARRC_HOME=/usr/Synopsys/starrc/T-2022.03-SP2
export PATH=$PATH:$STARRC_HOME/bin

#lic_compiler
export LC_HOME=/usr/Synopsys/lc/T-2022.03
export PATH=$PATH:$LC_HOME/bin
export SYNOPSYS_LC_ROOT=$PATH:$LC_HOME/bin

#VC static
export VC_STATIC_HOME=/usr/Synopsys/vc_static/T-2022.06-SP2
export PATH=$PATH:$VC_STATIC_HOME/bin


alias lmg="/usr/Synopsys/scl/2021.03/linux64/bin/lmgrd -c /usr/Synopsys/scl/2021.03/admin/license/Synopsys.dat"

###Cadence
export CDS_LIC_FILE=/usr/Cadence/license/cadence.dat
alias inc=/usr/Cadence/iscape/iscape.04.23-s010/bin/iscape.sh

#virtuoso
export MGC_FDI_OA_VERSION=22.60
export Virtuoso_HOME=/usr/Cadence/IC618
export OA_HOME=$Virtuoso_HOME/oa_v22.60.007
export OA_PLUGIN_PATH=$Virtuoso_HOME/oa_v22.60.007/data/plugins
export CDS_AUTO_64BIT=ALL
export CDS_Netlisting_Mode=Analog

#export CDS_Netlisting_Mode=Digital
export PATH=$Virtuoso_HOME/share/bin:$PATH
export PATH=$Virtuoso_HOME/tools/bin:$PATH
export PATH=$Virtuoso_HOME/tools/dfII/bin:$PATH
export PATH=$Virtuoso_HOME/tools/dracula/bin:$PATH
export PATH=$Virtuoso_HOME/tools/iccraft/bin:$PATH
export PATH=$Virtuoso_HOME/tools/plot/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$Virtuoso_HOME/tools.lnx86/lib/64bit
export CDS_LOAD_ENV=CSF

#innovus
export INN_HOME=/usr/Cadence/INNOVUS201
export PATH=$PATH:$INN_HOME/bin

#confrml
export CONFRML_HOME=/usr/Cadence/CONFRML222
export PATH=$PATH:$CONFRML_HOME/bin




###Mentor

export MGLS_LICENSE_FILE=/usr/Mentor/license/license.dat
######Calibre
export MGC_HOME=/usr/Mentor/calibre/aoi_cal_2022.4_28.13
export CALIBRE_HOME=$MGC_HOME
export PATH=$MGC_HOME/bin:$PATH
export MGC_LIB_PATH=$CALIBRE_HOME/lib

#tessent
export TESSENT_HOME=/usr/Mentor/tessent
export PATH=$TESSENT_HOME/bin:$PATH



###Ansys
export APACHEDA_LICENSE_FILE=/usr/Ansys/license/apacheda.lic

#redhawk
export redhawk_HOME=/usr/Ansys/redhawk/RedHawk_Linux64e6_V2020R2.1
export PATH=$redhawk_HOME/bin:$PATH

alias ANS_LMG='/USR/ANSYS/REDHAWK/LMBIN/V11_ANSYSLMD/LMGRD -C /USR/ANSYS/LICENSE/APACHEDA.LIC -L /USR/ANSYS/LICENSE/APS.LOG'


# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


#Verible
export PATH="/home/host/Tools/verible-v0.0-3958-g7aae5c08/bin/:$PATH"

#SVlint
export PATH="/home/host/Tools/svlint-v0.9.3-x86_64/bin:$PATH"


# =====================================
# Oh my Zsh setup
# =====================================
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# see https://github.com/ohmyzsh/ohmyzsh/wiki/themes
# zsh_theme="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  extract
  fzf
  fzf-tab
  zsh-bat
  colored-man-pages
  zsh-completions
  # vi-mode
)



export PATH="$HOME/.cargo/bin:$PATH"

source $ZSH/oh-my-zsh.sh
# source ~/.config/zsh/zsh-syntax-highlightin-tokyonight.zsh
# source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.zsh


# eza alias
alias ls='eza'
alias la='eza -a'
alias ll='eza -lh'
alias lt='eza --tree'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


######################################################
# ZSH Keybindings
#######################################################

# bindkey -v
# # bindkey '^p' history-search-backward
# # bindkey '^n' history-search-forward
# # bindkey '^[w' kill-region
# # bindkey ' ' magic-space                           # do history expansion on space
# bindkey "^[[A" history-beginning-search-backward  # search history with up key
# bindkey "^[[B" history-beginning-search-forward   # search history with down key




######################################################
# History Configuration
#######################################################

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups



######################################################
# Completion styling
#######################################################

# Load completions
autoload -Uz compinit && compinit

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# zoxide
eval "$(zoxide init --cmd cd zsh)"  # For zsh
# fzf
# eval "$(fzf --zsh)"  # For zsh
alias bfzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"



#####################################################
# function
#####################################################
# Manually load conda only when explicitly needed
function useconda() {
    source ~/miniconda3/etc/profile.d/conda.sh
}

# fzf-based file copy function (source_dir -> current dir)
cp_fzf() {
  if [[ -z "$1" ]]; then
    echo "Usage: cp_fzf <source_path>"
    return 1
  fi

  local src="$1"
  local dest="$PWD"

  if [[ ! -d "$src" ]]; then
    echo "Error: source path '$src' is not a directory."
    return 1
  fi

  # Change to source dir for fzf-based selection
  (
    cd "$src" || exit 1
    fzf --multi --prompt="Select files to copy from '$src' to '$dest': " \
    | while IFS= read -r file; do
        cp -v -- "$file" "$dest"
      done
  )

  # Back to original destination path
  cd "$dest"
}



#####################################################
# ASIC Project Directory
#####################################################
alias prj='source ~/Script/project.zsh'
alias dwip='evince /usr/cad/synopsys/synthesis/cur/dw/doc/manuals/dwbb_userguide.pdf >& /dev/null &'
alias io='evince ~iclabTA01/umc018/Doc/umc18io3v5v.pdf >& /dev/null &'
alias myps='ps -aux | grep \$user'

# gcc version
source /opt/rh/devtoolset-9/enable

