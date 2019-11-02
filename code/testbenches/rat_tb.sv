module rat_tb;

    reg res_n;
    reg clk;
    reg valid_int_id2rat;
    reg valid_ls_id2rat;
    reg store;
    reg [4:0] rs1_ls_id2rat;
    reg [4:0] rs1_int_id2rat;
    reg [4:0] rs2_ls_id2rat;
    reg [4:0] rs2_int_id2rat;
    reg [4:0] rd_ls_id2rat;
    reg [4:0] rd_int_id2rat;
    reg [5:0] freeMeUp_0_rob2rat;
    reg [5:0] freeMeUp_1_rob2rat;
    wire [5:0] rs1_ls_rat2rf;
    wire [5:0] rs1_int_rat2rf;
    wire [5:0] rs2_ls_rat2rf;
    wire [5:0] rs2_int_rat2rf;
    wire [5:0] rd_rat2rsls;
    wire [5:0] rd_rat2rsint;
    wire [5:0] freeMeUp_0_rat2rob;
    wire [5:0] freeMeUp_1_rat2rob;
    parameter PERIOD = 20;
    clock #(.PERIOD(PERIOD)) clk_I (clk);

    rat rat_I (
    .res_n(res_n),
    .clk(clk),
    .store(store),
    .valid_int_id2rat(valid_int_id2rat),
    .valid_ls_id2rat(valid_ls_id2rat),
    .rs1_ls_id2rat(rs1_ls_id2rat),
    .rs1_int_id2rat(rs1_int_id2rat),
    .rs2_ls_id2rat(rs2_ls_id2rat),
    .rs2_int_id2rat(rs2_int_id2rat),
    .rd_ls_id2rat(rd_ls_id2rat),
    .rd_int_id2rat(rd_int_id2rat),
    .freeMeUp_0_rob2rat(freeMeUp_0_rob2rat),
    .freeMeUp_1_rob2rat(freeMeUp_1_rob2rat),
    .rs1_ls_rat2rf(rs1_ls_rat2rf),
    .rs1_int_rat2rf(rs1_int_rat2rf),
    .rs2_ls_rat2rf(rs2_ls_rat2rf),
    .rs2_int_rat2rf(rs2_int_rat2rf),
    .rd_rat2rsls(rd_rat2rsls),
    .rd_rat2rsint(rd_rat2rsint),
    .freeMeUp_int_rat2rob(freeMeUp_0_rat2rob),
    .freeMeUp_ls_rat2rob(freeMeUp_1_rat2rob));

    task initialise;
        begin
            res_n <= 1;
            rs1_ls_id2rat <= 0;
            rs1_int_id2rat <= 0;
            rs2_ls_id2rat <= 0;
            rs2_int_id2rat <= 0;
            rd_ls_id2rat <= 0;
            rd_int_id2rat <= 0;
            freeMeUp_0_rob2rat <= 0;
            freeMeUp_1_rob2rat <= 0;
            valid_int_id2rat <= 0;
            valid_ls_id2rat <= 0;
            store <= 0;
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

    task sendNOP;
        begin
            valid_int_id2rat <= 0;
            valid_ls_id2rat <= 0;
        end
    endtask

    task sendOneINT;
        input [4:0] rs1;
        input [4:0] rs2;
        input [4:0] rd;
        begin
            store <= 0;

            valid_int_id2rat <= 1;
            rs1_int_id2rat <= rs1;
            rs2_int_id2rat <= rs2;
            rd_int_id2rat  <= rd;

            valid_ls_id2rat <= 0;
        end
    endtask

    task sendOneLOAD;
        input [4:0] rs1;
        input [4:0] rs2;
        input [4:0] rd;
        begin
            store <= 0;

            valid_int_id2rat <= 0;

            valid_ls_id2rat <= 1;
            rs1_ls_id2rat   <= rs1;
            rs2_ls_id2rat   <= rs2;
            rd_ls_id2rat    <= rd;
        end
    endtask

    task sendOneINTAndOneLOAD;
        input [4:0] rs1_int;
        input [4:0] rs2_int;
        input [4:0] rd_int;
        input [4:0] rs1_ls;
        input [4:0] rs2_ls;
        input [4:0] rd_ls;
        begin
            store <= 0;

            valid_int_id2rat <= 1;
            rs1_int_id2rat <= rs1_int;
            rs2_int_id2rat <= rs2_int;
            rd_int_id2rat  <= rd_int;

            valid_ls_id2rat <= 1;
            rs1_ls_id2rat   <= rs1_ls;
            rs2_ls_id2rat   <= rs2_ls;
            rd_ls_id2rat    <= rd_ls;
        end
    endtask

    task testRenaming;
        begin
        // LD R1 (R0)
        // LD R2 (R0)
        // LD R3 (R0)
        // ADD R4 R1 R2
        // ADD R4 R4 R3
        @(negedge clk);
        sendOneLOAD(  .rd(5'd1),
                    .rs1(5'd0),
                    .rs2(5'd0));
        #1;
        @(negedge clk);
        sendOneLOAD(  .rd(5'd2),
                    .rs1(5'd0),
                    .rs2(5'd0));
        #1;
        @(negedge clk);
        sendOneLOAD(  .rd(5'd3),
                    .rs1(5'd0),
                    .rs2(5'd0));
        #1;
        @(negedge clk);
        sendOneINT( .rd(5'd4),
                    .rs1(5'd1),
                    .rs2(5'd2));
        #1;
        @(negedge clk);
        sendOneINT( .rd(5'd4),
                    .rs1(5'd4),
                    .rs2(5'd3));
        #1;
        @(negedge clk);
        sendNOP;
        end
    endtask

    initial begin
        //initialise;
        //testRenaming;

    end

endmodule