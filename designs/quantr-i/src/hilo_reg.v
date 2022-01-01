module hilo_reg (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [31:0] hilo_reg_hi_i, //need to change
    input wire [31:0] hilo_reg_lo_i,
    output reg [31:0] hilo_reg_hi_o,
    output reg [31:0] hilo_reg_lo_o
);
    always @(posedge clk) begin
        if(rst == `RESET) begin
            hilo_reg_hi_o <= `ZeroWord;
            hilo_reg_lo_o <= `ZeroWord; 
        end else if(we == 1'b0) begin
            hilo_reg_hi_o <= hilo_reg_hi_i;
            hilo_reg_lo_o <= hilo_reg_lo_i; 
        end 
    end
endmodule
