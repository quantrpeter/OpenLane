/* verilator lint_off UNUSED */
module mem_wb (
    input wire clk, 
    input wire rst,
    input wire [`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire [63:0] mem_wdata,
    input wire [5:0] stall,
    output reg [`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg [63:0] wb_wdata,
    //hilo_reg
    input wire [31:0] mem_hi,
    input wire [31:0] mem_lo,
    input wire mem_whilo,
    output reg [31:0] wb_hi,
    output reg [31:0] wb_lo,
    output reg wb_whilo
);
    always @(posedge clk) begin
        if(rst == `RESET) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroDWord;
            wb_hi <= `ZeroWord;
            wb_lo <= `ZeroWord;
            wb_whilo <= 1'b0;
        end else if(stall[4]== 1'd1 && stall[5] == 1'd0) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroDWord;
            wb_hi <= `ZeroWord;
            wb_lo <= `ZeroWord;
            wb_whilo <= 1'b0;
        end else if(stall[4]== 1'd0) begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
            wb_hi <= mem_hi;
            wb_lo <= mem_lo;
            wb_whilo <= mem_whilo;
        end
    end
endmodule
