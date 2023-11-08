`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2023 11:00:29 PM
// Design Name: 
// Module Name: Register_File
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//inputs needed: Load Register, IR
//ouputs needed:

//for the demo question they might ask about 
//two types of array 
module Register_File(
            input logic Clk,
                        LD_REG,
                        reset,
                        SR1_select_bit,
                        DR_select_bit,

                        [15:0] BUS_Val,
                        [15:0] IR,
                        
                        
           output logic [15:0] SR1_OUT, //a 16-bit value stored in SR1
                                SR2_OUT //a 16-bit value stored in SR2
                        
  );
  
    logic [15:0] register [8];
  
    always_ff @ (posedge Clk)
    begin 
    
        //register[0] = 4'h0001;
        //register[1] = 4'h0002;

        
        if(reset) 
            for(int i = 0;i<8; i=i+1) begin
                register[i] = 16'b0;
            end 
        
        // DRMUX unit
        else if (LD_REG) begin
            if(DR_select_bit)
                register[IR[11:9]] = BUS_Val;
            else
                register[111] = BUS_Val;
        end
        
            
    end
    
    // SR1MUX UNIT
    always_comb begin 
    
    
        unique case (SR1_select_bit)
			1'b0:
                SR1_OUT = register[IR[11:9]];
            1'b1:
                SR1_OUT = register[IR[8:6]];
            default:
                SR1_OUT = 4'hABCD; //dubugging purposes
        endcase
         
        
        SR2_OUT = register[IR[2:0]];
        
        
    end    
  
    
    

  
endmodule
