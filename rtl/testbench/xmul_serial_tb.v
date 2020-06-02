`timescale 1ns / 1ps

module xmul_serial_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns

   parameter DATA_W = 32;

   parameter TEST_SZ = 100;

   reg clk;
   reg rst;

   reg start;
   wire done;

   wire [DATA_W-1:0] op_a;
   wire [DATA_W-1:0] op_b;
   wire [2*DATA_W-1:0] product;

   wire [2*DATA_W-1:0] p;

   reg [DATA_W-1:0]    op_a_in [0:TEST_SZ-1];
   reg [DATA_W-1:0]    op_b_in [0:TEST_SZ-1];
   reg [2*DATA_W-1:0]  product_out [0:TEST_SZ-1];

   integer             i, j;

   xmul_serial # (
                  .DATA_W(DATA_W)
                  )
   uut (
		.clk(clk),
        .rst(rst),

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

      // Global reset of FPGA
      #100;

      clk = 1;
      rst = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	     op_a_in[i] = $random%(2**(DATA_W-1));
	     op_b_in[i] = $random%(2**(DATA_W-1));
	     product_out[i] = op_a_in[i] * op_b_in[i];
      end

      // Global reset
      #(clk_period+1);
      rst = 1;

      #clk_period;
      rst = 0;

      #(TEST_SZ*(DATA_W+2)*clk_period);

      $display("Test completed successfully");
      $finish;
   end

   always 
     #(clk_period/2) clk = ~clk;   

   always @ (posedge clk) begin
      if (rst) begin
         start <= 0;
      end else if (done & ~start) begin
         start <= 1;
      end else begin
         start <= 0;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         j <= 0;
      end else if (start) begin
         j <= j+1;
      end
   end

   // assign inputs
   assign op_a = op_a_in[j];
   assign op_b = op_b_in[j];

   // show expected results
   assign p = product_out[j];

   always @ (posedge clk) begin
      if(done && ~start && j > 0 && product != product_out[j-1]) begin
	     $display("Test failed at %d", $time);
	     $finish;
      end
   end

endmodule
