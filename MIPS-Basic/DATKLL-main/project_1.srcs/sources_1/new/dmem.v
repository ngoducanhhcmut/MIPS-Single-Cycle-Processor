// Data Memory Module
module data_memory(
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [8:0] addr,
    input wire [31:0] write_data,
    input wire mem_sign_ext,
    input wire [1:0] mem_mode,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:63]; // 64 words of 32-bit memory
    parameter W    = 2'b00;
    parameter H     = 2'b01;
    parameter B    = 2'b10;
    // Initialize memory with some test data
  /* integer data_index = 0;
    integer file_status; 
    initial begin
        file_status= $fopen("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\data.txt", "r");
        if (file_status == 0)
            $display("Error: Failed to open file data");
        else begin
             $display("Success to open file data");
            $fclose(file_status);
            $readmemh("D:\\HK241\\project_1\\project_1.sim\\sim_1\\behav\\data.txt", memory);
        end    
    end
*/    

     initial begin
        // add $t0, $s1, $s2      // R-type
        memory[0] = 32'h00000003;
        memory[1] = 32'hCAFEFACE;
        memory[2] = 32'h00000004;
      
    end


    always @(posedge clk) begin
        if (mem_write) begin
           case(mem_mode)
                 W:  begin
                   memory[addr[8:2]-7'h40] <= write_data;
                 end
                 
                 H:  begin
                   case(addr[1])
                      1'b0: begin
                          memory[addr[8:2]-7'h40][31:16]<= write_data[15:0];
                         
                      end
                      
                      1'b1: begin
                          memory[addr[8:2]-7'h40][15:0]<= write_data[15:0];
                        
                      end
                   endcase
                 end
                 
                 B:  begin
                   case(addr[1:0])
                      2'b00: begin
                           memory[addr[8:2]-7'h40][31:24]<= write_data[7:0];
                          
                      end
                      
                      2'b01: begin
                          memory[addr[8:2]-7'h40][23:16]<= write_data[7:0];
                      end
                      
                      2'b10: begin
                          memory[addr[8:2]-7'h40][15:8]<= write_data[7:0];
                      end
                      
                      2'b11: begin
                         memory[addr[8:2]-7'h40][7:0]<= write_data[7:0];
                      end
                   endcase
                 end
           
                 default: begin
                     memory[addr[8:2]-7'h40] <= write_data;
                 end
                 
            endcase
            $display("Write at addr %d value %h",addr[8:2]*4,memory[addr[8:2]-7'h40] );
        end
       
    end

    always @(*) begin
        if (mem_read)
        begin
            case(mem_mode)
                 W:  begin
                   read_data = memory[addr[8:2]-7'h40];
                 end
                 
                 H:  begin
                   case(addr[1])
                      1'b0: begin
                          read_data=mem_sign_ext ? {{16{memory[addr[8:2]-7'h40][31]}}, memory[addr[8:2]-7'h40][31:16]} :{{16{1'b0}}, memory[addr[8:2]-7'h40][31:16]};
                      end
                      
                      1'b1: begin
                          read_data=mem_sign_ext ? {{16{memory[addr[8:2]-7'h40][15]}}, memory[addr[8:2]-7'h40][15:0]} :{{16{1'b0}}, memory[addr[8:2]-7'h40][15:0]};
                      end
                   endcase
                 end
                 
                 B:  begin
                   case(addr[1:0])
                      2'b00: begin
                          read_data=mem_sign_ext ? {{24{memory[addr[8:2]-7'h40][31]}}, memory[addr[8:2]-7'h40][31:24]} :{{24{1'b0}}, memory[addr[8:2]-7'h40][31:24]};
                          
                      end
                      
                      2'b01: begin
                          read_data=mem_sign_ext ? {{24{memory[addr[8:2]-7'h40][23]}}, memory[addr[8:2]-7'h40][23:16]} :{{24{1'b0}}, memory[addr[8:2]-7'h40][23:16]};
                      end
                      
                      2'b10: begin
                          read_data=mem_sign_ext ? {{24{memory[addr[8:2]-7'h40][15]}}, memory[addr[8:2]-7'h40][15:8]} :{{24{1'b0}}, memory[addr[8:2]-7'h40][15:8]};
                      end
                      
                      2'b11: begin
                          read_data=mem_sign_ext ? {{24{memory[addr[8:2]-7'h40][15]}}, memory[addr[8:2]-7'h40][7:0]} :{{24{1'b0}}, memory[addr[8:2]-7'h40][7:0]};
                      end
                   endcase
                 end
                 
                 default: begin
                     read_data = memory[addr[8:2]-7'h40];
                 end
            endcase
        end
        else
            read_data = 32'b0;
    end
endmodule

