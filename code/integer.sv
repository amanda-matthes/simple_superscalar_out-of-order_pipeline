/*
TODO:
- Clean up names _in -> rs2int and _out -> int2rob
*/
module integer_unit (
        input wire clk, res_n,

        // To/From RS:
        input wire valid_in,
        input wire [6:0] opcode_in,
        input wire [63:0] a_in,
        input wire [63:0] b_in,
        input wire [5:0] rd_in,
        input wire [5:0] tag_in,
        output reg stop_int2rsint,

        // To/From Commit
        output reg [63:0] result_int2rob,
        output reg [5:0] tag_int2rob,
        output reg [5:0] rd_int2rob,
        output reg valid_int2rob
        );

always@(posedge clk or negedge res_n) begin
    if (~res_n) begin
        result_int2rob  <= 0;
        stop_int2rsint  <= 0;   // this version only does ADDs which only take one clock cycle so this will always be 0
        tag_int2rob     <= 0;
        rd_int2rob      <= 0;
        valid_int2rob   <= 0;
    end else begin
        if (valid_in) begin
            rd_int2rob          <= rd_in;
            result_int2rob      <= a_in+b_in;
            tag_int2rob         <= tag_in;
            valid_int2rob       <= 1;
        end else begin
            valid_int2rob  <= 0;
        end
        
    end
end
endmodule