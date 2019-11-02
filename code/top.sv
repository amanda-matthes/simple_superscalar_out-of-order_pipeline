module top ();

    reg res_n;
    reg clk;
    reg valid_int;
    reg valid_ls;

    // From ID
    reg [4:0] rs1_int;
    reg [4:0] rs1_ls;

    reg [4:0] rs2_int;
    reg [4:0] rs2_ls;

    reg [4:0] rd_int;
    reg [4:0] rd_ls;

    reg [6:0] opcode_int;
    reg [6:0] opcode_ls;

    reg [2:0] funct3_int;
    reg [2:0] funct3_ls;

    reg [11:0] imm_int;
    reg [11:0] imm_ls;

    reg store;

    parameter PERIOD = 20;
    clock #(.PERIOD(PERIOD)) clk_I (clk);


    wire [5:0] freeMeUp_0_rob2rat;
    wire [5:0] freeMeUp_1_rob2rat;
    wire [5:0] rs1_ls_rat2rf;
    wire [5:0] rs1_int_rat2rf;
    wire [5:0] rs2_ls_rat2rf;
    wire [5:0] rs2_int_rat2rf;

    wire [5:0] rd_rat2rsls;
    wire [5:0] rd_rat2rsint;

    wire [5:0] freeMeUp_int_rat2rob;
    wire [5:0] freeMeUp_ls_rat2rob;

    wire done_rat;

    // RAT
    rat rat_I (
    .res_n(res_n),
    .clk(clk),
    .store(store),
    .valid_int_id2rat(valid_int),
    .valid_ls_id2rat(valid_ls),
    .rs1_ls_id2rat(rs1_ls),
    .rs1_int_id2rat(rs1_int),
    .rs2_ls_id2rat(rs2_ls),
    .rs2_int_id2rat(rs2_int),
    .rd_ls_id2rat(rd_ls),
    .rd_int_id2rat(rd_int),
    .freeMeUp_0_rob2rat(freeMeUp_0_rob2rat),
    .freeMeUp_1_rob2rat(freeMeUp_1_rob2rat),
    .rs1_ls_rat2rf(rs1_ls_rat2rf),
    .rs1_int_rat2rf(rs1_int_rat2rf),
    .rs2_ls_rat2rf(rs2_ls_rat2rf),
    .rs2_int_rat2rf(rs2_int_rat2rf),
    .done_rat(done_rat),
    .rd_rat2rsls(rd_rat2rsls),
    .rd_rat2rsint(rd_rat2rsint),
    .freeMeUp_int_rat2rob(freeMeUp_int_rat2rob),
    .freeMeUp_ls_rat2rob(freeMeUp_ls_rat2rob));

    wire [5:0] write_select_0_rob2rf;
    wire write_en_0_rob2rf;
    wire [63:0] value_0_rob2rf;
    wire [5:0] write_select_1_rob2rf;
    wire write_en_1_rob2rf;
    wire [63:0] value_1_rob2rf;

    wire [63:0] rs1_rf2rsint;
    wire valid_rs1_rf2rsint;
    wire [63:0] rs2_rf2rsint;
    wire valid_rs2_rf2rsint;
    wire [63:0] rs1_rf2rsls;
    wire valid_rs1_rf2rsls;
    wire [63:0] rs2_rf2rsls;
    wire valid_rs2_rf2rsls;

    wire done_rf2rs;

    // RF
    rf rf_I (
    .clk(clk),
    .res_n(res_n),
    .write_select_0_rob2rf(write_select_0_rob2rf),
    .write_en_0_rob2rf(write_en_0_rob2rf),
    .value_0_rob2rf(value_0_rob2rf),
    .write_select_1_rob2rf(write_select_1_rob2rf),
    .write_en_1_rob2rf(write_en_1_rob2rf),
    .value_1_rob2rf(value_1_rob2rf),
    // Read ports 0 and 1 belong to rs1 and rs2 of the integer unit
    // Read ports 2 and 3 belong to rs1 and rs2 of the ls unit
    .rs1_int_rat2rf(rs1_int_rat2rf),
    .rs2_int_rat2rf(rs2_int_rat2rf),
    .rs1_ls_rat2rf(rs1_ls_rat2rf),
    .rs2_ls_rat2rf(rs2_ls_rat2rf),
    .rs1_rf2rsint(rs1_rf2rsint),
    .valid_rs1_rf2rsint(valid_rs1_rf2rsint),
    .rs2_rf2rsint(rs2_rf2rsint),
    .valid_rs2_rf2rsint(valid_rs2_rf2rsint),
    .rs1_rf2rsls(rs1_rf2rsls),
    .valid_rs1_rf2rsls(valid_rs1_rf2rsls),
    .rs2_rf2rsls(rs2_rf2rsls),
    .valid_rs2_rf2rsls(valid_rs2_rf2rsls),
    .done_rat2rf(done_rat),
    .done_rf2rs(done_rf2rs));

    wire [63:0] result_int2rob;
    wire [5:0] tag_int2rob;
    wire [5:0] rd_int2rob;
    wire valid_int2rob;

    wire [63:0] result_ls2rob;
    wire [5:0] tag_ls2rob;
    wire [5:0] rd_ls2rob;
    wire valid_ls2rob;

    wire [5:0] tag_rob2rsint;
    wire [5:0] tag_rob2rsls;
    // ROB
    rob rob_I (
    .res_n(res_n),
    .clk(clk),
    .valid_int_id2rob(valid_int),
    .valid_ls_id2rob(valid_ls),
    .opcode_int_id2rob(opcode_int),
    .opcode_ls_id2rob(opcode_ls),
    .full_rob2ii(full_rob2ii),
    .freeMeUp_int_rat2rob(freeMeUp_int_rat2rob),
    .freeMeUp_ls_rat2rob(freeMeUp_ls_rat2rob),
    .done_rat2rob(done_rat),
    .result_int2rob(result_int2rob),
    .tag_int2rob(tag_int2rob),
    .rd_int2rob(rd_int2rob),
    .valid_int2rob(valid_int2rob),
    .result_ls2rob(result_ls2rob),
    .store_ls2rob(store_ls2rob),
    .tag_ls2rob(tag_ls2rob),
    .rd_ls2rob(rd_ls2rob),
    .valid_ls2rob(valid_ls2rob),
    .freeMeUp_0_rob2rat(freeMeUp_0_rob2rat),
    .freeMeUp_1_rob2rat(freeMeUp_1_rob2rat),
    .valid_rob2rat(valid_rob2rat),
    .tag_rob2int(tag_rob2rsint),
    .tag_rob2ls(tag_rob2rsls),
    .write_select_0_rob2rf(write_select_0_rob2rf),
    .write_en_0_rob2rf(write_en_0_rob2rf),
    .value_0_rob2rf(value_0_rob2rf),
    .write_select_1_rob2rf(write_select_1_rob2rf),
    .write_en_1_rob2rf(write_en_1_rob2rf),
    .value_1_rob2rf(value_1_rob2rf));

    wire [63:0] result_int2rs;
    wire valid_int2rs;
    wire [5:0] rd_int2rs;

    wire [63:0] result_ls2rs;
    wire valid_ls2rs;
    wire [5:0] rd_ls2rs;

    wire stop_int2rsint;
    wire [6:0] opcode_rsint2int;
    wire [2:0] funct3_rsint2int;
    wire [5:0] tag_rsint2int;
    wire [63:0] rs1_rsint2int;
    wire [63:0] rs2_rsint2int;
    wire [5:0] rd_rsint2int;
    wire [11:0] imm_rsint2int;
    wire valid_rsint2int;

    // RS INT
    rs rs_int_I (
    .res_n(res_n),
    .clk(clk),
    .opcode_id2rs(opcode_int),
    .funct3_id2rs(funct3_int),
    .imm_id2rs(imm_int),
    .valid_id2rs(valid_int),
    .full_rs2id(full_rsint2id),
    .rs1_rat2rs(rs1_int_rat2rf),
    .rs2_rat2rs(rs2_int_rat2rf),
    .rd_rat2rs(rd_rat2rsint),
    .tag_rob2rs(tag_rob2rsint),
    .rs1_rf2rs(rs1_rf2rsint),
    .valid_rs1_rf2rs(valid_rs1_rf2rsint),
    .rs2_rf2rs(rs2_rf2rsint),
    .valid_rs2_rf2rs(valid_rs2_rf2rsint),
    .done_rf2rs(done_rf2rs),
    .done_rat2rs(done_rat),
    .result_0_com2rs(value_0_rob2rf),
    .valid_0_com2rs(write_en_0_rob2rf),
    .rd_0_com2rs(write_select_0_rob2rf),
    .result_1_com2rs(value_1_rob2rf),
    .valid_1_com2rs(write_en_1_rob2rf),
    .rd_1_com2rs(write_select_1_rob2rf),
    .result_int2rs(result_int2rs),
    .valid_int2rs(valid_int2rs),
    .rd_int2rs(rd_int2rs),
    .result_ls2rs(result_ls2rs),
    .valid_ls2rs(valid_ls2rs),
    .rd_ls2rs(rd_ls2rs),
    .stop_ex2rs(stop_int2rsint),
    .opcode_rs2ex(opcode_rsint2int),
    .funct3_rs2ex(funct3_rsint2int),
    .tag_rs2ex(tag_rsint2int),
    .rs1_rs2ex(rs1_rsint2int),
    .rs2_rs2ex(rs2_rsint2int),
    .rd_rs2ex(rd_rsint2int),
    .imm_rs2ex(imm_rsint2int),
    .valid_rs2ex(valid_rsint2int));


    wire stop_ls2rsls;
    wire [6:0] opcode_rsls2ls;
    wire [2:0] funct3_rsls2ls;
    wire [5:0] tag_rsls2ls;
    wire [63:0] rs1_rsls2ls;
    wire [63:0] rs2_rsls2ls;
    wire [5:0] rd_rsls2ls;
    wire [11:0] imm_rsls2ls;
    wire valid_rsls2ls;


    // RS LS
    rs rs_ls_I (
    .res_n(res_n),
    .clk(clk),
    .opcode_id2rs(opcode_ls),
    .funct3_id2rs(funct3_ls),
    .imm_id2rs(imm_ls),
    .valid_id2rs(valid_ls),
    .full_rs2id(full_rsls2id),
    .rs1_rat2rs(rs1_ls_rat2rf),
    .rs2_rat2rs(rs2_ls_rat2rf),
    .rd_rat2rs(rd_rat2rsls),
    .tag_rob2rs(tag_rob2rsls),
    .rs1_rf2rs(rs1_rf2rsls),
    .valid_rs1_rf2rs(valid_rs1_rf2rsls),
    .rs2_rf2rs(rs2_rf2rsls),
    .valid_rs2_rf2rs(valid_rs2_rf2rsls),
    .done_rf2rs(done_rf2rs),
    .done_rat2rs(done_rat),
    .result_0_com2rs(value_0_rob2rf),
    .valid_0_com2rs(write_en_0_rob2rf),
    .rd_0_com2rs(write_select_0_rob2rf),
    .result_1_com2rs(value_1_rob2rf),
    .valid_1_com2rs(write_en_1_rob2rf),
    .rd_1_com2rs(write_select_1_rob2rf),
    .result_int2rs(result_int2rs),
    .valid_int2rs(valid_int2rs),
    .rd_int2rs(rd_int2rs),
    .result_ls2rs(result_ls2rs),
    .valid_ls2rs(valid_ls2rs),
    .rd_ls2rs(rd_ls2rs),
    .stop_ex2rs(stop_ls2rsls),
    .opcode_rs2ex(opcode_rsls2ls),
    .funct3_rs2ex(funct3_rsls2ls),
    .tag_rs2ex(tag_rsls2ls),
    .rs1_rs2ex(rs1_rsls2ls),
    .rs2_rs2ex(rs2_rsls2ls),
    .rd_rs2ex(rd_rsls2ls),
    .imm_rs2ex(imm_rsls2ls),
    .valid_rs2ex(valid_rsls2ls));

    // integer
    integer_unit integer_unit_I (
    .clk(clk),
    .res_n(res_n),
    .valid_in(valid_rsint2int),
    .opcode_in(opcode_rsint2int),
    .a_in(rs1_rsint2int),
    .b_in(rs2_rsint2int),
    .rd_in(rd_rsint2int),
    .tag_in(tag_rsint2int),
    .stop_int2rsint(stop_int2rsint),
    .result_int2rob(result_int2rob),
    .tag_int2rob(tag_int2rob),
    .rd_int2rob(rd_int2rob),
    .valid_int2rob(valid_int2rob));

    // ls
    ls_unit ls_unit_I (
    .clk(clk),
    .res_n(res_n),
    .valid_in(valid_rsls2ls),
    .opcode_rs2ls(opcode_rsls2ls),
    .tag_rs2ls(tag_rsls2ls),
    .rs1_rs2ls(rs1_rsls2ls),
    .rs2_rs2ls(rs2_rsls2ls),
    .rd_rs2ls(rd_rsls2ls),
    .imm_rs2ls(imm_rsls2ls),
    .stop_ls2rsls(stop_ls2rsls),
    .result_ls2rob(result_ls2rob),
    .store_ls2rob(store_ls2rob),
    .tag_ls2rob(tag_ls2rob),
    .rd_ls2rob(rd_ls2rob),
    .valid_ls2rob(valid_ls2rob));

    task initialise;
        begin
            res_n <= 1;

            rs1_int <= 0;
            rs1_ls <= 0;

            rs2_int <= 0;
            rs2_ls <= 0;

            rd_int <= 0;
            rd_ls <= 0;

            imm_int <= 0;
            imm_ls <= 0;

            opcode_int <= 0;
            opcode_ls <= 0;

            funct3_int <= 0;
            funct3_ls <= 0;

            valid_int <= 0;
            valid_ls <= 0;

            store <= 0;

            #PERIOD;
            reset();
        end
    endtask

    task reset;
        begin
            @(negedge clk) res_n <= 0;
            #PERIOD
            @(negedge clk) res_n <= 1;
        end
    endtask

    task sendADD;
        input [4:0] rs1;
        input [4:0] rs2;
        input [4:0] rd;
        begin
            rs1_int         <= rs1;
            rs2_int         <= rs2;
            rd_int          <= rd;
            opcode_int      <= 7'b0110011;  // ADD
        end
    endtask

    task sendLOAD;
        input [4:0] rs1;
        input [4:0] rs2;
        input [4:0] rd;
        begin
            opcode_ls           <= 7'b0000011;  // LD
            rs1_ls   <= rs1;
            rs2_ls   <= rs2;
            rd_ls    <= rd;
        end
    endtask

    task test1;
    begin
        // Demonstrates
        // 1. Renaming
        // 2. Instructions wait for their source operands in the reservation stations
        // 3. Depending on cache hits/misses these source ops can come
        //    a) forwarded from the execution unit
        //    b) from the commit path
        //    c) from the RF if it has already been written

        // LOAD registers
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 1;
        sendLOAD(.rd(5'd1), .rs1(5'd0), .rs2(5'd0));
        #1;
        @(negedge clk)
        sendLOAD(.rd(5'd2), .rs1(5'd0), .rs2(5'd0));
        #1;

        // ADD only
        @(negedge clk)
        valid_int <= 1;
        valid_ls  <= 0;
        sendADD(.rd(5'd3), .rs1(5'd1), .rs2(5'd2));
        #1;

        // ADD and LD
        @(negedge clk)
        valid_int <= 1;
        valid_ls  <= 1;
        sendADD(.rd(5'd3), .rs1(5'd3), .rs2(5'd2));
        sendLOAD(.rd(5'd2), .rs1(5'd0), .rs2(5'd0));
        #1;
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 0;
    end
    endtask

    task testSuperscalarity;
    begin
        // show that 2 instructions can simultaneously go through all the steps
        // only works if there is a cache hit
        // ADD R1 R0 R0
        // LD  R2 R0(0)
        @(negedge clk)
        valid_int <= 1;
        valid_ls  <= 1;
        sendADD(.rd(5'd1), .rs1(5'd0), .rs2(5'd0));
        sendLOAD(.rd(5'd2), .rs1(5'd0), .rs2(5'd0));
        #1;
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 0;
    end
    endtask

    initial begin
        initialise();

        // LOAD R1
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 1;
        sendLOAD(.rd(5'd1), .rs1(5'd0), .rs2(5'd0));
        #1;
        // LOAD R2
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 1;
        sendLOAD(.rd(5'd2), .rs1(5'd0), .rs2(5'd0));
        #1;
        // ADD R3 R1 R2
        @(negedge clk)
        valid_int <= 1;
        valid_ls  <= 0;
        sendADD(.rd(5'd3), .rs1(5'd1), .rs2(5'd2));
        #1;
        @(negedge clk)
        valid_int <= 0;
        valid_ls  <= 0;



        #350;
        $finish();
    end

endmodule