/* verilator lint_off COMBDLY */
module mem (
    input wire rst,
    input wire [`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire [63:0] wdata_i,
    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [63:0] wdata_o,
    //hilo_reg
    input wire [31:0] hi_i,
    input wire [31:0] lo_i,
    input wire whilo_i,
    output reg [31:0] hi_o,
    output reg [31:0] lo_o,
    output reg whilo_o

);
    always @(*) begin
        if(rst == `RESET) begin
          wd_o = `NOPRegAddr;
          wreg_o = `WriteDisable;
          wdata_o = `ZeroDWord;
          hi_o <= `ZeroWord;
          lo_o<= `ZeroWord;
          whilo_o <= 1'b0;
        end else begin
          wd_o = wd_i;
          wreg_o = wreg_i;
          wdata_o = wdata_i;
          hi_o <= hi_i;
          lo_o<= lo_i;
          whilo_o <= whilo_i;
        end
    end
endmodule
