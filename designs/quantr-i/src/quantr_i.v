/* verilator lint_off PINCONNECTEMPTY */
/* verilator lint_off PINMISSING */

`include "constant.v"
module quantr_i(input clk,
                input rst,
                input wire [31:0] rom_data_i,
                output wire [`MXLEN] rom_addr_o,
                output wire rom_ce_o,
                output reg[`MXLEN] pc);
    wire[`MXLEN] pc_wire;
    wire[`MXLEN] id_pc_i;
    //wire[`INST_WIDTH] if_inst_wire;
    wire[`INST_WIDTH] id_inst_wire;
    wire[`MXLEN] reg1_data_i_wire;
    wire[`MXLEN] reg2_data_i_wire;
    wire reg1_read_o_wire;
    wire[`REG_WIDTH] reg1_addr_o_wire;
    wire reg2_read_o_wire;
    wire[`REG_WIDTH] reg2_addr_o_wire;
    wire[`AluOpBus] aluop_o_wire;
    wire[`AluSelBus] alusel_o_wire;
    wire[`MXLEN] reg1_o_wire;
    wire[`MXLEN] reg2_o_wire;
    wire[`REG_WIDTH] wd_o_wire;
    wire wreg_o_wire;
    // initial begin
    //     $dumpfile("test.fdb");
    // end
    
    // always @(*) begin
    //     $dumpvars();
    // end
    
    //ex + ex/mem
    wire ex_wreg_o;
    wire [`RegAddrBus] ex_wd_o;
    wire signed [63:0] ex_wdata_o;
    
    //ex/mem + mem
    wire mem_wreg_i;
    wire [`RegAddrBus] mem_wd_i;
    wire [63:0] mem_wdata_i;
    
    // mem + mem/wb
    wire mem_wreg_o;
    wire [`RegAddrBus] mem_wd_o;
    wire [63:0] mem_wdata_o;
    
    //mem/wb
    wire wb_wreg_i;
    wire [`RegAddrBus] wb_wd_i;
    wire [63:0] wb_wdata_i;
    
    
    //id/ex
    wire [`MXLEN] imm_i;
    wire [`AluOpBus] ex_aluop_i;
    wire [`AluSelBus] ex_aluse1_i;
    wire [63:0] ex_reg1_i;
    wire [63:0] ex_reg2_i;
    wire ex_wreg_i;
    wire [`REG_WIDTH] ex_wd_i;
    
    wire [`MXLEN] imm_out;
    
    //jump
    wire jump_sign;
    wire [`MXLEN]jump_address;
    wire id_is_in_delayslot_o;
    wire [`MXLEN] id_link_address_o;
    wire id_next_inst_in_delayslot_o;
    wire id_is_in_delayslot_i;
    wire idex_ex_is_in_delayslot;
    wire [`MXLEN] idex_ex_link_address;

    //ctrl 
    wire ctrl_id;
    wire ctrl_ex;
    wire [5:0] ctrl_stall;

    //hilo_reg 
    wire [31:0] hilo_reg_hi;
    wire [31:0] hilo_reg_lo;
    wire ex_whilo_o;
    wire [31:0] ex_hi_o;
    wire [31:0] ex_lo_o;
    wire mem_whilo_o;
    wire [31:0] mem_hi_o;
    wire [31:0] mem_lo_o;
    wire mem_wb_whilo_i;
    wire [31:0] mem_wb_hi_i;
    wire [31:0] mem_wb_lo_i;
    wire mem_wb_whilo_o;
    wire [31:0] mem_wb_hi_o;
    wire [31:0] mem_wb_lo_o;

    
    //for ex to id
    wire [`RegAddrBus] ex_id_wd_i;
    wire ex_id_wreg_i;
    wire [`MXLEN] ex_id_wdata_i;
    
    assign pc = id_pc_i;
    
    pc_reg pc_reg(
    .clk(clk),
    .rst(rst),
    .jump_sign(jump_sign),
    .jump_address(jump_address),
    .pc(pc_wire),
    .ce(rom_ce_o),
    .stall(ctrl_stall)
    );
    
    assign rom_addr_o = pc_wire;

    if_id if_id(
    .clk(clk),
    .rst(rst),
    .if_pc(pc_wire),
    .if_inst(rom_data_i),
    .id_pc(id_pc_i),
    .id_inst(id_inst_wire),
    .stall(ctrl_stall)
    );
    
    
    id id(
    .clk(clk),
    .inst_i(id_inst_wire),
    .rst(rst),
    .reg1_data_i(reg1_data_i_wire),
    .reg2_data_i(reg2_data_i_wire),
    
    .aluop_o(aluop_o_wire),
    .alusel_o(alusel_o_wire),
    .reg1_o(reg1_o_wire),
    .reg2_o(reg2_o_wire),
    .wd_o(wd_o_wire),
    .wreg_o(wreg_o_wire),
    .reg1_read_o(reg1_read_o_wire),
    .reg2_read_o(reg2_read_o_wire),
    .reg1_addr_o(reg1_addr_o_wire),
    .reg2_addr_o(reg2_addr_o_wire),
    .imm(imm_i),
    .ex_wreg_i(ex_id_wreg_i),
    .ex_wdata_i(ex_id_wdata_i),
    .ex_wd_i(ex_id_wd_i),
    .mem_wreg_i(mem_wreg_o),
    .mem_wdata_i(mem_wdata_o),
    .mem_wd_i(mem_wd_o),
    .stallreq_from_id(ctrl_id),
    .pc_i(id_pc_i),
    //jump shit
    .jump_sign(jump_sign),
    .jump_address(jump_address),
    .is_in_delayslot_o(id_is_in_delayslot_o),
    .link_addr_o(id_link_address_o),
    .next_inst_in_delayslot_o(id_next_inst_in_delayslot_o),
    .is_in_delayslot_i(id_is_in_delayslot_i)
    );
    
    register register(
    .re1(reg1_read_o_wire),
    .raddr1(reg1_addr_o_wire),
    
    .re2(reg2_read_o_wire),
    .raddr2(reg2_addr_o_wire),
    
    .we(wb_wreg_i),
    .waddr(wb_wd_i),
    .wdata(wb_wdata_i),
    .rst(rst),
    .clk(clk),
    
    .rdata1(reg1_data_i_wire),
    .rdata2(reg2_data_i_wire)
    );
    
    id_ex id_ex(
    .clk(clk),
    .rst(rst),
    .id_aluop_i(aluop_o_wire),
    .id_alusel_i(alusel_o_wire),
    .id_reg1_i(reg1_o_wire),
    .id_reg2_i(reg2_o_wire),
    .id_wd_i(wd_o_wire),
    .id_wreg_i(wreg_o_wire),
    .ex_aluop_o(ex_aluop_i),
    .ex_alusel_o(ex_aluse1_i),
    .ex_reg1_o(ex_reg1_i),
    .ex_reg2_o(ex_reg2_i),
    .ex_wd_o(ex_wd_i),
    .ex_wreg_o(ex_wreg_i),
    .imm_in(imm_i),
    .imm_out(imm_out),
    .stall(ctrl_stall),
    .id_is_in_delayslot(id_is_in_delayslot_o),
    .id_link_address(id_link_address_o),
    .next_inst_in_delatslot_i(id_next_inst_in_delayslot_o),
    .ex_is_in_delayslot(idex_ex_is_in_delayslot),
    .ex_link_address(idex_ex_link_address),
    .is_in_delayslot_o(id_is_in_delayslot_i)
    );
    
    
    ex ex(
    //.clk(clk),
    .rst(1'b0),
    .aluop_i(ex_aluop_i),
    .aluse_i(ex_aluse1_i),
    .reg1_i(ex_reg1_i),
    .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i),
    .wreg_i(ex_wreg_i),
    .wd_o(ex_wd_o),
    .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o),
    .imm(imm_out),
    //.jump_imm(jump_imm),
    //.jump_sign(jump_sign),
    .pc_in(pc),
    .id_wd_o(ex_id_wd_i),
    .id_wreg_o(ex_id_wreg_i),
    .id_wdata_o(ex_id_wdata_i),
    .stallreq_from_ex(ctrl_ex),
    //hilo_reg
    .hi_i(hilo_reg_hi),
    .lo_i(hilo_reg_lo),
    .wb_hi_i(mem_wb_hi_o),
    .wb_lo_i(mem_wb_lo_o),
    .wb_whilo_i(mem_wb_whilo_o),
    .mem_hi_i(mem_wb_hi_i),
    .mem_lo_i(mem_wb_lo_i),
    .mem_whilo_i(mem_wb_whilo_i),
    .hi_o(ex_hi_o),
    .lo_o(ex_lo_o),
    .whilo_o(ex_whilo_o),
    //.pc_out(pc_wire)
    .link_address_i(idex_ex_link_address),
    .is_in_delayslot_i(idex_ex_is_in_delayslot)
    );

    ctrl ctrl(
        .rst(rst),
        .stallreq_from_id(ctrl_id),
        .stallreq_from_ex(ctrl_ex),
        .stall(ctrl_stall)
    );
    
    ex_mem ex_mem(
    .clk(clk),
    .rst(rst),
    .ex_wd(ex_wd_o),
    .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),
    .mem_wd(mem_wd_i),
    .mem_wreg(mem_wreg_i),
    .mem_wdata(mem_wdata_i),
    .stall(ctrl_stall),
    //hilo_reg
    .ex_hi(ex_hi_o),
    .ex_lo(ex_lo_o),
    .ex_whilo(ex_whilo_o),
    .mem_hi(mem_hi_o),
    .mem_lo(mem_lo_o),
    .mem_whilo(mem_whilo_o)
    );
    
    mem mem(
    .rst(rst),
    .wd_i(mem_wd_i),
    .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i),
    .wd_o(mem_wd_o),
    .wreg_o(mem_wreg_o),
    .wdata_o(mem_wdata_o),
    //hilo_reg
    .hi_i(mem_hi_o),
    .lo_i(mem_lo_o),
    .whilo_i(mem_whilo_o),
    .hi_o(mem_wb_hi_i),
    .lo_o(mem_wb_lo_i),
    .whilo_o(mem_wb_whilo_i)
    );
    
    mem_wb mem_wb(
    .clk(clk),
    .rst(rst),
    .mem_wd(mem_wd_o),
    .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    .wb_wd(wb_wd_i),
    .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i),
    .stall(ctrl_stall),
    //hilo_reg
    .mem_hi(mem_wb_hi_i),
    .mem_lo(mem_wb_lo_i),
    .mem_whilo(mem_wb_whilo_i),
    .wb_hi(mem_wb_hi_o),
    .wb_lo(mem_wb_lo_o),
    .wb_whilo(mem_wb_whilo_o)
    );

    hilo_reg hilo_reg(
    .clk(clk),
    .rst(rst),
    .we(mem_wb_whilo_o),
    .hilo_reg_hi_i(mem_wb_hi_o), //need to change
    .hilo_reg_lo_i(mem_wb_lo_o),
    .hilo_reg_hi_o(hilo_reg_hi),
    .hilo_reg_lo_o(hilo_reg_lo)
    );
    
endmodule
