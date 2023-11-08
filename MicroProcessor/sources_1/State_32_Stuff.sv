
//set NZP
//set BEN

module State_32_Stuff(
                    input logic Clk,
                   logic [15:0] DR_val,
                                IR,
                          logic LD_BEN,
                                LD_CC,
                                Reset,
                                
              output logic      BEN_Val,
                   logic [2:0]  NZP_Val
                   
                       );
                       
    
    logic Calculated_BEN_Val;
    logic [2:0] NZP;

    
    
    always_comb begin
    
        if(DR_val[15] == 1'b0 )
            NZP = 3'b001;
        else if(DR_val == 16'b0)
            NZP = 3'b010;
        else if(DR_val[15] == 1'b1)
            NZP = 3'b100;
        else
            NZP = 3'b000; //error value
    
        Calculated_BEN_Val = IR[11]&NZP[2] | IR[10]&NZP[1] | IR[9]&NZP[0];
    
    end
    
    
    reg_1 BEN_Reg ( 
        .*, 
        .Reset(Reset), 
        .Load(LD_BEN),    
        .D(Calculated_BEN_Val),
        .Data_Out(BEN_Val) 
    );
    
     reg_3 NZP_Reg ( 
        .*, 
        .Reset(Reset), 
        .Load(LD_CC),    
        .D(NZP),
        .Data_Out(NZP_Val) 
    );
    
endmodule
