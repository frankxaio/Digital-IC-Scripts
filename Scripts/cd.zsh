#!/bin/zsh

# Handle the first argument
case "$1" in
  [0-9])
    builtin cd "$ROOT_PATH/0$1_"* || { echo -e "${RED}Change directory failed${NC}"; return 1 2>/dev/null || exit 1 }
    ;;
  m)
    builtin cd "$ROOT_PATH/Memory" || { echo -e "${RED}Change directory failed${NC}"; return 1 2>/dev/null || exit 1 }
    ;;
  *)
    # echo -e "${RED}Please input 0, 1, 2, 3, 4, 5, or 9${NC}"
    return 1 2>/dev/null || exit 1
    ;;
esac


# Print current directory
echo -e "${GREEN}Current directory: $(pwd)${NC}"