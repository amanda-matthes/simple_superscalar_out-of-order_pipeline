
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -svseed random -s -input /home/amatthes/Documents/BachelorThesis/Code/LS_tb.tcl
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
set svseed 1226347509
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves ls_unit_tb.ls_unit_I.clk ls_unit_tb.ls_unit_I.res_n ls_unit_tb.ls_unit_I.opcode_rs2ex ls_unit_tb.ls_unit_I.rs1_rs2ex ls_unit_tb.ls_unit_I.rs2_rs2ex ls_unit_tb.ls_unit_I.rd_rs2ex ls_unit_tb.ls_unit_I.imm_rs2ex ls_unit_tb.ls_unit_I.tag_rs2ex ls_unit_tb.ls_unit_I.valid_in ls_unit_tb.ls_unit_I.result_out ls_unit_tb.ls_unit_I.rd_out ls_unit_tb.ls_unit_I.tag_out ls_unit_tb.ls_unit_I.valid_out ls_unit_tb.ls_unit_I.busy_out ls_unit_tb.ls_unit_I.randomNumber0 ls_unit_tb.ls_unit_I.randomNumber1 ls_unit_tb.ls_unit_I.randomNumber2
probe -create -database waves ls_unit_tb.ls_unit_I.counter

simvision -input LS_tb.tcl.svcf
