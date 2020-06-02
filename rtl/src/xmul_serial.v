`timescale 1ns / 1ps

module xmul_serial # (
                      parameter DATA_W = 32
                      )
   (
    input                     clk,
    input                     rst,

    input                     start,
    output                    done,

    input [DATA_W-1:0]        op_a,
    input [DATA_W-1:0]        op_b,
    output reg [2*DATA_W-1:0] product
    );

   reg [$clog2(DATA_W):0]   counter;
   wire                     en = (counter != DATA_W)? 1'b1: 1'b0;

   assign done = ~en;

   always @ (posedge clk) begin
      if (rst) begin
         counter <= DATA_W;
      end else if (start) begin
         counter <= 0;
      end else if (en) begin
         counter <= counter + 1'b1;
      end
   end

   reg [DATA_W-1:0] op_a_reg;
   reg [DATA_W-1:0] op_b_reg;

   always @ (posedge clk) begin
      if (start) begin
         op_a_reg <= op_a;
         op_b_reg <= op_b;
      end
   end

   always @ (posedge clk) begin
     if (start) begin
        product <= 0;
     end else if(en) begin 
        product <= (product>>1) + (op_b_reg[counter]? op_a_reg<<(DATA_W-1): 0);
     end
   end

endmodule
