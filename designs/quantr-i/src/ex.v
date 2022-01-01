/* verilator lint_off LATCH */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off COMBDLY */
/* verilator lint_off UNUSED */
module ex(
          //input wire clk,
          input wire rst,
          input wire [`AluOpBus] aluop_i,
          input wire [`AluSelBus] aluse_i,
          input wire [`MXLEN] reg1_i,
          input wire [`MXLEN] reg2_i,
          input wire [`REG_WIDTH] wd_i,
          input wire wreg_i,
          input wire signed [`MXLEN] imm,
          //output reg [`MXLEN] jump_imm,
          //output reg jump_sign,
          input wire [`MXLEN] pc_in,
          output reg [`RegAddrBus] wd_o,
          output reg wreg_o,
          output reg signed [`MXLEN] wdata_o,
          output reg [`RegAddrBus] id_wd_o,
          output reg id_wreg_o,
          output reg signed [`MXLEN] id_wdata_o,
          output reg stallreq_from_ex,
          //hilo_reg
          input wire [31:0] hi_i,
          input wire [31:0] lo_i,
          input wire [31:0] wb_hi_i,
          input wire [31:0] wb_lo_i,
          input wire wb_whilo_i,
          input wire [31:0] mem_hi_i,
          input wire [31:0] mem_lo_i,
          input wire mem_whilo_i,
          output reg[31:0] hi_o,
          output reg [31:0] lo_o,
          output reg whilo_o,         
          //output reg [`MXLEN] pc_out
          //jump shit
          input wire [`MXLEN] link_address_i,
          input wire is_in_delayslot_i
          );
    
    reg  signed[`ZeroDwordSize] logicout;

    //hi_lo
    reg [31:0] shiftres;
    reg [31:0] moveres;
    reg [31:0] HI;
    reg [31:0] LO;
    
    reg [`ZeroDwordSize] readRegValue;

    reg[`MXLEN] regs[0:31];

    reg re;

    //assign pc_out  <= pc_in;
    //this part need to rewrite in future, moveres and shiftres
    //they are all used in m
    always @(*) begin
        if (rst == `RESET) begin
            {HI,LO} <= {`ZeroWord,`ZeroWord};
            moveres <= `ZeroWord;
            shiftres <= `ZeroWord;
        end else if(mem_whilo_i == 1'b1) begin
            {HI,LO} <= {mem_hi_i,mem_lo_i};
            moveres <= `ZeroWord;
            shiftres <= `ZeroWord;
        end else if(wb_whilo_i == 1'b1) begin
            {HI,LO} <= {wb_hi_i,wb_lo_i};
            moveres <= `ZeroWord;
            shiftres <= `ZeroWord;
        end else begin
            {HI,LO} <= {hi_i,lo_i};
            moveres <= `ZeroWord;
            shiftres <= `ZeroWord;
        end 
    end
    
    always @(*) begin
        if (rst == `RESET) begin
            logicout  <= `ZeroDWord;
            //jump_sign  <= 1'b0;
            //jump_imm  <= `ZeroDWord;
            stallreq_from_ex <= 1'b0;
            whilo_o <= 1'b0;
            hi_o <= `ZeroWord;
            lo_o <= `ZeroWord;
            //pc_out  <= `ZeroDWord;
            end else begin
            case (aluop_i)
                `EXE_I_OR: begin
                    logicout  <= reg1_i | reg2_i;
                end
                `EXE_I_ORI: begin
                    logicout  <= reg1_i | imm;
                end
                `EXE_I_ADD : begin
                    logicout  <= reg1_i + reg2_i;
				end
                `EXE_I_ADDI : begin
                    if( imm[11] == 1'b1)begin
                        logicout  <= reg1_i + {52'hfffffffffffff, imm[11:0]};
                    end
                    else
                    begin
                        logicout  <= reg1_i + imm;
                    end
                end
                `EXE_I_AND : begin
                    logicout  <= reg1_i & reg2_i;
                end
                `EXE_I_ANDI : begin
                    logicout  <= reg1_i & imm;
                end
                `EXE_I_XOR : begin
                    logicout  <= reg1_i ^ reg2_i;
                end
                `EXE_I_XORI : begin
                    logicout  <= reg1_i ^ imm;
                end
                `EXE_I_SLT : begin //should be wrong, I change later
                    if (reg1_i < reg2_i)begin
                        logicout  <= 64'd1;
                    end else begin
                        logicout  <= 64'd0;
                    end
                end
                `EXE_I_SLTU : begin
                    if (reg1_i != reg2_i) begin
                        logicout  <= 64'd1;
                    end else begin
                        logicout  <= 64'd0;
                    end
                end
                `EXE_I_SLTIU : begin
                    if (reg1_i == reg2_i) begin
                        logicout  <= 64'd1;
                    end else begin
                        logicout  <= 64'd0;
                    end
                end
                `EXE_I_SUB : begin
                    logicout  <= reg1_i - reg2_i;
                end
                `EXE_I_LUI : begin //maybe wrong
                    logicout  <= reg1_i;
                end
                `EXE_I_SB : begin // seem okay but not yet test
                    logicout  <= reg1_i + reg2_i;
                    if (logicout > `byte_limit) begin
                        logicout  <= `ZeroDWord;
                    end
                end
                `EXE_I_SH : begin // seem okay but not yet test
                    logicout  <= reg1_i + reg2_i;
                    if (logicout > `hword_limit) begin
                        logicout  <= `ZeroDWord;
                    end
                end
                `EXE_I_SW : begin // seem okay but not yet test
                    logicout  <= reg1_i + reg2_i;
                    if (logicout > `word_limit) begin
                        logicout  <= `ZeroDWord;
                    end
                end
               `EXE_I_SD : begin // seem okay but not yet test
                    logicout  <= reg1_i + reg2_i;
                end
                `EXE_I_SLL : begin
                    logicout  <= reg1_i << (reg2_i& 64'h1f);
                    if( logicout > 64'hfff)begin
                        logicout  <= `ZeroDWord;
                    end 
                end
                `EXE_I_SLLW : begin
                    logicout  <= reg1_i << (reg2_i& 64'h1f);
                    if (logicout[31] == 1'b1) begin
                        logicout  <= 64'hffffffffffffffff & (reg1_i << reg2_i);
                    end else begin
                        logicout  <= 64'h00000000ffffffff & (reg1_i << reg2_i);
                    end
                end
                `EXE_I_SRL : begin
                    logicout  <= reg1_i >>> (reg2_i& 64'h1f); 
                     if( logicout > 64'hfff)begin
                        logicout  <= `ZeroDWord;
                    end                   
                end
                `EXE_I_SRLW : begin
                    logicout  <= reg1_i >>> (reg2_i& 64'h1f);
                    if (logicout[31] == 1'b1) begin
                        logicout  <= 64'hffffffffffffffff & (reg1_i >>> reg2_i);
                    end else begin
                        logicout  <= 64'h00000000ffffffff & (reg1_i >>> reg2_i);
                    end
                end
                `EXE_I_SRA : begin
                    logicout  <= reg1_i >> (reg2_i& 64'h1f);
                     if( logicout > 64'hfff)begin
                        logicout  <= `ZeroDWord;
                    end 
                end
                `EXE_I_SRAW : begin
                    logicout  <= reg1_i >> (reg2_i& 64'h1f);
                    if (logicout[31] == 1'b1) begin
                        logicout  <= 64'hffffffffffffffff & (reg1_i >> reg2_i);
                    end else begin
                        logicout  <= 64'h00000000ffffffff & (reg1_i >> reg2_i);
                    end

                end
               /* `EXE_I_BEQ : begin //very likely will totally fuck up
                    logicout  <= imm;
                    if (reg1_i == reg2_i) begin
                        jump_sign  <= 1'b1;
                    end else begin
                        jump_sign  <= 1'b0;
                    end
                end
                `EXE_I_BNE : begin //very likely will totally fuck up
                    logicout  <= imm;
                    if (reg1_i !== reg2_i) begin
                        jump_sign  <= 1'b1;
                    end else begin
                        jump_sign  <= 1'b0;
                    end
                end
                `EXE_I_BLT : begin //very likely will totally fuck up
                    logicout  <= imm;
                    if (reg1_i < reg2_i) begin
                        jump_sign  <= 1'b1;
                    end else begin
                        jump_sign  <= 1'b0;
                    end
                end
                `EXE_I_BGE : begin //very likely will totally fuck up
                    logicout  <= imm;
                    if (reg1_i >= reg2_i) begin
                        jump_sign  <= 1'b1;
                    end else begin
                        jump_sign  <= 1'b0;
                    end
                end */
                `EXE_I_LOAD : begin
                    logicout  <= reg1_i + reg2_i;
                    re  <= 1'b1;                                                
                end
                `EXE_I_LBU : begin
                    logicout  <= reg1_i + reg2_i;
                    re  <= 1'b1; 
                end
                `EXE_I_LHU : begin
                    logicout  <= reg1_i + reg2_i;
                    re  <= 1'b1; 
                end
                `EXE_I_LWU : begin
                    logicout  <= reg1_i + reg2_i;
                    re  <= 1'b1; 
                end
              /*  `EXE_I_JALR  : begin
                    jump_sign  <= 1'b1;
                    logicout  <= reg1_i + reg2_i;
                end
                `EXE_I_JAL :  begin
                    jump_sign  <= 1'b1;
                    logicout  <= reg2_i;
                end*/
                `EXE_I_AUIPC : begin
                    logicout  <= pc_in + (reg2_i << 64'd12);
                    logicout  <= logicout & 64'hffffffff;
                end
                default: begin
                    logicout  <= `ZeroDWord;
                end
            endcase
        end
    end

    always @(*) begin
        if (rst != `RESET) begin
            readRegValue  <= `ZeroDWord;
            end else if (logicout[4:0] == 0) begin
            readRegValue  <= `ZeroDWord;
            end else if (re == 1) begin
            readRegValue  <= regs[logicout[4:0]];
            end else begin
            readRegValue  <= `ZeroDWord;
        end
    end
   
    always @(*) begin
        wd_o    <= wd_i;
        id_wd_o  <= wd_i;
        wreg_o  <= wreg_i;
        id_wreg_o  <= wreg_i;
        stallreq_from_ex <= 1'b0;
        whilo_o <= 1'b0;
        hi_o <= `ZeroWord;
        lo_o <= `ZeroWord;
        case (aluse_i)
            `EXE_RES_LOGIC: begin
                wdata_o  <= logicout;
                id_wdata_o  <= logicout;
            end
            `EXE_RES_LOAD: begin
                if(aluop_i == `EXE_I_LBU)begin
                    wdata_o  <= readRegValue & 64'hff;
                    id_wdata_o  <= readRegValue & 64'hff;
                end else if(aluop_i == `EXE_I_LHU) begin
                    wdata_o  <= readRegValue & 64'hffff;
                    id_wdata_o  <= readRegValue & 64'hffff;
                end else if(aluop_i == `EXE_I_LWU)begin
                    wdata_o  <= readRegValue & 64'hffffffff;
                    id_wdata_o  <= readRegValue & 64'hffffffff;
                end else begin
                    wdata_o  <= readRegValue;
                    id_wdata_o  <= readRegValue;
                end                
            end
            `EXE_RES_JUMP:begin
                wdata_o  <= link_address_i;
            end
            default: begin
                wdata_o  <= `ZeroDWord;
                id_wdata_o  <= `ZeroDWord;
            end
        endcase
    end

    /*always @(posedge clk) begin
        if (rst == `RESET) begin
            id_wdata_o  <= `ZeroDWord;
        end else begin
            id_wdata_o  <= wdata_o;
        end
    end*/
endmodule
