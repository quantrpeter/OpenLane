/* verilator lint_off UNUSED */
module pc_reg(input wire clk,
              input wire rst,
              input wire jump_sign,
              input wire [`MXLEN] jump_address,
              input wire [5:0] stall,
              output reg[`MXLEN] pc,
              output reg ce
              );

    always @(posedge clk) begin
        if(rst == `RESET) begin
            ce <= `ChipDisable;
        end else begin
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= `ZeroDWord;
//        end else if(stall[0] == 1'd0) begin
  //          if(jump_sign == 1'b1)begin
    //            pc <= jump_address;
      //      end            
        end else begin
            pc <= pc+64'd4;
        end
    end
endmodule

