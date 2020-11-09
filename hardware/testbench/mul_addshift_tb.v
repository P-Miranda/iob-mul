`timescale 1ns / 1ps

module mul_addshift_tb;

   parameter DATA_W = 4;

   reg clk = 1;

   reg en = 0;
   wire done;

   reg [DATA_W-1:0] op_a;
   reg [DATA_W-1:0] op_b;
   wire [2*DATA_W-1:0] product;

   initial begin

`ifdef VCD
      $dumpfile("mul_addshift.vcd");
      $dumpvars();
`endif

      //multiply by 0
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 0;
      op_b = 1;
      @(posedge done) #1 en = 0;
     
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 1;
      op_b = 0;
      @(posedge done) #1 en = 0;
     
      //multiply by 1
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 1;
      op_b = 1;
      @(posedge done) #1 en = 0;
     
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 1;
      op_b = 2;
      @(posedge done) #1 en = 0;
     
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 2;
      op_b = 1;
      @(posedge done) #1 en = 0;

      //multiply by -1
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 3;
      op_b = -1;
      @(posedge done) #1 en = 0;
     
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = -1;
      op_b = 4;
      @(posedge done) #1 en = 0;

      //multiply 4-quadrants
      //-/-
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = -2;
      op_b = -3;
      @(posedge done) #1 en = 0;
     
      //-/+
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = -2;
      op_b = 3;
      @(posedge done) #1 en = 0;
     
      //+/-
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 2;
      op_b = -3;
      @(posedge done) #1 en = 0;

      //+/+
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 2;
      op_b = 3;
      @(posedge done) #1 en = 0;

      //multiply largest positives
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = 7;
      op_b = 7;
      @(posedge done) #1 en = 0;
     
      //multiply largest negatives
      #100; 
      @(posedge clk) #1 en = 1;
      op_a = -8;
      op_b = -8;
      @(posedge done) #1 en = 0;
     
      #100 $finish;
   end

   //clock 
   always #10 clk = ~clk;   

      mul_addshift
     #(
       .DATA_W(DATA_W)
       )
   uut 
     (
      .clk(clk),
      
      .en(en),
      .sign(1'b1),
      .done(done),
      
      .op_a(op_a),
      .op_b(op_b),
      
      .product(product)
      );

endmodule
