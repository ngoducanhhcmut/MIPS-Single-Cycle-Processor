// Data Memory Module
module data_memory(
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [8:0] addr,
    input wire [31:0] write_data,
    input wire mem_unsign_ext,
    input wire [1:0] mem_mode,
    output reg [31:0] read_data
);
    reg [7:0] dmem [0:256]; // 64 words of 32-bit dmem
   
    parameter W    = 2'b00;
    parameter H     = 2'b01;
    parameter B    = 2'b10;
    // Initialize dmem with some test data
  /* integer data_index = 0;
    integer file_status; 
    initial begin
        file_status= $fopen("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\data.txt", "r");
        if (file_status == 0)
            $display("Error: Failed to open file data");
        else begin
             $display("Success to open file data");
            $fclose(file_status);
            $readmemh("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\data.txt", dmem);
        end    
    end
*/    

     initial begin
        // add $t0, $s1, $s2      // R-type
dmem[0]=8'hFA;
dmem[1]=8'hCE;
dmem[2]=8'h00;
dmem[3]=8'h00;
dmem[4]=8'h00;
dmem[5]=8'h00;
dmem[6]=8'h00;
dmem[7]=8'h00;
    end


    always @(posedge clk) begin
        if (mem_write) begin
           case(mem_mode)
                 W:  begin
                   dmem[{addr[8:2],2'b0}-9'h100] <= write_data[31:24];
                   dmem[{addr[8:2],2'b0}-9'h100+1] <= write_data[23:16];
                   dmem[{addr[8:2],2'b0}-9'h100+2] <= write_data[15:8];
                   dmem[{addr[8:2],2'b0}-9'h100+3] <= write_data[7:0];
                    $display("Write at addr %d value %h",{addr[8:2],2'b0},write_data );
                 end
                 
                 H:  begin
                   dmem[{addr[8:1],1'b0}-9'h100] <= write_data[15:8];
                   dmem[{addr[8:1],1'b0}-9'h100+1] <= write_data[7:0];
                    $display("Write at addr %d value %h",{addr[8:1],1'b0},write_data[15:0] );
                 end
                 
                 B:  begin
                   dmem[addr-9'h100] <= write_data[7:0];
                    $display("Write at addr %d value %h",addr,write_data[7:0] );
                 end
           
                 default: begin
                     dmem[addr-9'h100] <= write_data[7:0];
                     $display("Write at addr %d value %h",addr,write_data[7:0] );
                 end
                 
            endcase
       
        end
       
    end

    always @(*) begin
            case({mem_read,mem_mode,mem_unsign_ext})
                 //LW
                 4'b1000:  begin             
                   read_data[31:24] = dmem[{addr[8:2],2'b0}-9'h100];
                   read_data[23:16] = dmem[{addr[8:2],2'b0}-9'h100+1];
                   read_data[15:8] = dmem[{addr[8:2],2'b0}-9'h100+2];
                   read_data[7:0] = dmem[{addr[8:2],2'b0}-9'h100+3];
                 end
                 
                 4'b1001:  begin
                   read_data[31:24] = dmem[{addr[8:2],2'b0}-9'h100];
                   read_data[23:16] = dmem[{addr[8:2],2'b0}-9'h100+1];
                   read_data[15:8] = dmem[{addr[8:2],2'b0}-9'h100+2];
                   read_data[7:0] = dmem[{addr[8:2],2'b0}-9'h100+3];
                 end
                 
                 //LH
                 4'b1010: begin
                   
                   read_data[15:8] = dmem[{addr[8:1],1'b0}-9'h100];
                   read_data[7:0] = dmem[{addr[8:1],1'b0}-9'h100+1];
                   read_data[31:16]={16{read_data[15]}};
                 end
                 
                 4'b1011: begin
                 
                   read_data[15:8] = dmem[{addr[8:1],1'b0}-9'h100];
                   read_data[7:0] = dmem[{addr[8:1],1'b0}-9'h100+1];
                   read_data[31:16]=16'b0;
                 end
                 //LB
                 
                 4'b1100: begin
                
                   read_data[7:0] = dmem[addr-9'h100];
                   read_data[31:8]={24{read_data[7]}};
                 end
                 
                 4'b1101: begin
                
                   read_data[7:0] = dmem[addr-9'h100];
                   read_data[31:8]=24'b0;
                 end
  
                 default: begin
                   read_data=32'b0;
                 end
            endcase
     end
endmodule


