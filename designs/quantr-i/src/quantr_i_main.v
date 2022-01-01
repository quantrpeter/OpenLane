`include "constant.v"
module quantr_i_main (
    input wire clk,
    input wire rst,
    output wire [63:0] pc_out
);

    wire [63:0] inst_addr;
    wire [31:0] inst;
    wire rom_ce;

    quantr_i quantr_i(
        .clk(clk),
        .rst(rst),
        .rom_data_i(inst),
        .rom_addr_o(inst_addr),
        .rom_ce_o(rom_ce),
        .pc(pc_out)
    );

    rom rom(
        .ce(rom_ce),
        .addr(inst_addr),
        .inst(inst)
    );
    
endmodule
