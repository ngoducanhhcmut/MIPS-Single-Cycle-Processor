// ALU Control Module
module alu_control(
    input wire [1:0] alu_op,
    input wire [5:0] funct,
    input wire [5:0] opcode,        // Thêm input opcode
    output reg [3:0] alu_control
);
    // Function field definitions
    parameter ADD = 6'b100000;
    parameter SUB = 6'b100010;
    parameter AND = 6'b100100;
    parameter OR  = 6'b100101;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    
    // Opcode definitions for immediate instructions
    parameter ANDI = 6'b001100;
    parameter ORI  = 6'b001101;
    parameter SLTI = 6'b001010;

    always @(*) begin
        case(alu_op)
            2'b00: alu_control = 4'b0010; // add for lw/sw/addi
            2'b01: alu_control = 4'b0110; // subtract for beq
            2'b10: begin // R-type instructions
                case(funct)
                    ADD: alu_control = 4'b0010; // add
                    SUB: alu_control = 4'b0110; // subtract
                    AND: alu_control = 4'b0000; // and
                    OR:  alu_control = 4'b0001; // or
                    NOR: alu_control = 4'b1100; // nor
                    SLT: alu_control = 4'b0111; // set less than
                    default: alu_control = 4'b0000;
                endcase
            end
            2'b11: begin // Immediate instructions
                case(opcode)
                    ANDI: alu_control = 4'b0000; // and
                    ORI:  alu_control = 4'b0001; // or
                    SLTI: alu_control = 4'b0111; // set less than
                    default: alu_control = 4'b0000;
                endcase
            end
            default: alu_control = 4'b0000;
        endcase
       // $display("ALU_Control %b %b %b",alu_control,alu_op,opcode);
    end
endmodule
