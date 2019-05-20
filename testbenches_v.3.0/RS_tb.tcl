
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -svseed random -s -input /home/amatthes/Documents/BachelorThesis/Code/testbenches/RS_tb.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 632514021
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves rs_tb.rs_I.clk rs_tb.rs_I.res_n rs_tb.rs_I.freeRegister rs_tb.rs_I.currentRegister rs_tb.rs_I.valid_id2rs rs_tb.rs_I.opcode_id2rs rs_tb.rs_I.funct3_id2rs rs_tb.rs_I.imm_id2rs rs_tb.rs_I.valid_0_com2rs rs_tb.rs_I.rd_0_com2rs rs_tb.rs_I.result_0_com2rs rs_tb.rs_I.valid_1_com2rs rs_tb.rs_I.rd_1_com2rs rs_tb.rs_I.result_1_com2rs rs_tb.rs_I.free[0] rs_tb.rs_I.ready[0] rs_tb.rs_I.opcode[0] rs_tb.rs_I.rs1_address[0] rs_tb.rs_I.rs1_content[0] rs_tb.rs_I.rs1_valid[0] rs_tb.rs_I.rs2_address[0] rs_tb.rs_I.rs2_content[0] rs_tb.rs_I.rs2_valid[0] rs_tb.rs_I.free[1] rs_tb.rs_I.ready[1] rs_tb.rs_I.opcode[1] rs_tb.rs_I.rs1_address[1] rs_tb.rs_I.rs1_content[1] rs_tb.rs_I.rs1_valid[1] rs_tb.rs_I.rs2_address[1] rs_tb.rs_I.rs2_content[1] rs_tb.rs_I.rs2_valid[1] rs_tb.rs_I.free[2] rs_tb.rs_I.ready[2] rs_tb.rs_I.opcode[2] rs_tb.rs_I.rs1_address[2] rs_tb.rs_I.rs1_content[2] rs_tb.rs_I.rs1_valid[2] rs_tb.rs_I.rs2_address[2] rs_tb.rs_I.rs2_content[2] rs_tb.rs_I.rs2_valid[2] rs_tb.rs_I.free[3] rs_tb.rs_I.ready[3] rs_tb.rs_I.opcode[3] rs_tb.rs_I.rs1_address[3] rs_tb.rs_I.rs1_content[3] rs_tb.rs_I.rs1_valid[3] rs_tb.rs_I.rs2_address[3] rs_tb.rs_I.rs2_content[3] rs_tb.rs_I.rs2_valid[3]
probe -create -database waves rs_tb.rs_I.full_rs2id
probe -create -database waves rs_tb.rs_I.stop_ex2rs
probe -create -database waves rs_tb.rs_I.readyInstruction

simvision -input RS_tb.tcl.svcf
