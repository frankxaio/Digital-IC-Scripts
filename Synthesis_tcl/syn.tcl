#======================================================
# SECTION (A) Global Parameters
#======================================================
set DESIGN  "BoothMUL"
set VERSION "v1"
set CYCLE 6.0
set INPUT_DLY   [expr {$CYCLE/2}]
set OUTPUT_DLY  [expr {$CYCLE/2}]
set CLOCK_NAME "clk"
set RESET_NAME "reset"

if {[info exists env(ROOT_PATH)]} {
    puts "ROOT_PATH is: $env(ROOT_PATH)"
    set ROOT_PATH $env(ROOT_PATH)
} else {
    puts "ROOT_PATH is not set"
}


# Specify temporary folder
set temp_dir "work"
file mkdir $temp_dir

# Define temporary design library
define_design_lib WORK -path "./work"


#!SECTION


#======================================================
# SECTION (B) Read RTL Code
#======================================================

set hdlin_auto_save_templates TRUE
#! Modify
analyze -format sverilog " "
elaborate $DESIGN
current_design $DESIGN
link

#!SECTION

#======================================================
# SECTION (C) Global Setting
#======================================================
set_wire_load_mode top

# U18
# set_wire_load_model -name udp8K_Conservative -library UDVS_u018mmwc162v
# set_operating_conditions -max WC1D62VCOM -max_library UDVS_u018mmwc162v  -min BC1D98VCOM -min_library UDVS_u018mmbc198v


# T18
set_wire_load_model -name tsmc18_wl10 -library slow
set_operating_conditions -min_library fast -min fast  -max_library slow -max slow

#!SECTION

#======================================================
# SECTION (D) Set Design Constraints
#======================================================

# ==============Setting in/out Constraints================
# Note:
# clk_latency: 1.0 / 2.0 / 3.0 -- 作業design / Paper Design / 業界Design建議的數值
# clk_skew: 0.1 / 0.2 / 0.3-0.5 - 作業design / Paper Design / 業界Design建議的數值
# set_load   1 / 5~10 / 40 - PCB / 業界Design建議的數值 / TSRI測試機台 有I/O Pad的情況
# set_load 0.1               Logic  Cell的pin腳                      無I/O Pad合成Core Circuit的情況
# ========================================================

# SECTION (D-1) Setting Clock Constraints
create_clock -name $CLOCK_NAME -period $CYCLE [get_ports  $CLOCK_NAME]
set_ideal_network    -no_propagate [get_ports  $CLOCK_NAME]
set_dont_touch_network             [get_clocks $CLOCK_NAME]
# set_fix_hold                     [get_clocks $CLOCK_NAME]
set_clock_uncertainty       0.1    [get_clocks $CLOCK_NAME]
set_clock_latency   -source 0      [get_clocks $CLOCK_NAME]
set_clock_latency           1.0    [get_clocks $CLOCK_NAME]
set_input_transition        0.5    [all_inputs]
set_clock_transition        0.1    [all_clocks]

#!SECTION

# SECTION (D-2) Setting in/out Constraints
#set_dont_touch [get_cell ipad*] ; # IO Pad
#set_dont_touch [get_cell opad*] ; # IO Pad
set_input_delay   -max  $INPUT_DLY  -clock $CLOCK_NAME   [all_inputs] ;  # set_up time check
set_input_delay   -min  0           -clock $CLOCK_NAME   [all_inputs] ;  # hold   time check
set_output_delay  -max  $OUTPUT_DLY -clock $CLOCK_NAME   [all_outputs] ; # set_up time check
set_output_delay  -min  0           -clock $CLOCK_NAME   [all_outputs] ; # hold   time check
set_input_delay 0 -clock $CLOCK_NAME $RESET_NAME
# set_max_delay $CYCLE -from [all_inputs] -to [all_outputs]

# !SECTION

# SECTION (D-3) Setting Design Environment
# set_driving_cell -library umc18io3v5v_slow -lib_cell P2C    -pin {Y}  [get_ports $CLOCK_NAME]
# set_driving_cell -library umc18io3v5v_slow -lib_cell P2C    -pin {Y}  [remove_from_collection [all_inputs] [get_ports $CLOCK_NAME]]
set_drive       1        [all_inputs]
set_load        0.05     [all_outputs]

# !SECTION

# SECTION (D-4) Setting DRC Constraint
# set_max_delay           0     ; # Optimize delay max effort
set_max_area            0      ; # Optimize area max effort
set_max_transition      3       [all_inputs]   ; # U18 LUT Max Transition Value
set_max_capacitance     0.15    [all_inputs]   ; # U18 LUT Max Capacitance Value
set_max_fanout          20      [all_inputs]
# set_dont_touch [get_cells core_reg_macro]
# set hdlin_ff_always_sync_set_reset true

# !SECTION

# SECTION (D-5) Report Clock skew
report_clock -skew $CLOCK_NAME
check_timing

#!SECTION
#!SECTION

#======================================================
# SECTION - (E) Optimization
#======================================================
check_design > Report/$DESIGN\.check
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set case_analysis_with_logic_constants true
# set_fix_hold [all_clocks]

# SAIF Power Analysis & Optimization
#ANCHOR - SAIF
# read_saif -input $ROOT_PATH/03_GATE/$DESIGN.saif -instance_name testfixture/u_CONV
# set_dynamic_optimization true
# set_leakage_optimization true
# set_clock_gating_style -sequential_cell latch

# (E-1)
compile_ultra
# compile_ultra -gate_clock
# compile_ultra -inc -gate_clock

# (E-2)
# uniquify
# compile -boundary_optimization

# -boundary_optimization後進一步做優化
# compile_ultra -inc -area -no_autoungroup
# compile_ultra -area -no_autoungroup
# compile_ultra

#  二次進行微調優化(謹慎使用)
# optimize_registers

# 優化全部做完後再將多餘的"未連接線路"去除
# remove_unconnected_ports -blast_buses [get_cells * -hier]
#!SECTION

#======================================================
# SECTION (F) Output Reports
#======================================================
report_design                        > Report/$DESIGN\.design
report_resource   -hierarchy         > Report/$DESIGN\.resource
report_timing -max_paths 3           > Report/$DESIGN\.timing
report_area -hierarchy               > Report/$DESIGN\.area
report_power                         > Report/$DESIGN\.power
report_clock                         > Report/$DESIGN\.clock
report_port                          > Report/$DESIGN\.port
report_constraint -all_violators     > Report/$DESIGN\.constraint
report_qor                           > Report/$DESIGN\.qor
report_clock_gating                  > Report/$DESIGN\.gating
#!SECTION


#======================================================
# SECTION (G) Change Naming Rule
#======================================================
current_design [get_designs $DESIGN]
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule
#!SECTION


#======================================================
#SECTION (H) Output Results
#======================================================
set verilogout_higher_designs_first true
write   -format   verilog -hierarchy    -output           ./Netlist/$DESIGN\_syn\.v
write   -format   ddc     -hierarchy    -output           ./Netlist/$DESIGN\_syn\.ddc
write_sdf  -version 3.0 -context verilog -load_delay cell ./Netlist/$DESIGN\_syn.sdf -significant_digits 9
write_sdc                                                 ./Netlist/$DESIGN\_syn.sdc
#!SECTION


#======================================================
# SECTION (I) Finish and Quit
#======================================================

report_area
report_timing
exit

#!SECTION
