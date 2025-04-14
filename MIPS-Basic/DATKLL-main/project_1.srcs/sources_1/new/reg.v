
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 04:29:14 PM
// Design Name: 
// Module Name: reg
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

// Register File Module
module register_file(
    input wire clk,
    input wire reset,
    input wire reg_write,
    input wire [4:0] read_reg_1,
    input wire [4:0] read_reg_2,
    input wire [4:0] write_reg,
    input wire [31:0] write_data,
    output wire [31:0] read_data_1,
    output wire [31:0] read_data_2
);
    reg [31:0] registers [31:0];
    integer i;

    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && write_reg != 5'b0) begin
            registers[write_reg] <= write_data;
            $display("Write register %d value %h",write_reg,write_data);

        end
    end

    // Read operations (asynchronous)
    assign read_data_1 = (read_reg_1 == 5'b0) ? 32'b0 : registers[read_reg_1];
    assign read_data_2 = (read_reg_2 == 5'b0) ? 32'b0 : registers[read_reg_2];
endmodule