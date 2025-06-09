#!/bin/zsh

cycle_syn() {
  if [[ $# -eq 0 ]]; then
    echo "${BLUE}Synthesis File: $SYN_FILE${NC}"
    GREP_COLOR='01;32' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
    return 1
  else
    echo "${BLUE}Synthesis File: $SYN_FILE${NC}"
    GREP_COLOR='01;31' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
    if sed -i "s/set CYCLE [0-9]\+\.\?[0-9]*/set CYCLE $1/" "$SYN_FILE"; then
      GREP_COLOR='01;32' cat -n "$SYN_FILE" | grep --color -E "set CYCLE [0-9]+\.?[0-9]*"
      echo "${GREEN}Change cycle time to $1 done.${NC}"
    fi
  fi
}

# Call the function with all passed arguments
cycle_syn "$@"
