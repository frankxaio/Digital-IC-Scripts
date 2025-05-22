#!/bin/zsh
#dcnxt_shell -f syn.tcl | tee syn.log
Design=$(awk '/set DESIGN/ {gsub(/"|;/, "", $3); print $3}' "$ROOT_PATH/02_SYN/syn.tcl")


NO_COLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

round() {
  printf "%.${2}f" "${1}"
}

Cycle=`cat Report/${Design}.qor | grep "Critical Path Clk Period:" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
Area=`cat Report/${Design}.area | grep 'Total cell area:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
Dynamic=`cat Report/${Design}.power | grep "Total Dynamic Power"`
Leakage=`cat Report/${Design}.power | grep "Cell Leakage Power"`
memory_area=`cat Report/${Design}.area | grep 'Macro/Black Box area'`
memory_area=$(echo $memory_area | tr -dc '0-9')
gate_count=$(echo "$Area/9.9792" | bc -l) # U18 gate count
# gate_count=$(echo "$Area/10" | bc -l)   # T18 gate count
# gate_count=$(echo "$Area/2.8224" | bc -l)  # T90 gate count

flag=0
echo -e "${YELLOW}============================${NO_COLOR}"
if grep -i -q 'Latch' 'syn.log'; then
	echo -e "${RED}--> X There is Latch in this design ---${NO_COLOR}"
    flag=1
else
    echo -e "${GREEN}--> V Latch Checked!${NO_COLOR}"
fi
if grep -i -q 'mismatch' 'syn.log'; then
	echo -e "${RED}--> X Width Mismatch Error !! ---${NO_COLOR}"
    flag=1
else
    echo -e "${GREEN}--> V Width Mismatch Checked!${NO_COLOR}"
fi
if grep -i -q 'Error' 'syn.log'; then
	echo  -e "${RED}--> X There is Error in this design !! ---${NO_COLOR}"
    flag=1
else
    echo -e "${GREEN}--> V No Error in syn.log!${NO_COLOR}"
fi
if grep -i -q 'violated' "Report/${Design}.timing"; then
	echo  -e "${RED}--> X Timing (violated) ---${NO_COLOR}"
    flag=1
else
    echo -e "${GREEN}--> V Timing (MET) Checked!${NO_COLOR}"
fi
# if [ $memory_area = "0000000" ]; then
#     echo  -e "${RED}--> X No use of memory ---${NO_COLOR}"
#     flag=1
# else
#     echo -e "${GREEN}--> V Memory Checked!${NO_COLOR}"
# fi
    echo -e "${YELLOW}============================${NO_COLOR}"
if [ $flag -eq 1 ] ; then
	echo -e "${RED}--> X 02_SYN Fail !! Please check out syn.log file.${NO_COLOR}"
else
    echo -e "${GREEN}--> V 02_SYN Success !!${NO_COLOR}"
fi
    echo -e "${YELLOW}============================${NO_COLOR}"
    echo -e "${YELLOW}Design: $Design ${NO_COLOR}"
    echo -e "${YELLOW}Cycle: $Cycle ${NO_COLOR}"
    echo -e "${YELLOW}Area: $Area ${NO_COLOR}"
    echo -e "${YELLOW}Gate count: $(round $gate_count 0) (U18)${NO_COLOR}"
    # echo -e "${YELLOW}Gate count: $(round $gate_count 0) (T18)${NO_COLOR}"
    # echo -e "${YELLOW}Gate count: $(round $gate_count 0) (T90)${NO_COLOR}"
    echo -e "${YELLOW}Dynamic: $Dynamic ${NO_COLOR}"
    echo -e "${YELLOW}Leakage: $Leakage ${NO_COLOR}"

