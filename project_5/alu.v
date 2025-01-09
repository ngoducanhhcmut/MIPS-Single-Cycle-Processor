// Module ALU chính
module alu(
    input wire [3:0] alu_control,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] result,
    output wire zero
);
    // Tín hiệu từ các sub-modules
    wire [31:0] add_sub_result;
    wire [31:0] logic_result;
    wire [31:0] slt_result;
    wire cout;  // Carry out từ phép cộng/trừ

    // Module cộng/trừ với CLA
    fast_adder_subtractor add_sub_unit (
        .a(a),
        .b(b),
        .sub_mode(alu_control[2]), // 1 for subtraction, 0 for addition
        .result(add_sub_result),
        .cout(cout)
    );

    // Module logic operations
    logic_unit logic_ops (
        .a(a),
        .b(b),
        .op_sel(alu_control[1:0]),
        .result(logic_result)
    );

    // SLT computation
    assign slt_result = {31'b0, add_sub_result[31]};

    // Final result multiplexing
    always @(*) begin
        case(alu_control)
            4'b0000: result = logic_result;  // AND
            4'b0001: result = logic_result;  // OR
            4'b0010: result = add_sub_result; // ADD
            4'b0110: result = add_sub_result; // SUB
            4'b0111: result = slt_result;    // SLT
            4'b1100: result = ~logic_result; // NOR
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule

// Fast Adder/Subtractor với CLA
module fast_adder_subtractor(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sub_mode,
    output wire [31:0] result,
    output wire cout
);
    wire [31:0] b_input;
    wire [7:0] group_propagate;
    wire [7:0] group_generate;
    wire [7:0] group_carry;
    wire [31:0] carries;

    // Two's complement cho phép trừ
    assign b_input = sub_mode ? ~b : b;
    wire cin = sub_mode;

    // Tạo propagate và generate cho từng bit
    wire [31:0] p, g;
    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin : pg_bits
            assign p[i] = a[i] ^ b_input[i];
            assign g[i] = a[i] & b_input[i];
        end
    endgenerate

    // Tạo group propagate và generate (mỗi group 4 bits)
    generate
        for(i = 0; i < 8; i = i + 1) begin : pg_groups
            assign group_propagate[i] = &p[i*4+3:i*4];
            assign group_generate[i] = g[i*4+3] |
                                     (p[i*4+3] & g[i*4+2]) |
                                     (p[i*4+3] & p[i*4+2] & g[i*4+1]) |
                                     (p[i*4+3] & p[i*4+2] & p[i*4+1] & g[i*4]);
        end
    endgenerate

    // CLA logic cho group carries
    assign group_carry[0] = cin;
    generate
        for(i = 1; i < 8; i = i + 1) begin : group_carries
            assign group_carry[i] = group_generate[i-1] |
                                  (group_propagate[i-1] & group_carry[i-1]);
        end
    endgenerate

    // Calculate carries cho từng bit trong mỗi group
    generate
        for(i = 0; i < 8; i = i + 1) begin : bit_carries
            wire [3:0] c;
            if(i == 0) begin
                assign c[0] = cin;
                assign c[1] = g[0] | (p[0] & cin);
                assign c[2] = g[1] | (p[1] & g[0]) | (&p[1:0] & cin);
                assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (&p[2:0] & cin);
                assign carries[3:0] = c;
            end
            else begin
                assign c[0] = group_carry[i];
                assign c[1] = g[i*4] | (p[i*4] & group_carry[i]);
                assign c[2] = g[i*4+1] | (p[i*4+1] & g[i*4]) | (&p[i*4+1:i*4] & group_carry[i]);
                assign c[3] = g[i*4+2] | (p[i*4+2] & g[i*4+1]) | (p[i*4+2] & p[i*4+1] & g[i*4]) | 
                             (&p[i*4+2:i*4] & group_carry[i]);
                assign carries[i*4+3:i*4] = c;
            end
        end
    endgenerate

    // Final sum
    generate
        for(i = 0; i < 32; i = i + 1) begin : sum_bits
            assign result[i] = p[i] ^ carries[i];
        end
    endgenerate

    assign cout = carries[31];
endmodule

// Logic Unit cho AND, OR, NOR operations
module logic_unit(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [1:0] op_sel,
    output reg [31:0] result
);
    wire [31:0] and_result = a & b;
    wire [31:0] or_result = a | b;
    
    always @(*) begin
        case(op_sel)
            2'b00: result = and_result;
            2'b01: result = or_result;
            2'b10: result = ~or_result;
            default: result = 32'b0;
        endcase
    end
endmodule