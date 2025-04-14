// ALU Module
module alu(
    input wire [3:0] alu_control,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] result,
    output wire zero
);
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111;
    parameter ALU_NOR = 4'b1100;

    always @(*) begin
        case(alu_control)
            ALU_AND: result = a & b;                    // AND/ANDI
            ALU_OR:  result = a | b;                    // OR/ORI
            ALU_ADD: result = a + b;                    // ADD/ADDI/LW/SW
            ALU_SUB: result = a - b;                    // SUB/BEQ
            ALU_SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  // SLT/SLTI
            ALU_NOR: result = ~(a | b);                 // NOR
            default: result = 32'b0;
        endcase
       // $display("Result of %h %h : %h %d",a,b,result,alu_control);
    end

    assign zero = (result == 32'b0);
endmodule
