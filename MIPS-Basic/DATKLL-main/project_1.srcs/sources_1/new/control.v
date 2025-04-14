module control_unit(
    input wire [5:0] opcode,
    output reg reg_dst,
    output reg branch,
    output reg branch_not_eq,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump,
    output reg sign_ext,
    output reg mem_sign_ext,
    output reg [1:0] mem_mode
);
    // Opcode definitions
    parameter R_TYPE = 6'b000000;  // add, sub, and, or, nor, slt
    parameter ADDI   = 6'b001000;
    parameter ANDI   = 6'b001100;
    parameter ORI    = 6'b001101;
    parameter SLTI   = 6'b001010;
    parameter LW     = 6'b100011;
    parameter SW     = 6'b101011;
    parameter BEQ    = 6'b000100;
    parameter J      = 6'b000010;
    parameter LHU    = 6'b100101;
    parameter LH     = 6'b100001;
    parameter LB     = 6'b100000;
    parameter LBU    = 6'b100100;
    parameter SH     = 6'b101001;
    parameter SB     = 6'b101000;
    parameter BNE    = 6'b000101;
    always @(*) begin
        case(opcode)
            R_TYPE: begin // R-type instructions
                reg_dst = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b10;
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            ADDI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;  // Use ALU for addition
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            ANDI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate AND
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            ORI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate OR
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            SLTI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate SLT
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            LW: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end

            LH: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b1;
                mem_mode = 2'b01;
            end
            
            LHU: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b01;
            end
            
            LBU: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b10;
            end
            
            LB: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b1;
                mem_mode = 2'b10;
            end
            
            SW: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            SH: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b01;
            end
            
            SB: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b1;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b10;
            end
            
            
            BEQ: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                branch_not_eq = 1'b0;
                alu_op = 2'b01;
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            BNE: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b1;
                alu_op = 2'b01;
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end

            
            J: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b1;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
            
            default: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                branch_not_eq = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
                sign_ext = 1'b0;
                mem_sign_ext = 1'b0;
                mem_mode = 2'b00;
            end
        endcase
      //  $display("alu_op %b",alu_op);
    end
endmodule





