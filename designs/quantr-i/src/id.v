/* verilator lint_off UNUSED */
/* verilator lint_off COMBDLY */
module id(input wire clk,
          input wire rst,
          input wire[`INST_WIDTH] inst_i,
          input wire[`MXLEN] reg1_data_i,
          input wire[`MXLEN] reg2_data_i,
          input wire ex_wreg_i,
          input wire [`MXLEN] ex_wdata_i,
          input wire [`REG_WIDTH] ex_wd_i,
          input wire mem_wreg_i,
          input wire [`MXLEN] mem_wdata_i,
          input wire [`REG_WIDTH] mem_wd_i,
          input wire[`MXLEN] pc_i,
          output reg reg1_read_o,
          output reg reg2_read_o,
          output reg[`REG_WIDTH] reg1_addr_o,
          output reg[`REG_WIDTH] reg2_addr_o,
          output reg[`AluOpBus] aluop_o,
          output reg[`AluSelBus] alusel_o,
          output reg[`MXLEN] reg1_o,
          output reg[`MXLEN] reg2_o,
          output reg[`REG_WIDTH] wd_o,
          output reg wreg_o,
          output reg[`MXLEN] imm,
          output reg stallreq_from_id,
          //branch
          output reg jump_sign,
          output reg [`MXLEN] jump_address,
          output reg is_in_target_address_o,
          output reg is_in_delayslot_o,
          output reg [`MXLEN] link_addr_o,
          output reg next_inst_in_delayslot_o,
          input wire is_in_delayslot_i
          );
    
    wire[6:0] opcode = inst_i[6:0];
    wire[2:0] funct3 = inst_i[14:12];
    wire[6:0] funct7 = inst_i[31:25];
    
    //reg[`MXLEN] imm;

    always @(*) begin
        if (rst == `RESET) begin
            aluop_o    <=16'h0;
            alusel_o   <=3'b000;
            wd_o       <=5'b00000;
            wreg_o     <=1'b0;
            reg1_read_o<=1'b0;
            reg2_read_o<=1'b0;
            reg1_addr_o<=5'b00000;
            reg2_addr_o<=5'b00000;
            imm        <=`ZeroDWord;
//            IMM        <=`ZeroDWord;
            stallreq_from_id <=1'd0;
            jump_sign <= 1'b0;
            jump_address <= `ZeroDWord;
            is_in_target_address_o <= 1'b0;
            is_in_delayslot_o <= 1'b0;
            link_addr_o <= `ZeroDWord;
            next_inst_in_delayslot_o <= 1'b0;
            //pc_out<=`ZeroDWord;
            end else begin
            aluop_o    <=16'h0;
            alusel_o   <=3'b000;
            wd_o       <=5'b00000;
            wreg_o     <=1'b0;
            reg1_read_o<=1'b0;
            reg2_read_o<=1'b0;
            reg1_addr_o<=inst_i[19:15];
            reg2_addr_o<=inst_i[24:20];
            imm        <=`ZeroDWord;
//            IMM        <=`ZeroDWord;
            stallreq_from_id <=1'd0;
            jump_sign <= 1'b0;
            jump_address <= `ZeroDWord;
            is_in_target_address_o <= 1'b0;
            is_in_delayslot_o <= 1'b0;
            link_addr_o <= `ZeroDWord;
            next_inst_in_delayslot_o <= 1'b0;
            //pc_out<=pc_in;
            
            if (opcode == 7'b0110011 && funct3 == 3'd6 && funct7 == 7'd0) begin
                //OR
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_OR;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
//                imm        <={48'h0, inst_i[15:0]};
                wd_o       <=inst_i[11:7];
                end else if (opcode == 7'b0010011 && funct3 == 3'd6) begin
                //ORI
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ORI;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                /*
                if( inst_i[31] == 1'b1)begin
                    imm        <={52'hfffffffffffff, inst_i[31:20]};
                end else begin
                    imm        <={52'h0, inst_i[31:20]};
                end
                */
                wd_o       <=inst_i[11:7];
                end else if (opcode == 7'b0110011 && funct3 == 3'd0 && funct7 == 7'd0) begin
                //add
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ADD;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010011 && funct3 == 3'd0) begin
                //addi
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ADDI;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd7 && funct7 == 7'd0)begin
                //and
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_AND;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010011 && funct3 == 3'd7) begin
                //andi
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ANDI;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd4 && funct7 == 7'd0)begin
                //xor
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_XOR;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010011 && funct3 == 3'd4) begin
                //xori
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_XORI;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd2 && funct7 == 7'd0)begin
                //slt
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                reg2_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLT;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010011 && funct3 == 3'd4) begin
                //slti
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLT;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd3 && funct7 == 7'd0)begin
                //sltu
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLTU;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010011 && funct3 == 3'd4) begin
                //sltiu
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLTIU;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd0 && funct7 == 7'b0100000)begin
                //sub
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SUB;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'd1 && funct7 == 7'd0)begin
                //sll
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLL;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0111011 && funct3 == 3'd1 && funct7 == 7'd0)begin
                //sllw
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLLW;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'b101 && funct7 == 7'd0) begin
                //srl
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRL;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0111011 && funct3 == 3'b101 && funct7 == 7'd0) begin
                //srlw
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRLW;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110011 && funct3 == 3'b101 && funct7 == 7'b0100000) begin
                //sra
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRA;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0111011 && funct3 == 3'b101 && funct7 == 7'b0100000) begin
                //sraw
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRAW;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (inst_i == 32'b00000000000000000000000001110011) begin
                //ecall
                aluop_o  <=`EXE_I_ECALL;
                alusel_o <=`EXE_RES_JUMP;
                end else if (inst_i == 32'b00000000000100000000000001110011) begin
                //ebreak
                aluop_o  <=`EXE_I_EBREAK;
                alusel_o <=`EXE_RES_JUMP;
                end else if (opcode == 7'b1101111 && funct3 == 3'b000) begin
                //jalr
                wd_o       <=inst_i[11:7];
                wreg_o     <=1'b0;
                reg1_read_o<=1'b0;
                reg2_read_o<=1'b0;
                link_addr_o <= pc_i + 64'd8;
                jump_sign <= 1'd1;
                next_inst_in_delayslot_o <= 1'd1;
                imm        <={52'h0, inst_i[31:20]};
                aluop_o    <=`EXE_I_JALR;
                alusel_o   <=`EXE_RES_JUMP;
                jump_address <={52'h0, inst_i[31:20]};
                end else if (opcode == 7'b1101111) begin
                //jal
                aluop_o  <=`EXE_I_JAL;
                alusel_o <=`EXE_RES_JUMP;
                imm      <={43'h0,inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
                jump_sign <= 1'd1;
                next_inst_in_delayslot_o <= 1'd1;
                jump_address <= {43'h0,inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
                end else if (opcode == 7'b1100111 && funct3 == 3'b000) begin
                //jalr
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_JALR;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0110111) begin
                //lui
                wreg_o     <=1'b1;
                reg1_read_o<=1'b0;
                aluop_o    <=`EXE_I_LUI;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={44'h0, inst_i[31:12]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0010111) begin
                //auipc
                wreg_o     <=1'b1;
                reg1_read_o<=1'b0;
                aluop_o    <=`EXE_I_AUIPC;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={44'h0, inst_i[31:12]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b000) begin
                //LB
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LOAD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b001) begin
                //LH
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LOAD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b010) begin
                //LW
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LOAD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b011) begin
                //LD
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LOAD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b100) begin
                //LBU
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LBU;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b101) begin
                //LHU
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LHU;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0000011 && funct3 == 3'b110) begin
                //LWU
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_LWU;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOAD;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0100011 && funct3 == 3'b000) begin
                //SB
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                reg1_addr_o<=inst_i[24:20];
                aluop_o    <=`EXE_I_SB;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:25],inst_i[11:7] };
                wd_o       <=inst_i[19:15];
                 
                end else if (opcode == 7'b0100011 && funct3 == 3'b001) begin
                //SH
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                reg1_addr_o<=inst_i[24:20];
                aluop_o    <=`EXE_I_SH;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:25],inst_i[11:7] };
                wd_o       <=inst_i[19:15];
                 
                end else if (opcode == 7'b0100011 && funct3 == 3'b010) begin
                //SW
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                reg1_addr_o<=inst_i[24:20];
                aluop_o    <=`EXE_I_SW;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:25],inst_i[11:7] };
                wd_o       <=inst_i[19:15];
                 
                end else if (opcode == 7'b0100011 && funct3 == 3'b011) begin
                //SD
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                reg1_addr_o<=inst_i[24:20];
                aluop_o    <=`EXE_I_SD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:25],inst_i[11:7] };
                wd_o       <=inst_i[19:15];
                 
                end else if (opcode == 7'b0011011 && funct3 == 3'b000) begin
                //addiw
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ADD;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0111011 && funct3 == 3'b000 && funct7 == 7'd0) begin
                //addw
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_ADD;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b0111011 && funct3 == 3'd0 && funct7 == 7'b0100000)begin
                //sub
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SUB;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={52'h0, inst_i[31:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'd0)begin
                //beq
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BEQ;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
//                wd_o       <=inst_i[11:7];
                if(reg1_o == reg2_o) begin
                   jump_address <=  {52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                   jump_sign <= 1'd1;
                   next_inst_in_delayslot_o <= 1'd1;
                end
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'd1)begin
                //bne
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BNE;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];
                if(reg1_o != reg2_o) begin
                   jump_address <=  {52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                   jump_sign <= 1'd1;
                   next_inst_in_delayslot_o <= 1'd1;
                end
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'b100)begin
                //blt
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BLT;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];
                if(reg1_o < reg2_o) begin
                   jump_address <=  {52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                   jump_sign <= 1'd1;
                   next_inst_in_delayslot_o <= 1'd1;
                end
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'b101)begin
                //bge
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BGE;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];

                if(reg1_o > reg2_o) begin
                   jump_address <=  {52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                   jump_sign <= 1'd1;
                   next_inst_in_delayslot_o <= 1'd1;
                end
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'b110)begin
                //bltu
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BLT;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];
                 
                end else if (opcode == 7'b1100011 && funct3 == 3'b111)begin
                //bgeu
                wreg_o     <=1'b1;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_BGE;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_JUMP;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0001111 && funct3 == 3'b000)begin
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_FENCE;
                reg2_read_o<=1'b1;
                alusel_o   <=`EXE_RES_SYSTEM;
                imm        <={52'h0,inst_i[31],inst_i[30:25],inst_i[11:8],1'b0};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0010011 && funct3 == 3'b001 && funct7 == 7'd0)begin
                //slli
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLL;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0010011 && funct3 == 3'b101 && funct7 == 7'd0)begin
                //srli
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRL;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0010011 && funct3 == 3'b101 && funct7 == 7'b0100000)begin
                //srai
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRA;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0011011 && funct3 == 3'b001 && funct7 == 7'b0000000)begin
                //slliw
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SLLW;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0011011 && funct3 == 3'b101 && funct7 == 7'b0000000)begin
                //srliw
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRLW;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
                 
                end else if(opcode == 7'b0011011 && funct3 == 3'b101 && funct7 == 7'b0100000)begin
                //sraiw
                wreg_o     <=1'b0;
                reg1_read_o<=1'b1;
                aluop_o    <=`EXE_I_SRAW;
                reg2_read_o<=1'b0;
                alusel_o   <=`EXE_RES_LOGIC;
                imm        <={59'h0,inst_i[24:20]};
                wd_o       <=inst_i[11:7];
            end
        end
    end

    always @(*) begin
        if (rst == `RESET) begin
            is_in_delayslot_o<= 1'd0;
        end else begin
            is_in_delayslot_o<= is_in_delayslot_i;
        end
    end
    
    always @(*) begin
        if (rst == `RESET) begin
            reg1_o<=`ZeroDWord;
        end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
            reg1_o<=ex_wdata_i;
        end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
            reg1_o<=mem_wdata_i;
        end else if (reg1_read_o == 1'b1) begin
            reg1_o<=reg1_data_i;
        end else if (reg1_read_o == 1'b0) begin
            reg1_o<=imm;
        end else begin
            reg1_o<=`ZeroDWord;
        end
    end
    
    always @(*) begin
        if (rst == `RESET) begin
            reg2_o<=`ZeroDWord;
        end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
            reg2_o<=ex_wdata_i;
        end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
            reg2_o<=mem_wdata_i;
        end else if (reg2_read_o == 1'b1) begin
            reg2_o<=reg2_data_i;
        //end else if (reg2_read_o == 1'b0) begin
        //    reg2_o<=imm;
        end else begin
            reg2_o<=`ZeroDWord;
        end
    end
endmodule
