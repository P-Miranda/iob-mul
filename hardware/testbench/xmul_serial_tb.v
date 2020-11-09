`timescale 1ns / 1ps

module xmul_serial_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns

   parameter DATA_W = 32;

   reg clk = 1;

   reg start = 0;
   wire done;

   reg [DATA_W-1:0] op_a;
   reg [DATA_W-1:0] op_b;
   wire [2*DATA_W-1:0] product;

   xmul_serial 
     #(
       .DATA_W(DATA_W)
       )
   uut 
     (
      .clk(clk),
      
      .start(start),
      .done(done),
      
      .op_a(op_a),
      .op_b(op_b),
      
      .product(product)
      );

   initial begin

`ifdef VCD
      $dumpfile("xmul_serial.vcd");
      $dumpvars();
`endif

      #100; 
      @(posedge clk) #1 start = 1;
      op_a = 0;
      op_b = 1;
      @(posedge done) #1 start = 0;
     
      #100; 
      @(posedge clk) #1 start = 1;
      op_a = 1;
      op_b = 0;
      @(posedge done) #1 start = 0;
     
      #100; 
      @(posedge clk) #1 start = 1;
      op_a = 3;
      op_b = 1;
      @(posedge done) #1 start = 0;
     
      #100; 
      @(posedge clk) #1 start = 1;
      op_a = 3;
      op_b = -1;
      @(posedge done) #1 start = 0;
     
      #100; 
      @(posedge clk) #1 start = 1;
      op_a = -3;
      op_b = 1;
      @(posedge done) #1 start = 0;

      #100; 
      @(posedge clk) #1 start = 1;
      op_a = -10;
      op_b = -10;
      @(posedge done) #1 start = 0;
     

      #100 $finish;
   end

   always 
     #(clk_period/2) clk = ~clk;   

endmodule
