/* verilator lint_off COMBDLY */
module register(input wire clk,
                input wire rst,
                input wire we,
                input wire [`REG_WIDTH] waddr,
                input wire [`MXLEN] wdata,
                input wire re1,
                input wire [`REG_WIDTH] raddr1,
                input wire re2,
                input wire [`REG_WIDTH] raddr2,

                output reg[`MXLEN] rdata1,
                output reg[`MXLEN] rdata2);
    
    reg[`MXLEN] regs[0:31];
    
    always @(posedge clk) begin
        if (rst != `RESET) begin
            if (we == 1 && waddr != 0) begin
                regs[waddr] <= wdata;
            end
        end
    end
    
    always @(*) begin
        if (rst != `RESET) begin
            rdata1 <= `ZeroDWord;
            end else if (raddr1 == 0) begin
            rdata1 <= `ZeroDWord;
            end else if ((raddr1 == waddr) && (we == 1) && (re1 == 1)) begin
            rdata1 <= wdata;
            end else if (re1 == 1) begin
            rdata1 <= regs[raddr1];
            end else begin
            rdata1 <= `ZeroDWord;
        end
    end
    
    always @(*) begin
        if (rst != `RESET) begin
            rdata2 <= `ZeroDWord;
            end else if (raddr2 == 0) begin
            rdata2 <= `ZeroDWord;
            end else if ((raddr2 == waddr) && (we == 1) && (re2 == 1)) begin
            rdata2 <= wdata;
            end else if (re2 == 1) begin
            rdata2 <= regs[raddr2];
            end else begin
            rdata2 <= `ZeroDWord;
        end
    end
endmodule
