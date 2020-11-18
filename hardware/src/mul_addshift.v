`timescale 1ns / 1ps

module mul_addshift
  # (
     parameter DATA_W = 32
     )
   (
    input                     clk,
    input                     en,
    input                     sign,
    output reg                done,

    input [DATA_W-1:0]        op_a,
    input [DATA_W-1:0]        op_b,
    output reg [2*DATA_W-1:0] product
    );

   //done register
   reg                        done_nxt;
   always @ (posedge clk)
     done <= done_nxt;
   
   //product sign register
   reg [DATA_W-1:0] op_a_int;
   reg [DATA_W-1:0] op_b_int;
   reg              operand_reg_en;   

   reg              prod_sign;
   always @ (posedge clk)
     if(operand_reg_en)
       prod_sign <= sign? op_a[DATA_W-1]^op_b[DATA_W-1]: 1'b0;

   //operand 'a' register
   reg [DATA_W-1:0] op_a_reg;
   always @ (posedge clk)
     if(operand_reg_en)
       op_a_reg <= op_a_int;


   //program counter register
   reg [$clog2(DATA_W):0]     pc, pc_nxt;
       
   //product registers
   reg [2*DATA_W-1:0] product_reg;
   reg [2*DATA_W-1:0] product_nxt;
   reg [2*DATA_W:0]   product_int;
   always @ (posedge clk)
     if(!en)
        product_reg <= 1'b0;
     else begin
        product_reg <= product_nxt;
        if (pc == (DATA_W-1))
          product <= product_nxt;
     end
   //
   //PROGRAM
   //
   
   always @ (posedge clk)
     if(!en)
       pc <= 1'b0;
     else
       pc <= pc_nxt;

   //the program
   always @* begin

      pc_nxt = pc+1'b1;
      product_nxt = product_reg;
      product_int = product_reg;
      done_nxt = 1'b0;

      case(pc)

        0: begin //wait for en, register operands, first partial product
           if(en) begin

              //invert operands if signed multiply
              op_a_int = op_a;
              op_b_int = op_b;
      
              if(sign && op_a[DATA_W-1])
                op_a_int = -op_a;

              if(sign && op_b[DATA_W-1])
                op_b_int = -op_b;
              
              //register operands and sign
              operand_reg_en = 1'b1;

              //compute first partila product
              product_int = (op_b_int[0]? {op_a_int, {DATA_W{1'b0}}}: 1'b0) + op_b_int;
              product_nxt = product_int[2*DATA_W:1];

           end else
             pc_nxt = pc;
        end
        
        DATA_W: begin  //done 
           if(en)
             pc_nxt = pc;
        end

        default: begin //other partial products: add then shift
           product_int = (product_reg[0]? {op_a_reg, {DATA_W{1'b0}}}: 1'b0) + product_reg;
           product_nxt = (pc == (DATA_W-1) && prod_sign)? -product_int[DATA_W:1] : product_int[2*DATA_W:1];
           done_nxt = (pc == (DATA_W-1));
        end

      endcase

   end

endmodule
