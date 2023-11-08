module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    
    
    logic temp, sum, G, P, Pg, Gg;    
    logic [3:0] temp_cout; //temp sum array
    assign Gg = 0;
    
    logic start = 0;
    logic end = 3;
    
    logic [3:0] A1 = A[3:0];
    logic [3:0] B1 = B[3:0];
    logic [3:0] A2 = A[7:4];
    logic [3:0] B2 = B[7:4];
    logic [3:0] A3 = A[11:8];
    logic [3:0] B3 = B[11:8];
    logic [3:0] A4 = A[15:12];
    logic [3:0] B4 = B[15:12];
 
    initial begin 
        temp_cout = 4'b0;
        temp = cin;
        
         for(int )   
            for (int i = 0; i < 4; i++) begin
                G = A1 && B1;
                P = A1^B1;
                Pg = Pg && P;
                Gg = G || (G && P); //for the next G (im not sure...)
                temp = G || (temp && P); //for the next Cinput
                sum = A1[i] ^ B1[i] ^ temp;
                temp_cout[i] = sum;
            end
            
    end  
    
            assign S = temp_cout;

    
      

endmodule
