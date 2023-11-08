//MUX_2

module Mux_2( input logic [15:0] A,B,
              input logic S,
              output logic [15:0] out
    );
    always_comb
    begin

        unique case (S)
            1'b0   : out = A;
           1'b1   : out = B;

        endcase
    end

endmodule

//MUX_3

module Mux_3( input logic [15:0] A,B,C,
              input logic [1:0] S,
              output logic [15:0] out

    );

    always_comb
    begin

        unique case (S)
           2'b10   : out = A;
           2'b01   : out = B;
           2'b00   : out = C;   // PC +1 
           default:
                out = 16'hCCCC;

        endcase
    end
endmodule

//MUX_4

module Mux_4( input logic [15:0] A,B,C,D,
              input logic [1:0] S,
              output logic [15:0] out

    );

    always_comb
    begin

        unique case (S)
           2'b11   : out = A;
           2'b10   : out = B;
           2'b01   : out = C;    
           2'b00   : out = D;    

           default:
                out = 16'hCCCC;

        endcase
    end
endmodule

// BUS MUX

module Mux_4_Bus(
                 input logic [3:0] gate,
                 input logic [15:0] MAR_val,
                 input logic [15:0] PC_val,
                 input logic [15:0] ALU_val,
                 input logic [15:0] MDR_val,
                 input logic X,

                 output logic [15:0] final_val
    );

    always_comb
    begin
        //gate is {GateMARMUX, GatePC, GateALU, GateMDR}
        unique case (gate)
               4'b1000: // Open GateMarMux
                  final_val = MAR_val;
               4'b0100   :
                  final_val = PC_val;
               4'b0010   :
                  final_val = ALU_val;
               4'b0001   :
                  final_val = MDR_val;
               default:
                  final_val = 4'b0101;

        endcase
    end


endmodule