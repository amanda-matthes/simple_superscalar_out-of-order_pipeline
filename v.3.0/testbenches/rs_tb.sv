module rs_tb;

    reg res_n;
    reg clk;
    reg [6:0] opcode_id2rs;
    reg [2:0] funct3_id2rs;
    reg [11:0] imm_id2rs;
    reg valid_id2rs;
    wire full_rs2id;
    reg [5:0] rs1_rat2rs;
    reg [5:0] rs2_rat2rs;
    reg [5:0] rd_rat2rs;
    reg [5:0] tag_rob2rs;
    reg [63:0] rs1_rf2rs;
    reg valid_rs1_rf2rs;
    reg [63:0] rs2_rf2rs;
    reg valid_rs2_rf2rs;
    reg [63:0] result_0_com2rs;
    reg valid_0_com2rs;
    reg [5:0] rd_0_com2rs;
    reg [63:0] result_1_com2rs;
    reg valid_1_com2rs;
    reg [5:0] rd_1_com2rs;
    reg [63:0] result_int2rs;
    reg valid_int2rs;
    reg [5:0] rd_int2rs;
    reg [63:0] result_ls2rs;
    reg valid_ls2rs;
    reg [5:0] rd_ls2rs;
    reg stop_ex2rs;
    wire [6:0] opcode_rs2ex;
    wire [2:0] funct3_rs2ex;
    wire [5:0] tag_rs2ex;
    wire [63:0] rs1_rs2ex;
    wire [63:0] rs2_rs2ex;
    wire [5:0] rd_rs2ex;
    wire [11:0] imm_rs2ex;
    wire valid_rs2ex;

    parameter PERIOD = 20;
    clock #(.PERIOD(PERIOD)) clk_I (clk);

    rs rs_I (
    .res_n(res_n),
    .clk(clk),
    .opcode_id2rs(opcode_id2rs),
    .funct3_id2rs(funct3_id2rs),
    .imm_id2rs(imm_id2rs),
    .valid_id2rs(valid_id2rs),
    .full_rs2id(full_rs2id),
    .rs1_rat2rs(rs1_rat2rs),
    .rs2_rat2rs(rs2_rat2rs),
    .rd_rat2rs(rd_rat2rs),
    .tag_rob2rs(tag_rob2rs),
    .rs1_rf2rs(rs1_rf2rs),
    .valid_rs1_rf2rs(valid_rs1_rf2rs),
    .rs2_rf2rs(rs2_rf2rs),
    .valid_rs2_rf2rs(valid_rs2_rf2rs),
    .result_0_com2rs(result_0_com2rs),
    .valid_0_com2rs(valid_0_com2rs),
    .rd_0_com2rs(rd_0_com2rs),
    .result_1_com2rs(result_1_com2rs),
    .valid_1_com2rs(valid_1_com2rs),
    .rd_1_com2rs(rd_1_com2rs),
    .result_int2rs(result_int2rs),
    .valid_int2rs(valid_int2rs),
    .rd_int2rs(rd_int2rs),
    .result_ls2rs(result_ls2rs),
    .valid_ls2rs(valid_ls2rs),
    .rd_ls2rs(rd_ls2rs),
    .stop_ex2rs(stop_ex2rs),
    .opcode_rs2ex(opcode_rs2ex),
    .funct3_rs2ex(funct3_rs2ex),
    .tag_rs2ex(tag_rs2ex),
    .rs1_rs2ex(rs1_rs2ex),
    .rs2_rs2ex(rs2_rs2ex),
    .rd_rs2ex(rd_rs2ex),
    .imm_rs2ex(imm_rs2ex),
    .valid_rs2ex(valid_rs2ex));
    task initialise;
        begin
            res_n <= 1;
            opcode_id2rs <= 0;
            funct3_id2rs <= 0;
            imm_id2rs <= 0;
            valid_id2rs <= 0;
            rs1_rat2rs <= 0;
            rs2_rat2rs <= 0;
            rd_rat2rs <= 0;
            tag_rob2rs <= 0;
            rs1_rf2rs <= 0;
            valid_rs1_rf2rs <= 0;
            rs2_rf2rs <= 0;
            valid_rs2_rf2rs <= 0;
            result_0_com2rs <= 0;
            valid_0_com2rs <= 0;
            rd_0_com2rs <= 0;
            result_1_com2rs <= 0;
            valid_1_com2rs <= 0;
            rd_1_com2rs <= 0;
            result_int2rs <= 0;
            valid_int2rs <= 0;
            rd_int2rs <= 0;
            result_ls2rs <= 0;
            valid_ls2rs <= 0;
            rd_ls2rs <= 0;
            stop_ex2rs <= 0;
            #PERIOD
            reset;
        end
    endtask

    task reset;
        begin
            @(negedge clk) res_n <= 0;
            #PERIOD
            @(negedge clk) res_n <= 1;
        end
    endtask

    task rs1FromRFandRs2FromCOM;
        @(negedge clk)
        opcode_id2rs <= 7'b0110011;
        funct3_id2rs <= 3'b000;
        imm_id2rs    <= 0;
        valid_id2rs     <= 1;
        tag_rob2rs <= 6'd13;

        @(posedge clk) // ADD P1 P3 P4
        #5;
        rs1_rat2rs <= 6'd3;
        rs2_rat2rs <= 6'd4;
        rd_rat2rs  <= 6'd1;
        #5;
        // Get rs1 directly from the RF
        rs1_rf2rs       <= 64'd530;
        valid_rs1_rf2rs <= 1;
        valid_rs2_rf2rs <= 0;

        #5;
        valid_id2rs <= 0;

        #PERIOD;
        @(negedge clk)
        // Get rs2 from the commit path
        result_1_com2rs <= 64'd714;
        rd_1_com2rs     <= 6'd4;
        valid_1_com2rs  <= 1;

        #1;
        @(negedge clk)
        valid_1_com2rs  <= 0;
        stop_ex2rs      <= 0;
    endtask

    task testFWDpaths;
        @(negedge clk)
        opcode_id2rs <= 7'b0110011;
        funct3_id2rs <= 3'b000;
        imm_id2rs    <= 0;
        valid_id2rs     <= 1;
        tag_rob2rs <= 6'd13;

        @(posedge clk) // ADD P1 P3 P4
        #5;
        rs1_rat2rs <= 6'd3;
        rs2_rat2rs <= 6'd4;
        rd_rat2rs  <= 6'd1;
        #5;
        valid_rs1_rf2rs <= 0;
        valid_rs2_rf2rs <= 0;

        #5;
        valid_id2rs <= 0;

        #PERIOD;
        @(negedge clk)
        // Get rs1 from the int fwd path
        result_int2rs <= 64'd859;
        rd_int2rs     <= 6'd3;
        valid_int2rs  <= 1;
        #1;
        @(negedge clk)
        // Get rs2 from the ls fwd path
        result_ls2rs <= 64'd721;
        rd_ls2rs     <= 6'd4;
        valid_ls2rs  <= 1;

        #1;
        @(negedge clk)
        valid_1_com2rs  <= 0;
        stop_ex2rs      <= 0;
    endtask

    task sendAdd;
        @(negedge clk)
        opcode_id2rs <= 7'b0110011;
        funct3_id2rs <= 3'b000;
        imm_id2rs    <= 0;
        valid_id2rs     <= 1;
        tag_rob2rs <= 6'd13;
        @(posedge clk) // ADD P1 P3 P4
        #5;
        rs1_rat2rs <= 6'd3;
        rs2_rat2rs <= 6'd4;
        rd_rat2rs  <= 6'd1;
        #5;
        // Get rs1 directly from the RF
        rs1_rf2rs       <= 64'd323;
        rs2_rf2rs       <= 64'd545;
        valid_rs1_rf2rs <= 1;
        valid_rs2_rf2rs <= 1;
    endtask

    task fillingUpTheRS;
        // Demonstrates:
        // - Filling up the registers one by one
        // - full and free tags.
        // - Freeing of the regsiters one by one
        sendAdd();
        sendAdd();
        sendAdd();
        sendAdd();
        valid_id2rs <= 0;

        #PERIOD;
        @(negedge clk)
        stop_ex2rs <= 0;

    endtask
    initial begin
        initialise;
        stop_ex2rs <= 1;
        //testFWDpaths();
        rs1FromRFandRs2FromCOM();

    end
endmodule