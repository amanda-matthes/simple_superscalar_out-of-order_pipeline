
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s045
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -sv -linedebug -timescale 1ns/1ns -f module_list.f -svseed random -s -input /home/amatthes/Documents/BachelorThesis/Code/testbenches_v.3.0/TOP.tcl
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
set svseed -494576288
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves top.ls_unit_I.clk top.ls_unit_I.res_n top.valid_int top.opcode_int top.valid_ls top.opcode_ls top.rat_I.rat[0] top.rat_I.rat[1] top.rat_I.rat[2] top.rat_I.rat[3] top.rat_I.rat[4] top.rat_I.freeRegister_0 top.rat_I.freeRegister_1 top.rob_I.rptr top.rob_I.wptr top.rob_I.tag_rob2int top.rob_I.tag_rob2ls top.write_en_0_rob2rf top.rob_I.write_select_0_rob2rf top.rob_I.freeMeUp_0_rob2rat top.write_en_1_rob2rf top.rob_I.write_select_1_rob2rf top.rob_I.freeMeUp_1_rob2rat top.rob_I.valid_rob2rat top.rf_I.rf[0] top.rf_I.valid[0] top.rf_I.rf[1] top.rf_I.valid[1] top.rf_I.rf[2] top.rf_I.valid[2] top.rf_I.rf[3] top.rf_I.valid[3] top.rf_I.rf[4] top.rf_I.valid[4] top.integer_unit_I.valid_in top.integer_unit_I.a_in top.integer_unit_I.b_in top.integer_unit_I.rd_in top.integer_unit_I.opcode_in top.integer_unit_I.tag_in top.integer_unit_I.valid_int2rob top.integer_unit_I.rd_int2rob top.integer_unit_I.tag_int2rob top.integer_unit_I.stop_int2rsint top.ls_unit_I.counter top.ls_unit_I.stop_ls2rsls top.ls_unit_I.valid_ls2rob top.ls_unit_I.tag_rs2ls top.ls_unit_I.imm_rs2ls top.ls_unit_I.rs1_rs2ls top.ls_unit_I.rs2_rs2ls top.ls_unit_I.rd_rs2ls top.ls_unit_I.store_ls2rob top.rob_I.busy[0] top.rob_I.opcodes[0] top.rob_I.results[0] top.rob_I.destinationRegs[0] top.rob_I.freeMeUpTags[0] top.rob_I.readyToCommit[0] top.rob_I.busy[1] top.rob_I.opcodes[1] top.rob_I.results[1] top.rob_I.destinationRegs[1] top.rob_I.freeMeUpTags[1] top.rob_I.readyToCommit[1] top.rob_I.busy[2] top.rob_I.opcodes[2] top.rob_I.results[2] top.rob_I.destinationRegs[2] top.rob_I.freeMeUpTags[2] top.rob_I.readyToCommit[2] top.rob_I.busy[3] top.rob_I.opcodes[3] top.rob_I.results[3] top.rob_I.destinationRegs[3] top.rob_I.freeMeUpTags[3] top.rob_I.readyToCommit[3] top.rob_I.busy[4] top.rob_I.opcodes[4] top.rob_I.results[4] top.rob_I.destinationRegs[4] top.rob_I.freeMeUpTags[4] top.rob_I.readyToCommit[4] top.rob_I.busy[5] top.rob_I.opcodes[5] top.rob_I.results[5] top.rob_I.destinationRegs[5] top.rob_I.freeMeUpTags[5] top.rob_I.readyToCommit[5] top.rob_I.busy[6] top.rob_I.opcodes[6] top.rob_I.results[6] top.rob_I.destinationRegs[6] top.rob_I.freeMeUpTags[6] top.rob_I.readyToCommit[6] top.rob_I.busy[7] top.rob_I.opcodes[7] top.rob_I.results[7] top.rob_I.destinationRegs[7] top.rob_I.freeMeUpTags[7] top.rob_I.readyToCommit[7] top.rob_I.busy[8] top.rob_I.opcodes[8] top.rob_I.results[8] top.rob_I.destinationRegs[8] top.rob_I.freeMeUpTags[8] top.rob_I.readyToCommit[8] top.rs_int_I.clk top.rs_int_I.full_rs2id top.rs_int_I.free[0] top.rs_ls_I.ready[0] top.rs_int_I.opcode[0] top.rs_int_I.tag[0] top.rs_int_I.rs1_address[0] top.rs_int_I.rs1_content[0] top.rs_int_I.rs1_valid[0] top.rs_int_I.rs2_address[0] top.rs_int_I.rs2_content[0] top.rs_int_I.rs2_valid[0] top.rs_int_I.free[1] top.rs_ls_I.ready[1] top.rs_int_I.opcode[1] top.rs_int_I.tag[1] top.rs_int_I.rs1_address[1] top.rs_int_I.rs1_content[1] top.rs_int_I.rs1_valid[1] top.rs_int_I.rs2_address[1] top.rs_int_I.rs2_content[1] top.rs_int_I.rs2_valid[1] top.rs_int_I.free[2] top.rs_ls_I.ready[2] top.rs_int_I.opcode[2] top.rs_int_I.tag[2] top.rs_int_I.rs1_address[2] top.rs_int_I.rs1_content[2] top.rs_int_I.rs1_valid[2] top.rs_int_I.rs2_address[2] top.rs_int_I.rs2_content[2] top.rs_int_I.rs2_valid[2] top.rs_int_I.free[3] top.rs_ls_I.ready[3] top.rs_int_I.opcode[3] top.rs_int_I.tag[3] top.rs_int_I.rs1_address[3] top.rs_int_I.rs1_content[3] top.rs_int_I.rs1_valid[3] top.rs_int_I.rs2_address[3] top.rs_int_I.rs2_content[3] top.rs_int_I.rs2_valid[3] top.rs_ls_I.clk top.rs_ls_I.full_rs2id top.rs_ls_I.free[0] top.rs_ls_I.opcode[0] top.rs_ls_I.tag[0] top.rs_ls_I.rs1_address[0] top.rs_ls_I.rs1_content[0] top.rs_ls_I.rs2_address[0] top.rs_ls_I.rs2_content[0] top.rs_ls_I.free[1] top.rs_ls_I.opcode[1] top.rs_ls_I.tag[1] top.rs_ls_I.rs1_address[1] top.rs_ls_I.rs1_content[1] top.rs_ls_I.rs2_address[1] top.rs_ls_I.rs2_content[1] top.rs_ls_I.free[2] top.rs_ls_I.opcode[2] top.rs_ls_I.tag[2] top.rs_ls_I.rs1_address[2] top.rs_ls_I.rs1_content[2] top.rs_ls_I.rs2_address[2] top.rs_ls_I.rs2_content[2] top.rs_ls_I.free[3] top.rs_ls_I.opcode[3] top.rs_ls_I.tag[3] top.rs_ls_I.rs1_address[3] top.rs_ls_I.rs1_content[3] top.rs_ls_I.rs2_address[3] top.rs_ls_I.rs2_content[3]
probe -create -database waves top.rs_int_I.ready[0] top.rs_int_I.ready[1] top.rs_int_I.ready[2] top.rs_int_I.ready[3]
probe -create -database waves top.rs1_int top.rs2_int top.rd_int top.rs1_ls top.rs2_ls top.rd_ls
probe -create -database waves top.rob_I.value_0_rob2rf top.rob_I.value_1_rob2rf

simvision -input TOP.tcl.svcf
