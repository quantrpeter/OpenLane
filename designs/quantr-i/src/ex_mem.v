/* verilator lint_off UNUSED */
module ex_mem (
    input wire clk, 
    input wire rst,
    input wire [`RegAddrBus] ex_wd,
    input wire ex_wreg,
    input wire [63:0] ex_wdata,
    input wire [5:0] stall,
    output reg [`RegAddrBus] mem_wd,
    output reg mem_wreg,
    output reg [63:0] mem_wdata,
    //hilo_reg
    input wire [31:0] ex_hi,
    input wire [31:0] ex_lo,
    input wire ex_whilo,
    output reg [31:0] mem_hi,
    output reg [31:0] mem_lo,
    output reg mem_whilo
);
    always @(posedge clk) begin
        if( rst == `RESET) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroDWord;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;
            mem_whilo <= 1'b0;
        end else if(stall[3]== 1'd1 && stall[4] == 1'd0) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroDWord;  
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;
            mem_whilo <= 1'b0;
        end else if(stall[3]== 1'd0) begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
            mem_whilo <= ex_whilo;
        end
    end 
endmodule
