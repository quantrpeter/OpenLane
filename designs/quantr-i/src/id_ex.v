/* verilator lint_off UNUSED */

`include "constant.v"
module id_ex(input wire clk,
             input wire rst,
             input wire[`AluOpBus] id_aluop_i,
             input wire[`AluSelBus] id_alusel_i,
             input wire[`MXLEN] id_reg1_i,
             input wire[`MXLEN] id_reg2_i,
             input wire[`REG_WIDTH] id_wd_i,
             input wire id_wreg_i,
             input wire [`MXLEN] imm_in,
             input wire [5:0] stall,
             output reg[`AluOpBus] ex_aluop_o,
             output reg[`AluSelBus] ex_alusel_o,
             output reg[`MXLEN] ex_reg1_o,
             output reg[`MXLEN] ex_reg2_o,
             output reg[`REG_WIDTH] ex_wd_o,
             output reg ex_wreg_o,
             output reg[`MXLEN] imm_out,
             //jump shit
             input wire id_is_in_delayslot,
             input wire [`MXLEN] id_link_address,
             input wire next_inst_in_delatslot_i,
             output reg ex_is_in_delayslot,
             output reg [`MXLEN] ex_link_address,
             output reg is_in_delayslot_o
             );
    
    always @ (posedge clk) begin
        if (rst == `RESET) begin
            ex_aluop_o  <= 16'h000;
            ex_alusel_o <= `EXE_RES_NOP;
            ex_reg1_o   <= `ZeroDWord;
            ex_reg2_o   <= `ZeroDWord;
            ex_wd_o     <= 5'b0;
            ex_wreg_o   <= `WriteDisable;
            imm_out     <= `ZeroDWord;
            ex_is_in_delayslot <= 1'd0;
            is_in_delayslot_o <= 1'd0;
            ex_link_address <= `ZeroDWord;
           // pc_out      <= `ZeroDWord;
        end else if(stall[2]== 1'd1 && stall[3] == 1'd0) begin
            ex_aluop_o  <= 16'h000;
            ex_alusel_o <= `EXE_RES_NOP;
            ex_reg1_o   <= `ZeroDWord;
            ex_reg2_o   <= `ZeroDWord;
            ex_wd_o     <= 5'b0;
            ex_wreg_o   <= `WriteDisable;
            imm_out     <= `ZeroDWord;
        end else if(stall[2]== 1'd0) begin
            ex_aluop_o  <= id_aluop_i;
            ex_alusel_o <= id_alusel_i;
            ex_reg1_o   <= id_reg1_i;
            ex_reg2_o   <= id_reg2_i;
            ex_wd_o     <= id_wd_i;
            ex_wreg_o   <= id_wreg_i;
            imm_out     <= imm_in;
            ex_is_in_delayslot <= id_is_in_delayslot;
            is_in_delayslot_o <= next_inst_in_delatslot_i;
            ex_link_address <= id_link_address;
            //pc_out      <= pc_in;
        end
    end
endmodule
    
