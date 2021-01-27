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

   reg                        sign_reg;
   reg [DATA_W-1:0]           op_a_reg; //multiplicand register
   reg [$clog2(DATA_W+1):0]   pc;  //program counter register

   //
   //PROGRAM
   //
   always @(posedge clk)
     if (en) begin 
        pc <= pc+1'b1;
        
        case(pc)
          
          0: begin //load multiplicand and product
             op_a_reg <= op_a;
             if(sign) begin
                product <= { op_b[0]? {op_a[DATA_W-1], op_a} : {DATA_W+1{1'b0}}, op_b[DATA_W-1:1] };
                sign_reg <= 1'b1;
             end else begin
                product <= { op_b[0]? op_a : 1'b0, op_b[DATA_W-1:1] };
                sign_reg <= 1'b0;
             end
          end 
          DATA_W-1: begin //last partial product
             if(sign_reg) //subtract last partial product
               product <= { {product[2*DATA_W-1], product[2*DATA_W-1:DATA_W]} - (product[0]?  {op_a_reg[DATA_W-1], op_a_reg}: 1'b0), product[DATA_W-1:1]  };
             else //add last partial product
               product <= { {1'b0, product[2*DATA_W-1:DATA_W]} + (product[0]?  {1'b0, op_a_reg}: 1'b0), product[DATA_W-1:1]  };
             
             done <= 1'b1;
             
          end
          
          DATA_W:  pc <= pc; //finish   
          
          default: begin //arith shift then add
             if(sign_reg)
               product <= { {product[2*DATA_W-1], product[2*DATA_W-1:DATA_W]} + (product[0]?  {op_a_reg[DATA_W-1], op_a_reg}: 1'b0), product[DATA_W-1:1]  };
             else
               product <= { {1'b0, product[2*DATA_W-1:DATA_W]} + (product[0]?  {1'b0, op_a_reg}: 1'b0), product[DATA_W-1:1]  };
          end
          
        endcase
        
     end else begin // if (en)
        //load product-multiplier reg and operand a (multiplicant)
        product <= 1'b0;
        done <= 1'b0;
        pc <= 1'b0;
     end         
        
endmodule
