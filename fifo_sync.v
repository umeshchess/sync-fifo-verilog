module fifo_sync 
    #(  parameter FIFO_DEPTH = 8,
        parameter DATA_WIDTH = 32)
      ( 
        input clk,
        input cs,
        input rst_n,
        input wr_en,
        input rd_en,
        input [DATA_WIDTH-1:0] data_in,
        output reg [DATA_WIDTH-1:0] data_out,
        output empty,
        output full);
   localparam PTR_WIDTH = $clog2(FIFO_DEPTH);
   reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
   reg [PTR_WIDTH:0] write_pointer;
   reg [PTR_WIDTH:0] read_pointer;
   always @(posedge clk or negedge rst_n) 
   begin 
     if (!rst_n) 
        begin 
            write_pointer <= 0;
        end 
     else if (cs && wr_en && (!full || (rd_en && !empty)))
         begin 
            fifo[write_pointer[PTR_WIDTH-1:0]] <= data_in;
            write_pointer <= write_pointer + 1'b1;
         end
    end
    always @(posedge clk or negedge rst_n) 
    begin 
      if (!rst_n) 
         begin
            read_pointer <= 0;
            data_out <= {DATA_WIDTH{1'b0}}; 
         end 
      else if (cs && rd_en && !empty)
         begin 
            data_out <= fifo[read_pointer[PTR_WIDTH-1:0]];
            read_pointer <= read_pointer + 1'b1;
         end
   end
   assign empty = (read_pointer == write_pointer);
   assign full = (write_pointer == {~read_pointer[PTR_WIDTH], read_pointer[PTR_WIDTH-1:0]});
endmodule