// MIPS Single-Cycle Processor Top Module
module mips_processor(
    input wire clk,
    input wire reset
);

    // Internal wires
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instruction;
    wire [31:0] read_data_1, read_data_2;
    wire [31:0] write_data;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire [4:0] write_reg;
    wire [3:0] alu_control;
    wire [5:0] opcode;
    wire [5:0] funct;
    
    // Control signals
    wire reg_dst, branch, mem_read, mem_to_reg;
    wire mem_write, alu_src, reg_write;
    wire jump, zero;

    // Program Counter
    reg [31:0] pc;
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc_next;
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
        .b(alu_src ? {{16{instruction[15]}}, instruction[15:0]} : read_data_2),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result[7:2]),
        .write_data(read_data_2),
        .read_data(mem_read_data)
    );

    // Control Unit
    control_unit ctrl_unit (
        .opcode(instruction[31:26]),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump)
    );

    // ALU Control
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(instruction[5:0]),
        .alu_control(alu_control)
    );

    // Next PC logic
    assign pc_next = (branch & zero) ? pc + 4 + (instruction[15:0] << 2) :
                    jump ? {pc[31:28], instruction[25:0], 2'b00} :
                    pc + 4;

    // Write register MUX
    assign write_reg = reg_dst ? instruction[15:11] : instruction[20:16];

    // Write data MUX
    assign write_data = mem_to_reg ? mem_read_data : alu_result;

endmodule

// Control Unit Module
module control_unit(
    input wire [5:0] opcode,
    output reg reg_dst,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump
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
                alu_op = 2'b10;
                jump = 1'b0;
            end
            
            ADDI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;  // Use ALU for addition
                jump = 1'b0;
            end
            
            ANDI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate AND
                jump = 1'b0;
            end
            
            ORI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate OR
                jump = 1'b0;
            end
            
            SLTI: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b11;  // Special ALU op for immediate SLT
                jump = 1'b0;
            end
            
            LW: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            
            SW: begin
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            
            BEQ: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            
            J: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b1;
            end
            
            default: begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
        endcase
    end
endmodule

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
    end

    assign zero = (result == 32'b0);
endmodule

// Data Memory Module
module data_memory(
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [5:0] addr,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [63:0]; // 64 words of 32-bit memory

    // Initialize memory with some test data
    initial begin
        memory[0] = 32'h0000_0000;
        memory[1] = 32'h0000_0001;
        // nếu cần thêm thêm vào.
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[addr] <= write_data;
    end

    always @(*) begin
        if (mem_read)
            read_data = memory[addr];
        else
            read_data = 32'b0;
    end
endmodule

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
        end
    end

    // Read operations (asynchronous)
    assign read_data_1 = (read_reg_1 == 5'b0) ? 32'b0 : registers[read_reg_1];
    assign read_data_2 = (read_reg_2 == 5'b0) ? 32'b0 : registers[read_reg_2];
endmodule

// Instruction Memory Module
module instruction_memory(
    input wire [5:0] addr,
    output reg [31:0] instruction
);
    reg [31:0] memory [63:0];

    initial begin
        // add $t0, $s1, $s2      // R-type
        memory[0] = 32'h02324020;
        // addi $t1, $s1, 5       // I-type immediate
        memory[1] = 32'h22290005;
        // sub $t2, $s1, $s2      // R-type
        memory[2] = 32'h02325022;
        // and $t3, $s1, $s2      // R-type
        memory[3] = 32'h02325824;
        // andi $t4, $s1, 15      // I-type immediate
        memory[4] = 32'h3229000F;
        // or $t5, $s1, $s2       // R-type
        memory[5] = 32'h02326025;
        // ori $t6, $s1, 10       // I-type immediate
        memory[6] = 32'h3529000A;
        // slt $t7, $s1, $s2      // R-type
        memory[7] = 32'h0232782A;
        // slti $t8, $s1, 20      // I-type immediate
        memory[8] = 32'h2A380014;
        // beq $t0, $t1, 2        // Branch
        memory[9] = 32'h11090002;
        // j 100                   // Jump
        memory[10] = 32'h08000064;
    end

    always @(*) begin
        instruction = memory[addr];
    end
endmodule

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
    end
endmodule

