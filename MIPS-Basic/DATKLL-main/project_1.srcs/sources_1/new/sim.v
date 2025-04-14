`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 10:02:53 AM
// Design Name: 
// Module Name: sim
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


module main;
  reg clk,reset;  
  wire [31:0] o_instruction;
  wire [31:0] o_pc_cur;

  integer i;
  initial 
    begin
        clk=0; 
        for (i=0;i<80;i=i+1) //the number of counting
		begin
		    #5 clk = ~clk;
		end

    end
    initial 
       begin
          reset=1;
          #6 reset=0;
       end
       
    
	
	// unit under test (UUT)
	mips_processor proc(.clk(clk),.reset(reset),.instruction(o_instruction),.o_pc(o_pc_cur));
endmodule
