/*
Reservation station where up to 4 instructions can wait for their source operands / for the execution unit to free up.
When the source operands have already been written to the RF they are read when the instruction is loaded in the the RS.
The RS listens in on the forwarding paths and the commit path

TODO
- Mux the immediate
*/

module rs (
            input wire res_n, input wire clk,

            // From ID
            input wire [6:0] opcode_id2rs,
            input wire [2:0] funct3_id2rs,
            input wire [11:0] imm_id2rs,
            input wire valid_id2rs,

            // To ID
            output wire full_rs2id,

            // From RAT
            input wire [5:0] rs1_rat2rs,
            input wire [5:0] rs2_rat2rs,
            input wire [5:0] rd_rat2rs,
            input wire done_rat2rs,

            // From ROB
            input wire [5:0] tag_rob2rs,

            // From RF
            input wire [63:0] rs1_rf2rs,
            input wire valid_rs1_rf2rs,
            input wire [63:0] rs2_rf2rs,
            input wire valid_rs2_rf2rs,
            input wire done_rf2rs,

            // From COMmit forwarding path
            input wire [63:0] result_0_com2rs,
            input wire valid_0_com2rs,
            input wire [5:0] rd_0_com2rs,
            input wire [63:0] result_1_com2rs,
            input wire valid_1_com2rs,
            input wire [5:0] rd_1_com2rs,

            // From EXecution untis forwarding paths
            input wire [63:0] result_int2rs,
            input wire valid_int2rs,
            input wire [5:0] rd_int2rs,
            input wire [63:0] result_ls2rs,
            input wire valid_ls2rs,
            input wire [5:0] rd_ls2rs,

            // To/From execution unit:
            input wire stop_ex2rs,
            output reg [6:0] opcode_rs2ex,
            output reg [2:0] funct3_rs2ex,
            output reg [5:0] tag_rs2ex,
            output reg [63:0] rs1_rs2ex,
            output reg [63:0] rs2_rs2ex,
            output reg [5:0] rd_rs2ex,      // superfluos in the LS unit
            output reg [11:0] imm_rs2ex,    // superfluos in the integer unit // TODO will be replaced by rs1/rs2 (?)
            output reg valid_rs2ex
            );

    parameter DEPTH = 4;
    reg [5:0]  rs1_address  [DEPTH-1:0];
    reg [63:0] rs1_content  [DEPTH-1:0];
    reg        rs1_valid    [DEPTH-1:0];

    reg [5:0]  rs2_address  [DEPTH-1:0];
    reg [63:0] rs2_content  [DEPTH-1:0];
    reg         rs2_valid   [DEPTH-1:0];

    reg [5:0]  rd           [DEPTH-1:0];

    reg [6:0] opcode        [DEPTH-1:0];
    reg [2:0] funct3        [DEPTH-1:0];
    reg [11:0] imm          [DEPTH-1:0];

    reg [5:0] tag           [DEPTH-1:0];

    reg free                [DEPTH-1:0];
    assign full_rs2id = (~free[0]
                        && ~free[1]
                        && ~free[2]
                        && ~free[3]) ? 1 : 0;

    // An instruction is ready iff both its source operands are valid
    wire ready              [DEPTH-1:0];
    assign ready[0] = (rs1_valid[0] && rs2_valid[0]); //? 1 : 0;
    assign ready[1] = (rs1_valid[1] && rs2_valid[1]); //? 1 : 0;
    assign ready[2] = (rs1_valid[2] && rs2_valid[2]); //? 1 : 0;
    assign ready[3] = (rs1_valid[3] && rs2_valid[3]); //? 1 : 0;

    reg [1:0] freePointer; // always points to a free slot for a new instruction, if there is one
    reg [1:0] currentPointer; // register that is being currently used by the RAT, ROB and RF to load in a new instruction
    always@(*) begin
        casex ({free[0], free[1], free[2], free[3]})
            4'b1xxx: freePointer = 2'b00;
            4'b01xx: freePointer = 2'b01;
            4'b001x: freePointer = 2'b10;
            4'b0001: freePointer = 2'b11;
        endcase
    end

    reg [1:0] readyInstruction; // points to an instruction that is ready to be executed, if there is one
    // This is the mux that selects one instruction for execution (if any is ready)
    always@(*) begin
        casex ({ready[0], ready[1], ready[2], ready[3]})
            4'b1xxx: begin
                opcode_rs2ex    = opcode[0];
                funct3_rs2ex    = funct3[0];
                tag_rs2ex       = tag[0];
                rs1_rs2ex       = rs1_content[0];
                rs2_rs2ex       = rs2_content[0];
                rd_rs2ex        = rd[0];
                imm_rs2ex       = imm[0];
                readyInstruction = 2'b00;
                valid_rs2ex     = 1;
            end
            4'b01xx: begin
                opcode_rs2ex    = opcode[1];
                funct3_rs2ex    = funct3[1];
                tag_rs2ex       = tag[1];
                rs1_rs2ex       = rs1_content[1];
                rs2_rs2ex       = rs2_content[1];
                rd_rs2ex        = rd[1];
                imm_rs2ex       = imm[1];
                readyInstruction = 2'b01;
                valid_rs2ex     = 1;
            end
            4'b001x: begin
                opcode_rs2ex    = opcode[2];
                funct3_rs2ex    = funct3[2];
                tag_rs2ex       = tag[2];
                rs1_rs2ex       = rs1_content[2];
                rs2_rs2ex       = rs2_content[2];
                rd_rs2ex        = rd[2];
                imm_rs2ex       = imm[2];
                readyInstruction = 2'b10;
                valid_rs2ex     = 1;
            end
            4'b0001: begin
                opcode_rs2ex    = opcode[3];
                funct3_rs2ex    = funct3[3];
                tag_rs2ex       = tag[3];
                rs1_rs2ex       = rs1_content[3];
                rs2_rs2ex       = rs2_content[3];
                rd_rs2ex        = rd[3];
                imm_rs2ex       = imm[3];
                readyInstruction = 2'b11;
                valid_rs2ex     = 1;
            end
            4'b0000: begin
                valid_rs2ex = 0;
            end
        endcase
    end

    // Get data from RAT
    always@(done_rat2rs) begin
        rd[currentPointer]            <= rd_rat2rs;
        rs1_address[currentPointer]   <= rs1_rat2rs;
        rs2_address[currentPointer]   <= rs2_rat2rs;
    end


    // Get data from RF
    always@(done_rf2rs) begin
        if(valid_id2rs && valid_rs1_rf2rs) begin
            rs1_content[currentPointer]    <= rs1_rf2rs;
            rs1_valid[currentPointer]      <= 1;
        end
        if(valid_id2rs && valid_rs2_rf2rs) begin
            rs2_content[currentPointer]    <= rs2_rf2rs;
            rs2_valid[currentPointer]      <= 1;
        end
    end

    // Get data from commit path for the instruction just coming in (has to happen later)
    always@(done_rat2rs) begin
        if(valid_id2rs && valid_0_com2rs && (rd_0_com2rs == rs1_rat2rs)) begin
            rs1_content[currentPointer]    <= result_0_com2rs;
            rs1_valid[currentPointer]      <= 1;
        end
        if(valid_id2rs && valid_1_com2rs && (rd_1_com2rs == rs1_rat2rs)) begin
            rs1_content[currentPointer]    <= result_1_com2rs;
            rs1_valid[currentPointer]      <= 1;
        end
        if(valid_id2rs && valid_0_com2rs && (rd_0_com2rs == rs2_rat2rs)) begin
            rs2_content[currentPointer]       <= result_0_com2rs;
            rs2_valid[currentPointer]      <= 1;
        end
        if(valid_id2rs && valid_1_com2rs && (rd_1_com2rs == rs2_rat2rs)) begin
            rs2_content[currentPointer]    <= result_1_com2rs;
            rs2_valid[currentPointer]      <= 1;
        end
    end


    always@(posedge clk or negedge res_n) begin
        if (~res_n) begin
            for (int i=0; i<DEPTH; i++) begin
                rs1_address[i]  <= 0;
                rs1_content[i]  <= 0;
                rs1_valid[i]    <= 0;
                rs2_address[i]  <= 0;
                rs2_content[i]  <= 0;
                rs2_valid[i]    <= 0;
                rd[i]           <= 0;
                opcode[i]       <= 0;
                funct3[i]       <= 0;
                imm[i]          <= 0;
                tag[i]          <= 0; //6'b111111;
                free[i]         <= 1;
            end

        end else begin
            currentPointer <= freePointer;

            // Get data from ID
            if (valid_id2rs) begin
                free[freePointer]       <= 0;
                opcode[freePointer]     <= opcode_id2rs;
                funct3[freePointer]     <= funct3_id2rs;
                imm[freePointer]        <= imm_id2rs;

                tag[freePointer]        <= tag_rob2rs;
            end

            // Get data from commit (compare only with instructions that are already waiting)
            if (valid_0_com2rs) begin
                for (int i=0; i<DEPTH; i++) begin
                    if (~free[i]) begin
                        if (rd_0_com2rs == rs1_address[i]) begin
                            rs1_content[i]  <= result_0_com2rs;
                            rs1_valid[i]    <= 1;
                        end
                        if (rd_0_com2rs == rs2_address[i]) begin
                            rs2_content[i]  <= result_0_com2rs;
                            rs1_valid[i]    <= 1;
                        end
                    end
                end
            end
            if (valid_1_com2rs) begin
                for (int i=0; i<DEPTH; i++) begin
                    if (~free[i]) begin
                        if (rd_1_com2rs == rs1_address[i]) begin
                            rs1_content[i]  <= result_1_com2rs;
                            rs1_valid[i]    <= 1;
                        end
                        if (rd_1_com2rs == rs2_address[i]) begin
                            rs2_content[i]  <= result_1_com2rs;
                            rs2_valid[i]     <= 1;
                        end
                    end
                end
            end
            // Get data from forwarding path (compare only with instructions that are already waiting)
            if (valid_int2rs) begin
                for (int i=0; i<DEPTH; i++) begin
                    if (~free[i]) begin
                        if (rd_int2rs == rs1_address[i]) begin
                            rs1_content[i]  <= result_int2rs;
                            rs1_valid[i]    <= 1;
                        end
                        if (rd_int2rs == rs2_address[i]) begin
                            rs2_content[i]  <= result_int2rs;
                            rs2_valid[i]    <= 1;
                        end
                    end
                end
            end
            if (valid_ls2rs) begin
                for (int i=0; i<DEPTH; i++) begin
                    if (~free[i]) begin
                        if (rd_ls2rs == rs1_address[i]) begin
                            rs1_content[i]  <= result_ls2rs;
                            rs1_valid[i]    <= 1;
                        end
                        if (rd_ls2rs == rs2_address[i]) begin
                            rs2_content[i]  <= result_ls2rs;
                            rs2_valid[i]    <= 1;
                        end
                    end
                end
            end

            // Send to execution unit
            if (valid_rs2ex & ~stop_ex2rs) begin
                free[readyInstruction]  <= 1;
                rs1_valid[readyInstruction] <= 0;
                rs2_valid[readyInstruction] <= 0;
            end
        end
    end
endmodule