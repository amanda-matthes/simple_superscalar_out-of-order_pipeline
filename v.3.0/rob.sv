/*
The ROB gives instructions in the Instruction Issuer tags and once they leave
the Execution unit, their results are written back in the ROB and then written
to the RF in order.

Right now the ROB always takes and gives TWO instructions
It has a depth of 64, so its tags are 6 bit long

The ROB also saves the opcode of instructions. This is not necessary but makes debugging
much easier


*/
module rob #(TAGLENGTH = 6)(
        input wire res_n, input wire clk,

        // From/To ID
        input wire valid_int_id2rob,
        input wire valid_ls_id2rob,

        input wire [6:0] opcode_int_id2rob,
        input wire [6:0] opcode_ls_id2rob,

        // From/To RAT
        output wire full_rob2ii,

        input wire [5:0] freeMeUp_int_rat2rob,       // The physical reg that can be freed once this instruction is commited
        input wire [5:0] freeMeUp_ls_rat2rob,       // The physical reg that can be freed once this instruction is commited
        input wire done_rat2rob,

        output reg [5:0] freeMeUp_0_rob2rat,       // Physical register that can be freed NOW, because the corresponding instruction is being commited
        output reg [5:0] freeMeUp_1_rob2rat,
        output reg valid_rob2rat,

        // From/To Reservation Stations
        output reg [TAGLENGTH-1:0] tag_rob2int,
        output reg [TAGLENGTH-1:0] tag_rob2ls,

        input wire [63:0] result_int2rob,
        input wire [5:0] tag_int2rob,
        input wire [5:0] rd_int2rob,
        input wire valid_int2rob,

        input wire [63:0] result_ls2rob,
        input wire store_ls2rob,            // true if there is no result so there is no result or destination reg
        input wire [5:0] tag_ls2rob,
        input wire [5:0] rd_ls2rob,
        input wire valid_ls2rob,

        // From/To RF
        output reg [5:0] write_select_0_rob2rf,
        output reg write_en_0_rob2rf,
        output reg [63:0] value_0_rob2rf,

        output reg [5:0] write_select_1_rob2rf,
        output reg write_en_1_rob2rf,
        output reg [63:0] value_1_rob2rf
        );
    parameter DEPTH = 2**TAGLENGTH;

    reg [5:0] freeMeUpTags [DEPTH-1:0];    // freeMeUpTag[i] holds the address of the physicsal reg that can be freed...
                                           // ...once the instruction with tag i is comitted
    reg [5:0] destinationRegs [DEPTH-1:0]; // destinationReg[i] holds the destination reg of the instruction with tag i
    reg [63:0] results [DEPTH-1:0];        // result[i] holds the result of the instruction with tag i

    reg readyToCommit [DEPTH-1:0];         // readyToCommit[i] is true iff the instruction with tag i can be commited

    reg busy [DEPTH-1:0];               // Not necessary but makes debugging easier
    reg [6:0] opcodes [DEPTH-1:0];      // Not necessary but makes debugging easier

    reg [5:0] wptr;
    reg [5:0] rptr;

    assign full_rob2ii = (wptr+1 == rptr) ? 1 : 0;

    // Get freeMeUpTags from RAT
    always@(done_rat2rob) begin
        if (~full_rob2ii && ~(~valid_int_id2rob && ~valid_ls_id2rob)) begin
            freeMeUpTags[wptr]          <= freeMeUp_int_rat2rob;
            freeMeUpTags[wptr+1]        <= freeMeUp_ls_rat2rob;
        end
    end

    assign tag_rob2int = wptr;
    assign tag_rob2ls  = wptr+1;

    always@(posedge clk or negedge res_n) begin
        if (~res_n) begin
            freeMeUp_0_rob2rat <= 0;
            freeMeUp_1_rob2rat <= 0;
            valid_rob2rat      <= 0;

            write_select_0_rob2rf       <= 0;
            write_en_0_rob2rf           <= 0;
            value_0_rob2rf              <= 0;
            write_select_1_rob2rf       <= 0;
            write_en_1_rob2rf           <= 0;
            value_1_rob2rf              <= 0;

            //tag_rob2int <= 6'b000000;//6'b111110;
            //tag_rob2ls  <= 6'b000001;//6'b111111;

            wptr            <= 0;
            rptr            <= 0;
            for (int i=0; i<64; i++) begin
                freeMeUpTags[i]     <= 0;
                destinationRegs[i]  <= 0;
                results[i]          <= 0;
                busy[i]             <= 0;
                opcodes[i]          <= 0;
                readyToCommit[i]    <= 0;
            end
        end else begin
            if (~full_rob2ii && ~(~valid_int_id2rob && ~valid_ls_id2rob)) begin // "shift_in" if at there is at least one valid instruction
                if (valid_int_id2rob) opcodes[wptr]               <= opcode_int_id2rob;
                if (valid_ls_id2rob) opcodes[wptr+1]              <= opcode_ls_id2rob;
                busy[wptr]      <= 1;
                busy[wptr+1]    <= 1;
                //tag_rob2int     <= wptr;
                //tag_rob2ls      <= wptr+1;
                /*
                We always shift in/out TWO values, even if one of them is not valid, in which case
                we have to mark that one as ready to commit so that it does not wait for its result
                for ever and stall the pipeline.
                */
                readyToCommit[wptr]         <= ~valid_int_id2rob;
                readyToCommit[wptr+1]       <= ~valid_ls_id2rob;

                wptr                        <= wptr + 2;
            end
            // Get result from EX
            if (valid_int2rob) begin
                results[tag_int2rob]                <= result_int2rob;
                destinationRegs[tag_int2rob]        <= rd_int2rob;
                readyToCommit[tag_int2rob]          <= 1;
            end
            if (valid_ls2rob) begin
                results[tag_ls2rob]                 <= result_ls2rob;
                if (store_ls2rob) begin
                    destinationRegs[tag_ls2rob]     <= 0;
                end else begin
                    destinationRegs[tag_ls2rob]     <= rd_ls2rob;
                end
                readyToCommit[tag_ls2rob]           <= 1;
            end
            // Commit 2 instructions to RF and free up register
            if (readyToCommit[rptr] && readyToCommit[rptr+1]) begin

                write_select_0_rob2rf   <= destinationRegs[rptr];
                value_0_rob2rf          <= results[rptr];
                write_en_0_rob2rf       <= 1;

                write_select_1_rob2rf   <= destinationRegs[rptr+1];
                value_1_rob2rf          <= results[rptr+1];
                write_en_1_rob2rf       <= 1;

                freeMeUp_0_rob2rat           <= freeMeUpTags[rptr];
                freeMeUp_1_rob2rat           <= freeMeUpTags[rptr+1];
                valid_rob2rat                <= 1;

                readyToCommit[rptr]     <= 0;
                readyToCommit[rptr+1]   <= 0;
                busy[rptr]          <= 0;
                busy[rptr+1]        <= 0;

                rptr = rptr + 2;

            end else begin
                write_en_0_rob2rf     <= 0;
                write_en_1_rob2rf     <= 0;
                valid_rob2rat         <= 0;
            end
        end
    end
endmodule