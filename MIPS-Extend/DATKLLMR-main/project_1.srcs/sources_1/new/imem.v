// Instruction Memory Module
module instruction_memory(
    input wire [5:0] addr,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:63];
/*
    integer instruction_index = 0;
    integer file_status; 
    initial begin
        file_status = $fopen("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\instruction.txt.txt", "r");
        if (file_status == 0)
            $display("Error: Failed to open file instruction");
        else begin
            $display("Success to open file instruction");
            $fclose(file_status);
            $readmemh("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\instruction.txt.txt", memory);
        end    
    end
*/    
     initial begin
memory[0]=32'h20080003;
memory[1]=32'h01084820;
memory[2]=32'hac090120;
memory[3]=32'h8c090100;
memory[4]=32'h3c01face;
memory[5]=32'h34210000;
memory[6]=32'h10290001;
memory[7]=32'h21080000;
memory[8]=32'h0800000a;
memory[9]=32'h21080001;
memory[10]=32'h20080008;
memory[11]=32'h3109ffff;
memory[12]=32'h350affff;
memory[13]=32'h012a5825;
memory[14]=32'h012a5824;
memory[15]=32'h012a5827;
memory[16]=32'h01084022;
memory[17]=32'h012a582a;
memory[18]=32'h80090100;
memory[19]=32'h84090100;
memory[20]=32'h94090100;
memory[21]=32'h90090100;
memory[22]=32'h3c010000;
memory[23]=32'h3421ffff;
memory[24]=32'h00014820;
memory[25]=32'ha4090120;
memory[26]=32'ha0000120;
memory[27]=32'h3c09cafe;
memory[28]=32'h200100fe;
memory[29]=32'h14290002;
memory[30]=32'h20090001;
memory[31]=32'h08000021;
memory[32]=32'h20090002;
memory[33]=32'h20080001;
memory[34]=32'h00084880;
memory[35]=32'h20080008;
memory[36]=32'h00084842;
memory[37]=32'h292a0008;
    end


    always @(*) begin
        instruction= memory[addr];
        $display("PC: %h %h",addr*4,instruction);
            
    end
endmodule
