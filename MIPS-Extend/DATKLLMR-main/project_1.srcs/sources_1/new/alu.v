// ALU Module
module alu(
    input wire [3:0] alu_control,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0] sa,
    output reg [31:0] result,
    output wire zero
);
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111;
    parameter ALU_NOR = 4'b1100;
    parameter ALU_LUI = 4'b1111;
    parameter ALU_SLL = 4'b0011;
    parameter ALU_SRL = 4'b0100;
    always @(*) begin
        case(alu_control)
            ALU_AND: result = a & b;                    // AND/ANDI
            ALU_OR:  result = a | b;                    // OR/ORI
            ALU_ADD: result = a + b;                    // ADD/ADDI/LW/SW
            ALU_SUB: result = a - b;                    // SUB/BEQ
            ALU_SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  // SLT/SLTI
            ALU_NOR: result = ~(a | b);                 // NOR
            ALU_LUI: result = b << 16;
            ALU_SLL: begin
               case(sa)
               0: result = b;
               1: result = b<<1;
               2: result = b<<2;
               3: result = b<<3;
               4: result = b<<4;
               5: result = b<<5;
               6: result = b<<6;
               7: result = b<<7;
               8: result = b<<8;
               9: result = b<<9;
               10: result = b<<10;
               11: result = b<<11;
               12: result = b<<12;
               13: result = b<<13;
               14: result = b<<14;
               15: result = b<<15;
               16: result = b<<16;
               17: result = b<<17;
               18: result = b<<18;
               19: result = b<<19;
               20: result = b<<20;
               21: result = b<<21;
               22: result = b<<22;
               23: result = b<<23;
               24: result = b<<24;
               25: result = b<<25;
               26: result = b<<26;
               27: result = b<<27;
               28: result = b<<28;
               29: result = b<<29;
               30: result = b<<30;
               31: result = b<<31;
               default: result = b;
               endcase
            end
            ALU_SRL: begin
               case(sa)
               0: result = b;
               1: result = b>>1;
               2: result = b>>2;
               3: result = b>>3;
               4: result = b>>4;
               5: result = b>>5;
               6: result = b>>6;
               7: result = b>>7;
               8: result = b>>8;
               9: result = b>>9;
               10: result = b>>10;
               11: result = b>>11;
               12: result = b>>12;
               13: result = b>>13;
               14: result = b>>14;
               15: result = b>>15;
               16: result = b>>16;
               17: result = b>>17;
               18: result = b>>18;
               19: result = b>>19;
               20: result = b>>20;
               21: result = b>>21;
               22: result = b>>22;
               23: result = b>>23;
               24: result = b>>24;
               25: result = b>>25;
               26: result = b>>26;
               27: result = b>>27;
               28: result = b>>28;
               29: result = b>>29;
               30: result = b>>30;
               31: result = b>>31;
               default: result = b;
               endcase
               end               
            default: result = 32'b0;
        endcase
       // $display("Result of %h %h : %h %d",a,b,result,alu_control);
    end

    assign zero = (result == 32'b0);
endmodule