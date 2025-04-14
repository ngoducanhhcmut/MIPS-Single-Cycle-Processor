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
        // add $t0, $s1, $s2      // R-type
memory[0]=32'h8c080100;
memory[1]=32'h01084820;
memory[2]=32'h212a0002;
memory[3]=32'h01485822;
memory[4]=32'h01686024;
memory[5]=32'h01486825;
memory[6]=32'h01487027;
memory[7]=32'h3c01ffff;
memory[8]=32'h3421ffff;
memory[9]=32'h01417824;
memory[10]=32'h3c01ffff;
memory[11]=32'h3421ffff;
memory[12]=32'h01418025;
memory[13]=32'h010a882a;
memory[14]=32'h29120006;
memory[15]=32'hac120120;
memory[16]=32'h152a0003;
memory[17]=32'h12320001;
memory[18]=32'h02529020;
memory[19]=32'h08000015;
memory[20]=32'h21090001;
memory[21]=32'h01085020;

    end


    always @(*) begin
        instruction= memory[addr];
        $display("PC: %h %h",addr*4,instruction);
            
    end
endmodule
