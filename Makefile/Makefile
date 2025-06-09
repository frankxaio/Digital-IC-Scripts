.PHONY:syn syn_dv read_dv_rtl read_ddc vcs_rtl vcs_gate irun_rtl irun_gate xrun_rtl xrun_gate nWave verdi_rtl verdi_gate clean

######################################
# Set your desired file names
######################################
top_design=BoothMUL
source_rtl_file="$(ROOT_PATH)/00_TESTBED/rtl_sim.f"	# Name of your source file
source_gate_file="$(ROOT_PATH)/00_TESTBED/gate_sim.f"	# Name of your source file
output_file="simv"      	# Desired output simulation file name
log_file="vcs.log"      	# Desired log file name
syn_tcl="syn.tcl"       	# Name of your synthesis tcl file
syn_log="syn.log"       	# Name of your synthesis log file
pt_tcl="pt.tcl"       	# Name of your synthesis tcl file
pt_log="pt.log"       	# Name of your synthesis log file

######################################
# Default Setting
######################################
num_CPU_cores=4               # Maximum Number of CPU that used for simulation/synthesis
TIMESCALE=-timescale=1ns/1fs
TIMESCALE1=-timescale 1ns/1fs
DW_SIM=/usr/Synopsys/syn/T-2022.03-SP2/dw/sim_ver
UMC018_SIM=/cad/CBDK/CBDK_UMC018_ITRI_v0.8/CIC/Verilog/UDVS_u018mm.v
UMC018_IO_SIM=/cad/CBDK/CBDK_UMC018_ITRI_v0.8/CIC/Verilog/U018IOCUP.v
ICC013_SIM=/cad/CBDK/CBDK_IC_Contest_v2.5/Verilog/tsmc13_neg.v
T18_SIM=/cad/CBDK/CBDK_TSMC018_Arm_f1.0/CIC/Verilog/tsmc18.v

######################################
# Simulation Option and Command
######################################

# =====================================
# ============== VCS ==================
# =====================================
RTL = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -q \
    -kdb \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_rtl_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI_HOME}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI_HOME}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +notimingchecks



GATE = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    -kdb \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -f ${source_gate_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI_HOME}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI_HOME}/share/PLI/VCS/linux64/pli.a \
	-v ${T18_SIM} \
    +define+GATE \
	+neg_tchk \
    -neg_delay \

POST = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    -v ${UMC018_SIM} \
	-v ${UMC018_IO_SIM} \
    +define+POST \
    +neg_tchk


# =====================================
# ============= verdi =================
# =====================================
nWave_ON = nWave -ssf *.fsdb

VERDI_RTL_ON = verdi -ssf *.fsdb \
    -f ${source_rtl_file} \
	-sv \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_GATE_ON = verdi -ssf *.fsdb \
    -f ${source_gate_file} \
	-sv \
    -nologo           \
	+define+GATE	  \
	+v2k \
	-autoalias

# =====================================
# ========== Design Compiler ==========
# =====================================
DC_shell = dcnxt_shell -f ${syn_tcl} \
	-x "set_host_options -max_cores ${num_CPU_cores}" \
    -output_log_file ${syn_log}

DC_shell_gui = dcnxt_shell -f ${syn_tcl} \
	-x "set_host_options -max_cores ${num_CPU_cores}" \
    -output_log_file ${syn_log} \
	-gui

Read_DC_shell_gui = dcnxt_shell -x 'read_sverilog ${top_design}.v' -gui
Read_DDC_shell_gui = dcnxt_shell -x "read_ddc ${top_design}_SYN.ddc" -gui
SAIF = fsdb2saif ${top_design}.fsdb  -o ${top_design}.saif

# =====================================
# ========== Prime Time		 ==========
# =====================================
PT_shell = pt_shell -f ${pt_tcl} \
	-x "set_host_options -max_cores ${num_CPU_cores}" \
    -output_log_file ${pt_log}

# =====================================
# ==========   INNOVUS APR   ==========
# =====================================

INNOVUS_INIT = innovus -cpus ${num_CPU_cores} \
	-init ./cmd/run_apr.cmd \
	-log ./log/run_apr.log \
	-cmd ./log/run_apr.cmdlog

# =====================================
# ============= clean =================
# =====================================
clean_vcs = rm -rf *.fsdb ./csrc *.log simv* *.sdf.X *.key verdi_config_file
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log
clean_syn = rm -rf ./Netlist/*.* ./Report/*.* *.log alib* *.svf dwsvf* *.ddc *.pvl *.syn *.mr csrc fsdb2saifLog WORK
clean_power = rm -rf vcd.out ./fsdb2vcdLog ./Report/*
clean_apr = rm -rf checkDesign \
            rm -rf *.log \
            rm -rf *.rpt* \
            rm -rf *.CCOPT.spec \
            rm -rf *.checkPlace \
            rm -rf ./StreamOut/* CHIP_SYN.v \
            rm -rf *.globals \
            rm -rf extLogDir \
            rm -rf ./log/* \
            rm -rf ./DBS/* \
            rm -rf ./timingReports/* \
            rm -rf *.bin
# =====================================

rtl:
	${RTL}

gate:
	${GATE}

post:
	${POST}

syn:
	${DC_shell}

syn_dv:
	${DC_shell_gui}

read_dv_rtl:
	${Read_DC_shell_gui}

read_ddc:
	${Read_DDC_shell_gui}

saif:
	${SAIF}

pt:
	${PT_shell}

nWave:
	${nWave_ON}

verdi_rtl:
	${VERDI_RTL_ON}

verdi_gate:
	${VERDI_GATE_ON}

apr_init:
	${INNOVUS_INIT}


clean:
	${clean_vcs}
	${clean_verdi}
	${clean_syn}
	${clean_power}
	${clean_apr}
