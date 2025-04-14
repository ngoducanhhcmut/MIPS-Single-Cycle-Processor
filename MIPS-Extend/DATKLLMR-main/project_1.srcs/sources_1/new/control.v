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
    output reg unsign_ext,
    output reg mem_unsign_ext,
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
    parameter LUI    = 6'b001111;

    // One-hot encoding cho opcode (16 bits để dễ mở rộng)
    reg [16:0] op_decoded;
    always @(*) begin
        op_decoded = 17'b0;
        case (opcode)
            R_TYPE: op_decoded[0] = 1'b1;
            ADDI:  op_decoded[1] = 1'b1;
            ANDI:  op_decoded[2] = 1'b1;
            ORI:   op_decoded[3] = 1'b1;
            SLTI:  op_decoded[4] = 1'b1;
            LW:    op_decoded[5] = 1'b1;
            SW:    op_decoded[6] = 1'b1;
            BEQ:   op_decoded[7] = 1'b1;
            J:     op_decoded[8] = 1'b1;
            LHU:   op_decoded[9] = 1'b1;
            LH:    op_decoded[10] = 1'b1;
            LB:    op_decoded[11] = 1'b1;
            LBU:    op_decoded[12] = 1'b1;
            SH:    op_decoded[13] = 1'b1;
            SB:    op_decoded[14] = 1'b1;
            BNE:   op_decoded[15] = 1'b1;
            LUI:   op_decoded[16]  = 1'b1;
            default: op_decoded = 17'b0;
        endcase
    end

    // Group signals cho các loại instruction
    wire is_r_type = op_decoded[0];
    wire is_imm_alu = op_decoded[1] | op_decoded[2] | op_decoded[3] | op_decoded[4] | op_decoded[16];
    wire is_load = op_decoded[5];
    wire is_store = op_decoded[6];
    wire is_branch = op_decoded[7];
    wire is_jump = op_decoded[8];
    wire is_lhu = op_decoded[9];
    wire is_lh = op_decoded[10];
    wire is_lb = op_decoded[11];
    wire is_lbu = op_decoded[12];
    wire is_sh = op_decoded[13];
    wire is_sb = op_decoded[14];
    wire is_bne = op_decoded[15];
    
    // Control signals generation using one-hot encoding
    always @(*) begin
        // Default assignments
        {reg_dst, branch, branch_not_eq, mem_read, mem_to_reg, mem_write, 
         alu_src, reg_write, jump,unsign_ext,mem_unsign_ext,mem_mode[1:0]} = 13'b0;

        case (1'b1) // Priority encoding
            is_r_type: begin
                reg_dst = 1'b1;
                reg_write = 1'b1;
                alu_op = 2'b10;
                
            end
            
            is_load: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
               
            end
            
            is_store: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_op = 2'b00;
            end
            
            is_lhu: begin 
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
                mem_unsign_ext = 1'b1;
                mem_mode = 2'b01;
            end
                 
            is_lh: begin 
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
                mem_mode = 2'b01;
            end
            
            
            is_lb: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
                mem_mode = 2'b10;
            end
            
            is_lbu: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
                mem_unsign_ext = 1'b1;
                mem_mode = 2'b10;
            end
            
            
            
            is_sh: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_op = 2'b00;
                mem_mode = 2'b01;
            end
            
            is_sb: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_op = 2'b00;
                mem_mode = 2'b10;
            end
            
            is_branch: begin
                branch = 1'b1;
                alu_op = 2'b01;
            end
            
            is_bne: begin
                branch_not_eq = 1'b1;
                alu_op = 2'b01;
            end
            
            is_jump: begin
                jump = 1'b1;
                alu_op = 2'b00;
            end
            
            default: begin
                if (is_imm_alu) begin
                    alu_src = 1'b1;
                    reg_write = 1'b1;
                    
                    case (1'b1)
                        op_decoded[1]: alu_op = 2'b00; // ADDI
                        op_decoded[2]: begin
                           alu_op = 2'b11; // ANDI
                           unsign_ext = 2'b1;
                        end
                        op_decoded[3]: begin
                           alu_op = 2'b11; // ORI
                           unsign_ext=2'b1;
                        end
                        op_decoded[4]: alu_op = 2'b11; // SLTI
                        op_decoded[16]: begin  //LUI
                            alu_op=2'b11;
                            unsign_ext=2'b1;
                        end
                        default: alu_op = 2'b00;
                    endcase
                end else begin
                    alu_op = 2'b00;
                end
            end
        endcase
    end
    // Add synthesis directives
//    (* parallel_case *)
//    (* full_case *)
endmodule