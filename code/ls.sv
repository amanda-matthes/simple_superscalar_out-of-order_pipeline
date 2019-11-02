/*
This module models a LS unit where
- Stores take 1 clock cycle
- Loads take 1 clock cycle 90% of the time and
        take 10 clock cycles 10% of the time
The returned values for Loads are total garbage
*/
module ls_unit (
        input wire clk, res_n,

        // To/From RS
        input wire valid_in,
        input wire [6:0] opcode_rs2ls,
        input wire [5:0] tag_rs2ls,
        input wire [63:0] rs1_rs2ls,
        input wire [63:0] rs2_rs2ls,
        input wire [5:0] rd_rs2ls,
        input wire [11:0] imm_rs2ls,

        output reg stop_ls2rsls,


        // To/From Commit
        output reg [63:0] result_ls2rob,
        output reg store_ls2rob,         // true if there is no result because the instruction was a store
        output reg [5:0] tag_ls2rob,
        output reg [5:0] rd_ls2rob,
        output reg valid_ls2rob
        );

    reg [31:0] randomNumber0;  // first 32 bits of a load
    reg [31:0] randomNumber1;  // second 32 bits of a load
    reg [31:0] randomNumber2; // Decides if there is a cache miss
    reg [3:0] counter; // counts to 10 if there is a cache miss


    always@(posedge clk or negedge res_n) begin
        randomNumber0 <= $urandom();      // first 32 bits of a load
        randomNumber1 <= $urandom();      // second 32 bits of a load
        randomNumber2 <= $urandom_range(9); // used to decide whether there is a cache miss

        if (~res_n) begin
            stop_ls2rsls   <= 0;
            valid_ls2rob   <= 0;
            store_ls2rob   <= 0;
            counter <= 0;
            randomNumber0 <= 0;
            randomNumber1 <= 0;
            randomNumber2 <= 0;

        end else begin
            // Take value from RS
            if (valid_in && ~stop_ls2rsls) begin
                rd_ls2rob       <= rd_rs2ls;
                result_ls2rob   <= {randomNumber0, randomNumber1};
                tag_ls2rob      <= tag_rs2ls;
                if (opcode_rs2ls == 7'b0100011) begin // SD
                    valid_ls2rob <= 1;
                    store_ls2rob <= 1;
                end else begin // LD
                    store_ls2rob <= 0;
                    if (randomNumber2 < 9) begin // Cache hit with 90% chance
                        valid_ls2rob <= 1;
                    end else begin // Cache miss with 10 % chance
                        valid_ls2rob <= 0;
                        stop_ls2rsls <= 1;
                    end
                end
            end else begin
                valid_ls2rob <= 0;
            end
            // Increment counter
            if (stop_ls2rsls && counter < 4'd9) begin
                counter++;
            end 
            // Finish LD
            if (stop_ls2rsls && counter == 4'd9) begin
                stop_ls2rsls    <= 0;
                counter         <= 0;
                valid_ls2rob       <= 1; // we assume that the commit can take in values every cycle
            end
        end
    end


endmodule