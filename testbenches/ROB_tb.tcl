
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -svseed random -s -input /home/amatthes/Documents/BachelorThesis/Code/ROB_tb.tcl
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
set svseed 1472812321
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves rob_tb.rob_I.clk rob_tb.rob_I.res_n rob_tb.rob_I.full_rob2ii rob_tb.rob_I.freeMeUp_ii2rob rob_tb.rob_I.valid_ii2rob rob_tb.rob_I.wptr rob_tb.rob_I.rptr rob_tb.rob_I.freeMeUpTags[0] rob_tb.rob_I.results[0] rob_tb.rob_I.destinationRegs[0] rob_tb.rob_I.freeMeUpTags[1] rob_tb.rob_I.results[1] rob_tb.rob_I.destinationRegs[1] rob_tb.rob_I.freeMeUpTags[2] rob_tb.rob_I.results[2] rob_tb.rob_I.destinationRegs[2] rob_tb.rob_I.freeMeUpTags[3] rob_tb.rob_I.results[3] rob_tb.rob_I.destinationRegs[3] rob_tb.rob_I.freeMeUpTags[4] rob_tb.rob_I.results[4] rob_tb.rob_I.destinationRegs[4] rob_tb.rob_I.freeMeUpTags[5] rob_tb.rob_I.results[5] rob_tb.rob_I.destinationRegs[5]
probe -create -database waves rob_tb.rob_I.rd_ls2rob rob_tb.rob_I.result_ls2rob rob_tb.rob_I.store_ls2rob rob_tb.rob_I.tag_ls2rob rob_tb.rob_I.valid_ls2rob rob_tb.rob_I.rd_int2rob rob_tb.rob_I.result_int2rob rob_tb.rob_I.tag_int2rob rob_tb.rob_I.valid_int2rob
probe -create -database waves rob_tb.rob_I.readyToCommit[0] rob_tb.rob_I.readyToCommit[1] rob_tb.rob_I.readyToCommit[2] rob_tb.rob_I.readyToCommit[3]
probe -create -database waves rob_tb.rob_I.value_rob2rf rob_tb.rob_I.write_en rob_tb.rob_I.write_select

simvision -input ROB_tb.tcl.svcf
