module testbench();
timeunit 10ns;
timeprecision 1ns;
logic  Clk, ClearA_LoadB, Run;     

logic [7:0] Din;
logic Xval;
logic [7:0] Aval, Bval;
logic [7:0] hex_seg;
logic [3:0] hex_grid;

multiplier test_mult(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_BODY
    #1 Run = 0;
       ClearA_LoadB = 0;

/*
 // 17 * 9 = 153
    #2 Din = 8'h11;
    #10 ClearA_LoadB = 1;
    #10 ClearA_LoadB = 0;
    #2 Din = 8'h09;
    #10 Run = 1;
    #10 Run = 0;
*/
/*
// 7*(-59) = -413
    #2 Din = 8'd7;
    #10 ClearA_LoadB = 1;
    #10 ClearA_LoadB = 0;
    #2 Din = 8'hC5;
    #10 Run = 1;
    #10 Run = 0;
*/
/*
 // (-10) * (20) = -200
    #2 Din = 8'hF6;
    #10 ClearA_LoadB = 1;
    #10 ClearA_LoadB = 0;
    #2 Din = 8'h14;
    #10 Run = 1;
    #10 Run = 0;
*/

 // (-1) * (-1) * (-1) = -1
    Din = 8'hFF;
    #2 ClearA_LoadB = 1;
    #5 ClearA_LoadB = 0;
    #4 Run = 1;
    #20 Run = 0;
    #20;
    Run = 1;
    #20 Run = 0;

end
endmodule
