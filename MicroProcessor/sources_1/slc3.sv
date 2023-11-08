//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//------------------------------------------------------------------------------

module slc3(
	input logic [15:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [15:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [7:0] hex_seg,
	output logic [3:0] hex_grid,
	output logic [7:0] hex_segB,
	output logic [3:0] hex_gridB,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In; //MDR_In is the Data_to_CPU
logic [15:0] MAR, MDR, IR;
logic [3:0] hex_4[3:0]; 

//new variables added
logic [15:0] PCMUXOUT;
logic [15:0] MIOENOUT;
logic [15:0] PC; //value of PC
logic [15:0] ALU; //value of ALU out
logic [15:0] BUS_val;
logic [15:0] SR1_Val;
logic [15:0] SR2_Val;
logic [15:0] ADDR2MUX_out;
logic [15:0] ADDR1MUX_out;
logic [15:0] ADDR12_adder_out;
logic [2:0] NZP;
//logic [15:0] DR_Val; //used to set NZP



logic X;

HexDriver HexA (
    .clk(Clk),
    .reset(Reset),
    .in({IR[15:12], IR[11:8], IR[7:4], IR[3:0]}), // ??????
    .hex_seg(hex_seg),
    .hex_grid(hex_grid)
);

// You may use the second (right) HEX driver to display additional debug information
// For example, Prof. Cheng's solution code has PC being displayed on the right HEX

HexDriver HexB (
    .clk(Clk),
    .reset(Reset),
    .in({PC[15:12], PC[11:8], PC[7:4], PC[3:0]}),
    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;

    // instance of PC Register
    reg_16 PC_Reg ( 
        .*, 
        .Reset(Reset), 
        .Load(LD_PC),    
        .D(PCMUXOUT),
        .Data_Out(PC) 
    );

    // instance of MAR register
     reg_16 MAR_Reg (
        .*,
        .Reset(Reset),
        .Load(LD_MAR),
        .D(BUS_val), 
        .Data_Out(MAR)
    );
    
    // instance of MDR register
    reg_16 MDR_reg ( 
        .*, 
        .Reset(Reset), 
        .Load(LD_MDR),    
        .D(MIOENOUT),
        .Data_Out(MDR) 
    );
    
    // instance of IR register
    reg_16 IR_Reg (
        .*, 
        .Reset(Reset),  
        .Load(LD_IR),    
        .D(BUS_val),
        .Data_Out(IR) 
        );
    
    // instance of PC MUX
    Mux_3 PC_MUX (
        .A(BUS_val), //10
        .B(ADDR12_adder_out), //01
        .C(PC+1'b1), //00
        .S(PCMUX),
        .out(PCMUXOUT)
    );
    
    Mux_4 ADDR2_MUX(
    
                    .A({{5{IR[10]}},IR[10:0]}), //11 
                    .B({{7{IR[8]}},IR[8:0]}), //10
                    .C({{10{IR[5]}},IR[5:0]}), //01
                    .D(16'b0), //00
                    .S(ADDR2MUX),
                    
                    .out(ADDR2MUX_out)

    );
    
    Mux_2 ADDR1_MUX(
                    .A(PC), //0 
                    .B(SR1_Val), //1
                    .S(ADDR1MUX),
                    
                    .out(ADDR1MUX_out)
    );
    
    
    ripple_adder ADDR12_adder (
                                .A(ADDR2MUX_out),
                                .B(ADDR1MUX_out),
                                .cin(1'b0),
                                .ALUK(2'b00),
                                
                                .ALU_OUT(ADDR12_adder_out)
     );
     
    
    // instance of MIO.EN MUX
    Mux_2 MIOEN (
                .A(BUS_val),
                .B(MDR_In),
                .S(MIO_EN),
                .out(MIOENOUT)
                );
    
    
    
    // instance of Bus MUX
    Mux_4_Bus Bux_Mux (
                        .gate({GateMARMUX, GatePC, GateALU, GateMDR}), // do we need to worry about reg with no value?
                        .MAR_val(ADDR2MUX_out),
                        .PC_val(PC),
                        .ALU_val(ALU),
                        .MDR_val(MDR),
                   
                        .final_val(BUS_val)
                       );
                       
                       
    Register_File Reg_File (
    
                            .*, //clock
                            .LD_REG(LD_REG),
                            .reset(Reset),
                            .BUS_Val(BUS_val),
                            .SR1_select_bit(SR1MUX),
                            .IR(IR),
                            .DR_select_bit(DRMUX),
                            
                            
                            .SR1_OUT(SR1_Val),
                            .SR2_OUT(SR2_Val)
                            
    
                            );
      
     Mux_2 SR2_MUX (
                .A(SR2_Val), //when IR[5] is 0
                .B({{11{IR[4]}},IR[4:0]}), //when IR[6] is 1
                .S(SR2MUX), //same thing has IR[5]
                .out(SR2_Val) //the SR2_Val is the also after the SR2 MUX
                );
                
     ripple_adder ALU_module (
                                .A(SR1_Val),
                                .B(SR2_Val),
                                .cin(1'b0),
                                .ALUK(ALUK),
                                
                                .ALU_OUT(ALU)
     );
     
     State_32_Stuff SetNZP_BEN (
                                .*,
                                .DR_val(BUS_val),
                                .LD_BEN(LD_BEN),
                                .IR(IR),
                                .LD_CC(LD_CC),
                                .Reset(Reset),
                                
                                .BEN_Val(BEN),
                                .NZP_Val(NZP)
                                
     
     
     );
     
     
    
    
                                                     

// Instantiate the rest of your modules here according to the block diagram of the SLC-3
// including your register file, ALU, etc..


// Our I/O controller (note, this plugs into MDR/MAR)

//assign hex_4[0][3:0]= IR[15:12];
//assign hex_4[1][3:0]= IR[11:8];
//assign hex_4[2][3:0]= IR[7:4];
//assign hex_4[3][3:0]= IR[3:0];


Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    //.HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]), 
    .HEX0(), .HEX1(), .HEX2(), .HEX3(), 
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]), .BEN(BEN),
	
	.LD_MAR(LD_MAR), .LD_MDR(LD_MDR), .LD_IR(LD_IR), .LD_PC(LD_PC),
	.LD_BEN(LD_BEN), .LD_CC(LD_CC), .LD_REG(LD_REG), .LD_LED(LD_LED),

	
	.GatePC(GatePC), .GateMDR(GateMDR), .GateMARMUX(GateMARMUX), .GateALU(GateALU),
	
	 .PCMUX(PCMUX), .DRMUX(DRMUX), .SR1MUX(SR1MUX), .SR2MUX(SR2MUX), 
	 .ALUK(ALUK), .ADDR1MUX(ADDR1MUX), .ADDR2MUX(ADDR2MUX), 
   	
    .Mem_OE(OE), .Mem_WE(WE)
    
   
    
);
	
endmodule