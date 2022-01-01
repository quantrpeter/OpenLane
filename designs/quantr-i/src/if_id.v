/* verilator lint_off UNUSED */
module if_id(input wire clk,
             input wire rst,
             input wire[`MXLEN] if_pc,
             input wire [`INST_WIDTH] if_inst,
             input wire [5:0] stall,
             output reg[`MXLEN] id_pc,
             output reg[`INST_WIDTH] id_inst);
    always @(posedge clk) begin
        if (rst == `RESET) begin
            id_pc   <= `ZeroDWord;
            id_inst <= `ZeroWord;
        end else if(stall[1]== 1'd1 && stall[2] == 1'd0) begin
            id_pc   <= `ZeroDWord;
            id_inst <= `ZeroWord;
        end else if(stall[1]== 1'd0) begin
            id_pc   <= if_pc;
            id_inst <= if_inst;
        end
    end
endmodule
