module clock #(parameter PERIOD = 50) (output reg clk);
  initial clk = 0;
  always #(PERIOD/2) clk = ~clk;
endmodule