
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -s -input /home/amatthes/Documents/BachelorThesis/Code/RF_tb.tcl
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
set svseed 1
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves instruction_issue_tb.ii_I.clk instruction_issue_tb.ii_I.res_n instruction_issue_tb.ii_I.rat[0] instruction_issue_tb.ii_I.rat[1] instruction_issue_tb.ii_I.rat[2] instruction_issue_tb.ii_I.rat[3] instruction_issue_tb.ii_I.rat[4] instruction_issue_tb.ii_I.freeRegister instruction_issue_tb.ii_I.instr_if2ii instruction_issue_tb.ii_I.valid_if2ii instruction_issue_tb.ii_I.i_06_00_if2ii instruction_issue_tb.ii_I.i_11_07_if2ii instruction_issue_tb.ii_I.i_14_12_if2ii instruction_issue_tb.ii_I.i_19_15_if2ii instruction_issue_tb.ii_I.i_24_20_if2ii instruction_issue_tb.ii_I.valid_ii2rsls instruction_issue_tb.ii_I.opcode_ii2rsls instruction_issue_tb.ii_I.funct3_ii2rsls instruction_issue_tb.ii_I.tag_ii2rsls instruction_issue_tb.ii_I.rs2_ii2rsls instruction_issue_tb.ii_I.rs1_ii2rsls instruction_issue_tb.ii_I.imm_ii2rsls instruction_issue_tb.ii_I.valid_ii2rsint instruction_issue_tb.ii_I.opcode_ii2rsint instruction_issue_tb.ii_I.funct3_ii2rsint instruction_issue_tb.ii_I.tag_ii2rsint instruction_issue_tb.ii_I.rs1_ii2rsint instruction_issue_tb.ii_I.rs2_ii2rsint instruction_issue_tb.ii_I.rd_ii2rsint instruction_issue_tb.ii_I.freeMeUp_ii2rob instruction_issue_tb.ii_I.valid_ii2rob
probe -create -database waves rs_tb.rs_I.rd_rs2ex
probe -create -database waves rs_tb.rs_I.rd_ii2rs
probe -create -database waves integer_tb.integer_unit_I.clk integer_tb.integer_unit_I.res_n integer_tb.integer_unit_I.opcode_in integer_tb.integer_unit_I.a_in integer_tb.integer_unit_I.b_in integer_tb.integer_unit_I.rd_in integer_tb.integer_unit_I.tag_in integer_tb.integer_unit_I.busy_out integer_tb.integer_unit_I.result_out integer_tb.integer_unit_I.rd_out integer_tb.integer_unit_I.tag_out
probe -create -database waves rs_tb.rs_I.clk rs_tb.rs_I.res_n rs_tb.rs_I.opcode_ii2rs rs_tb.rs_I.funct3_ii2rs rs_tb.rs_I.tag_ii2rs rs_tb.rs_I.rs1_ii2rs rs_tb.rs_I.rs2_ii2rs rs_tb.rs_I.imm_ii2rs rs_tb.rs_I.opcode_rs2ex rs_tb.rs_I.rs1_rs2ex rs_tb.rs_I.rs2_rs2ex rs_tb.rs_I.tag_rs2ex
probe -create -database waves rs_tb.rs_I.regSelect1_rs2rf rs_tb.rs_I.regSelect2_rs2rf
probe -create -database waves rs_tb.rs_I.valid_rs2ex
probe -create -database waves rs_tb.rs_I.ready_ex2rs rs_tb.rs_I.full_rs2ii
probe -create -database waves rs_tb.rs_I.valid_ii2rs rs_tb.rs_I.imm_rs2ex
probe -create -database waves rf_tb.rf_I.clk rf_tb.rf_I.res_n rf_tb.rf_I.valid rf_tb.rf_I.rf rf_tb.rf_I.data_in rf_tb.rf_I.write_select rf_tb.rf_I.write_en
probe -create -database waves rf_tb.rf_I.read_select0 rf_tb.rf_I.data_out0
probe -create -database waves rf_tb.rf_I.read_select1 rf_tb.rf_I.data_out1 rf_tb.rf_I.read_select2 rf_tb.rf_I.data_out2 rf_tb.rf_I.read_select3 rf_tb.rf_I.data_out3
probe -create -database waves rf_tb.rf_I.valid_out0 rf_tb.rf_I.valid_out1 rf_tb.rf_I.valid_out2 rf_tb.rf_I.valid_out3

simvision -input RF_tb.tcl.svcf
