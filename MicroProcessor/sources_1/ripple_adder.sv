module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);     
    logic temp, sum;
    logic [15:0] temp_cout;
        assign temp_cout = 16'b0;
        assign temp = cin;
        always_comb begin
            for (int i = 0; i < 16; i++) begin
                sum = A[i] ^ B[i] ^ temp;
                temp_cout[i] = sum;
                temp = (A[i] && temp) || (B[i] && temp) || (A[i] && B[i]);  
            end
        end
    assign cout = temp;
    assign S = temp_cout;  
endmodule