
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -svseed random -s -input /home/amatthes/Documents/BachelorThesis/Code/testbenches/RAT_tb.tcl
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
set svseed 789179939
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves rat_tb.clk rat_tb.res_n rat_tb.rat_I.rd_int_id2rat rat_tb.rat_I.rs1_int_id2rat rat_tb.rat_I.rs2_int_id2rat rat_tb.rat_I.rd_ls_id2rat rat_tb.rat_I.rs1_ls_id2rat rat_tb.rat_I.rs2_ls_id2rat rat_tb.rat_I.getFreeRegisters.freeRegistersFound rat_tb.rat_I.freeRegister_0 rat_tb.rat_I.freeRegister_1 rat_tb.rs1_int_rat2rf rat_tb.rs1_ls_rat2rf rat_tb.rs2_int_rat2rf rat_tb.rs2_ls_rat2rf rat_tb.freeMeUp_0_rat2rob rat_tb.freeMeUp_1_rat2rob rat_tb.freeMeUp_0_rob2rat rat_tb.freeMeUp_1_rob2rat rat_tb.rd_rat2rsint rat_tb.rd_rat2rsls rat_tb.rat_I.rat rat_tb.rat_I.free

simvision -input RAT_tb.tcl.svcf
