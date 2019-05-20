/*
TODO
- flow control (full ls, full int, full rob)
- stall if there are no free registers
- store tag, because stores dont have a destination register

Currently:
- We assume that the integer instruction will always be
*/

module rat (
            input wire res_n, input wire clk,

            // from/to ID
            input wire valid_int_id2rat,
            input wire valid_ls_id2rat,
            input wire store,                   // true if the ls instruction is a store. Neccessary, because this is the only instruction type that does not have a destination register

            input wire [4:0] rs1_int_id2rat,    // architectural
            input wire [4:0] rs1_ls_id2rat,     // architectural

            input wire [4:0] rs2_int_id2rat,    // architectural
            input wire [4:0] rs2_ls_id2rat,     // architectural

            input wire [4:0] rd_int_id2rat,     // architectural
            input wire [4:0] rd_ls_id2rat,      // architectural

            // from/to RF
            output reg [5:0] rs1_int_rat2rf,    // physical
            output reg [5:0] rs1_ls_rat2rf,     // physical

            output reg [5:0] rs2_int_rat2rf,    // physical
            output reg [5:0] rs2_ls_rat2rf,     // physical

            // from/to RS (LS and INT)
            output reg [5:0] rd_rat2rsint,
            output reg [5:0] rd_rat2rsls,

            // from/to ROB
            output reg [5:0] freeMeUp_int_rat2rob,
            output reg [5:0] freeMeUp_ls_rat2rob,

            input wire [5:0] freeMeUp_0_rob2rat,
            input wire [5:0] freeMeUp_1_rob2rat,

            output reg done_rat                 // both posedge and negedge signal to the RF, the RS and the ROB that the renaming is done
            );

    parameter ARCHITECTURAL_REGISTER_ADDRESS_LENGTH = 5;
    parameter PHYSICAL_REGISTER_ADDRESS_LENGTH = 6;

    parameter NUMBER_ARCHITECTURAL_REGISTERS    = 2**ARCHITECTURAL_REGISTER_ADDRESS_LENGTH;
    parameter NUMBER_PHYSICAL_REGISTERS         = 2**PHYSICAL_REGISTER_ADDRESS_LENGTH;

    /*
    The Register Alias Table (RAT) keeps track of the mapping between architectural and physical registers.
    If for example the architectural registers 1, 2 and 3 are mapped to the physical registers 5, 2 and 4
    respectively, the RAT would look like this: [101, 010, 100]
    */
    reg [PHYSICAL_REGISTER_ADDRESS_LENGTH-1:0] rat [NUMBER_ARCHITECTURAL_REGISTERS-1:0];               // alias table
    reg free [NUMBER_PHYSICAL_REGISTERS-1:0];                   // is true if the register can be used for renaming

    reg [PHYSICAL_REGISTER_ADDRESS_LENGTH-1:0] freeRegister_0;    // contains the address of a free physical register
    reg [PHYSICAL_REGISTER_ADDRESS_LENGTH-1:0] freeRegister_1;    // see above

    /*
    This function precalculates two free destination registers for the next cycle.
    It also automatically marks it as not free. If the following instruction does not need the register (e.g. stores)
    the table is updated.
    Will sometimes cost us a register and in those cases might cost us a stall. This will be particularly
    problematic if there are only two free registers left.
    */
    task getFreeRegisters;
        integer freeRegistersFound = 0;
        integer firstFreeReg = 0;
        integer secondFreeReg = 0;
        begin
            freeRegistersFound = 0;
            firstFreeReg = 0;
            secondFreeReg = 0;
            for (integer i=1; i<NUMBER_PHYSICAL_REGISTERS; i++) begin //R0 is hardwired to 0
                if(free[i] == 1) begin
                    if (freeRegistersFound == 1) begin
                        secondFreeReg = i;
                        freeRegistersFound++;
                    end
                    if (freeRegistersFound == 0) begin
                        firstFreeReg = i;
                        freeRegistersFound++;
                    end
                end
            end
            if (freeRegistersFound == 0 || freeRegistersFound == 1) begin
                freeRegister_0 <= 0;  // this only happens if there are not enough registers -> stall
                freeRegister_1 <= 0;  // see above
            end else begin
                if (valid_int_id2rat == 1) begin // If the instruction is a NOP/not valid it will not use the precalculated register so we can use it again
                    freeRegister_0          <= firstFreeReg;
                    // free[firstFreeReg]      <= 0;
                end
                if (valid_ls_id2rat == 1 && store == 0) begin // see above
                    freeRegister_1      <= secondFreeReg;
                    // free[secondFreeReg] <= 0;
                end

/*
                if (rd_int_id2rat == 0 and rd_ls_id2rat != 0) begin // integer is not using its precalculated register, so we can keep that one
                    freeRegister_1          <= firstFreeReg;
                    free[firstFreeReg]      <= 0;
                end
                if (rd_int_id2rat != 0 and rd_ls_id2rat == 0) begin
                    freeRegister_0          <= freeRegister_1;
                    freeRegister_1          <= firstFreeReg;
                    free[firstFreeReg]      <= 0;
                end
                if (rd_int_id2rat != 0 and rd_ls_id2rat != 0) begin
                    freeRegister_0          <= firstFreeReg;
                    free[firstFreeReg]      <= 0;
                    freeRegister_1          <= secondFreeReg;
                    free[secondFreeReg]     <= 0;
                end
*/
            end
        end
    endtask

    /*
    This function simply uses the RAT to convert archtectural register addresses to physical ones.
    Using this function rather than the RAT directly should make the code easier to understand.
    */
    function [5:0] getPhysicalRegisterAddress;
        input [4:0] architecturalRegisterAddress;
        getPhysicalRegisterAddress = rat[architecturalRegisterAddress];
    endfunction

    task reset;
        begin
            rs1_ls_rat2rf   <= 0;
            rs1_int_rat2rf  <= 0;
            rs2_ls_rat2rf   <= 0;
            rs2_int_rat2rf  <= 0;

            rd_rat2rsls     <= 0;
            rd_rat2rsint    <= 0;

            freeMeUp_int_rat2rob <= 0;
            freeMeUp_ls_rat2rob <= 0;

            rd_rat2rsls <= 0;
            rd_rat2rsint <= 0;

            done_rat     <= 0;

            for (int i=0; i<NUMBER_ARCHITECTURAL_REGISTERS; i++)  begin
                rat[i] <= 0;
            end

            freeRegister_0  <= 1;
            freeRegister_1  <= 2;
            free[0] <= 1;
            free[1] <= 0;
            free[2] <= 0;
            for (int i=3; i<NUMBER_PHYSICAL_REGISTERS; i++) begin
                free[i] <= 1;
            end
        end
    endtask

    always@(posedge clk or negedge res_n) begin
        if (~res_n) begin
            reset;
        end else begin
            getFreeRegisters; // for the next cycle

            /////////////////////
            // Integer
            /////////////////////

            if (valid_int_id2rat) begin
                $display("INT");
                // Rename source
                rs1_int_rat2rf  <= getPhysicalRegisterAddress(rs1_int_id2rat);
                rs2_int_rat2rf  <= getPhysicalRegisterAddress(rs2_int_id2rat);
                // Rename destination
                rd_rat2rsint            <= freeRegister_0;
                rat[rd_int_id2rat]      <= freeRegister_0;                          // update RAT
                free[freeRegister_0]    <= 0;
                freeMeUp_int_rat2rob    <= getPhysicalRegisterAddress(rd_rat2rsint);

                done_rat                <= ~done_rat;
            end

            /////////////////////
            // LS
            /////////////////////
            if (valid_ls_id2rat) begin
                $display("LS");
                // Rename source
                if (rs1_ls_id2rat == rd_int_id2rat && valid_int_id2rat == 1) begin
                    rs1_ls_rat2rf <= freeRegister_0;
                end else begin
                    rs1_ls_rat2rf <= getPhysicalRegisterAddress(rs1_ls_id2rat);
                end
                if (rs2_ls_id2rat == rd_int_id2rat && valid_int_id2rat == 1) begin
                    rs2_ls_rat2rf <= freeRegister_0;
                end else begin
                    rs2_ls_rat2rf <= getPhysicalRegisterAddress(rs2_ls_id2rat);
                end
                // Rename destination
                if (store == 0) begin // only loads need destination registers
                    rd_rat2rsls         <= freeRegister_1;
                    rat[rd_ls_id2rat]   <= freeRegister_1;
                    free[freeRegister_1] <= 0;
                    freeMeUp_ls_rat2rob <= getPhysicalRegisterAddress(rd_rat2rsls);
                end
                done_rat     <= ~done_rat;
            end 
            /////////////////////
            // Free Registers
            /////////////////////
            free[freeMeUp_0_rob2rat] <= 1;
            free[freeMeUp_1_rob2rat] <= 1;

        end
    end

endmodule