`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 12:54:28 AM
// Design Name: 
// Module Name: test
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


// MIPS Single-Cycle Processor Top Module





module mips_processor(
    input wire clk,
    input wire reset,
    output wire [31:0] instruction,
    output reg [31:0] o_pc
    
);

    // Internal wires
    
    wire [31:0] pc_next;
    //wire [31:0] instruction;
    wire [31:0] read_data_1, read_data_2;
    wire [31:0] write_data;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire [4:0] write_reg;
    wire [3:0] alu_control;
    wire [5:0] opcode;
    wire [5:0] funct;
    wire [1:0] alu_op;
    wire [1:0] mem_mode;
    //0: word, 1: half, 2: byte
   
    // Control signals
    wire reg_dst, branch, mem_read, mem_to_reg,branch_not_eq;
    wire mem_write, alu_src, reg_write;
    wire jump, zero;
    wire sign_ext,mem_sign_ext;

    // Program Counter
    reg [31:0] pc;
    always @(posedge clk) begin
        if (reset )
            pc <= 32'b0;
        else
            pc <= pc_next;
        o_pc<=pc;
    end
    
    // Instruction Memory
     instruction_memory imem (
        .addr(pc[7:2]),
        .instruction(instruction)
    );

    // Register File
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg_1(instruction[25:21]),
        .read_reg_2(instruction[20:16]),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // ALU
    alu main_alu (
        .alu_control(alu_control),
        .a(read_data_1),
        .b(alu_src ? ( sign_ext ? {{16{instruction[15]}}, instruction[15:0]} :{{16{1'b0}}, instruction[15:0]}) : read_data_2),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result[8:0]),
        .write_data(read_data_2),
        .read_data(mem_read_data),
        .mem_sign_ext(mem_sign_ext),
        .mem_mode(mem_mode)
    );

    // Control Unit
    control_unit ctrl_unit (
        .opcode(instruction[31:26]),
        .reg_dst(reg_dst),
        .branch(branch),
        .branch_not_eq(branch_not_eq),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump),
        .sign_ext(sign_ext),
        .mem_sign_ext(mem_sign_ext),
        .mem_mode(mem_mode)
    );

    // ALU Control
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(instruction[5:0]),
        .alu_control(alu_control),
        .opcode(instruction[31:26])
    );
   
    // Next PC logic
    assign pc_next = (branch & zero) || (branch_not_eq & !zero)? pc + 4 + (instruction[15:0] << 2) :
                      jump ? {pc[31:28], instruction[25:0], 2'b00} :
                      pc + 4;
                      
/*    assign pc_next = (branch & zero) ? pc + 4 + (instruction[15:0] << 2) :
                      jump ? {pc[31:28], instruction[25:0], 2'b00} :
                      pc + 4;
*/
    // Write register MUX
    assign write_reg = reg_dst ? instruction[15:11] : instruction[20:16];

    // Write data MUX
    assign write_data = mem_to_reg ? mem_read_data : alu_result;

endmodule
