`define RESET 1'b1
`define MXLEN 63:0
`define INST_WIDTH 31:0
`define REG_WIDTH 4:0
`define ZeroWord 32'h00000000
`define ZeroDWord 64'h0000000000000000
`define ZeroDwordSize 63:0
`define InstMemNum 131071
`define InstMemNumLog2 17
`define AluOpBus 15:0
`define AluSelBus 2:0
`define ChipEnable  1'b1
`define ChipDisable 1'b0
`define NOPRegAddr  5'b00000
`define InstBus 31:0
`define InstAddrBus 31:0
`define WriteEnable 1'b1
`define WriteDisable 1'b0

/*opcode total in 16 bit
 15:12 bit is used to define type, 
 eg. 0 (32i + 64i), 1 (32m + 64m), 2 (32a+64a), 3 (32c + 64c)
 11:0 bit is used to define inst
*/
`define EXE_I_OR    16'h0000
`define EXE_I_ORI   16'h0024
`define EXE_I_ADD  16'h0001
`define EXE_I_AND   16'h0002
`define EXE_I_ANDI  16'h0025
`define EXE_I_XOR   16'h0003
`define EXE_I_XORI   16'h0026
`define EXE_I_SLT   16'h0004
`define EXE_I_SLTU  16'h0005
`define EXE_I_SLTIU  16'h0006
`define EXE_I_SUB   16'h0007
`define EXE_I_SLL   16'h0008
`define EXE_I_SRL   16'h0009
`define EXE_I_SRA   16'h000a
`define EXE_I_ECALL 16'h000b
`define EXE_I_EBREAK 16'h000c
`define EXE_I_JALR   16'h000d
`define EXE_I_LUI   16'h000e
`define EXE_I_AUIPC 16'h000f
`define EXE_I_LOAD    16'h0010
`define EXE_I_FENCE    16'h0011
//`define EXE_I_LW    16'h0012
`define EXE_I_LBU    16'h0013
`define EXE_I_LHU    16'h0014
`define EXE_I_SB    16'h0015
`define EXE_I_SH    16'h0016
`define EXE_I_SW    16'h0017
`define EXE_I_JAL  16'h0018
`define EXE_I_SLLW 16'h0019
`define EXE_I_SRLW 16'h001a
`define EXE_I_SRAW 16'h001b
`define EXE_I_LWU  16'h001c
//`define EXE_I_LD  16'h001d
`define EXE_I_SD  16'h001e
`define EXE_I_BEQ 16'h001f
`define EXE_I_BNE 16'h0020
`define EXE_I_BLT 16'h0021
`define EXE_I_BGE 16'h0022
`define EXE_I_ADDI 16'h0023

//size limit 
`define byte_limit 64'hff
`define hword_limit 64'hffff
`define word_limit 64'hffffffff
`define Dword_limit 64'hffffffffffffffff

//AluSel
`define EXE_NOP_OP 8'b0
`define EXE_RES_NOP 3'b0
`define WriteDisable 1'b0
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_JUMP  3'b010
`define EXE_RES_LOAD  3'b011
`define EXE_RES_SYSTEM 3'b100

`define RegAddrBus  4:0
`define RegBus  31:0

//risc-v funct 3
`define RV_TypeI_OP   7'b0110011
`define EXE_ADDI 3'b000


//data_ram
`define ByteWidth 7:0
`define DataMemNum 131071
`define DataMemNumLog2 17
