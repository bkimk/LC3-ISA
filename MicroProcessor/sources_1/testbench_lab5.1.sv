module testbenchs();

timeunit 10ns;    // Half clock cycle at 50 MHz
timeprecision 1ns;

logic [15:0] SW;
logic Clk, Reset, Run, Continue;

initial begin: clockstartup
#1 Clk = 0;
end

always begin: setclock
#1 Clk = ~Clk;
end

assign SW = 4'h0003; // ask again how the inputs should work


 logic [15:0] LED;
 logic [7:0] hex_seg;
 logic [3:0] hex_grid;
 logic [7:0] hex_segB;
 logic [3:0] hex_gridB;

slc3_testtop test_ho(.*);

initial begin: TEST_BODY

    #2 Reset = 1'd0;
    Run = 1'd0;

    #2 Reset = 1'd1;

    #2 Reset = 1'd0;
    Run = 1'd1;
       
    #1 Continue = 1'd1;
    #20 Continue = 1'd0;
    
//    #1 Continue = 1'd1;
//    #16 Continue = 1'd0;
    
//    #1 Continue = 1'd1;
//    #16 Continue = 1'd0;
    
//    #1 Continue = 1'd1;
//    #16 Continue = 1'd0;




       





end
endmodule