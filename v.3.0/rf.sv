/*
This is the register file
It contains 64x64bit registers.

Currently it has
- Four read ports
- Two write port
*/

module rf ( input wire clk,
            input wire res_n,

            // To/From Commit
            input wire [5:0] write_select_0_rob2rf,
            input wire write_en_0_rob2rf,
            input wire [63:0] value_0_rob2rf,
            input wire [5:0] write_select_1_rob2rf,
            input wire write_en_1_rob2rf,
            input wire [63:0] value_1_rob2rf,

            // From RAT
            input wire [5:0] rs1_int_rat2rf,
            input wire [5:0] rs2_int_rat2rf,
            input wire [5:0] rs1_ls_rat2rf,
            input wire [5:0] rs2_ls_rat2rf,
            input wire done_rat2rf,

            // To RS
            output reg [63:0] rs1_rf2rsint,
            output reg valid_rs1_rf2rsint,
            output reg [63:0] rs2_rf2rsint,
            output reg valid_rs2_rf2rsint,
            output reg [63:0] rs1_rf2rsls,
            output reg valid_rs1_rf2rsls,
            output reg [63:0] rs2_rf2rsls,
            output reg valid_rs2_rf2rsls,
            output reg done_rf2rs               // both posedge and negedge indicate that the read is done

            );

    reg [63:0] rf [63:0];
    reg [63:0] valid;


    always@(done_rat2rf) begin
        rs1_rf2rsint                <= rf[rs1_int_rat2rf];
        valid_rs1_rf2rsint          <= valid[rs1_int_rat2rf];

        rs2_rf2rsint                <= rf[rs2_int_rat2rf];
        valid_rs2_rf2rsint          <= valid[rs2_int_rat2rf];

        rs1_rf2rsls                 <= rf[rs1_ls_rat2rf];
        valid_rs1_rf2rsls           <= valid[rs1_ls_rat2rf];

        rs2_rf2rsls                 <= rf[rs2_ls_rat2rf];
        valid_rs2_rf2rsls           <= valid[rs2_ls_rat2rf];

        done_rf2rs                  <= ~done_rf2rs;
    end

    always @(posedge clk or negedge res_n) begin
        if (~res_n) begin
            for (integer i = 1; i<64; i++) begin
                rf[i]       <= 0;
                valid[i]    <= 0;
            end
            rf[0]       <= 0;
            valid[0]    <= 1;
            done_rf2rs  <= 0;
        end else begin
            // write:
            if (write_en_0_rob2rf && (write_select_0_rob2rf != 6'b000_000)) begin
                rf[write_select_0_rob2rf]    <= value_0_rob2rf;
                valid[write_select_0_rob2rf] <= 1;
            end
            if (write_en_1_rob2rf && (write_select_1_rob2rf != 6'b000_000)) begin
                rf[write_select_1_rob2rf]    <= value_1_rob2rf;
                valid[write_select_1_rob2rf] <= 1;
            end
        end
    end
endmodule