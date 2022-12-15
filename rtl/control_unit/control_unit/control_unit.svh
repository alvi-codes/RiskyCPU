/* verilator lint_off UNUSED */
module control_unit #(
    parameter DATA_WIDTH = 32
)(
    input   logic   [DATA_WIDTH-1:0]    instr,
    output  logic                       RegWrite,
    output  logic   [1:0]               ResultSrc,
    output  logic                       MemWrite,
    output  logic                       Jump,
    output  logic                       Branch,
    output  logic   [2:0]               ALUctrl,
    output  logic                       ALUsrc,
    output  logic   [1:0]               ImmSrc,
    output  logic                       Jump2
);
    //RegWrite
    always_comb
        casez ({instr[6:0],instr[14:12]})
            {7'b0000011, 3'b???}:   RegWrite = 1'b1;
            {7'b0010011, 3'b???}:   RegWrite = 1'b1;
            {7'b1100111, 3'b000}:   RegWrite = 1'b1;
            {7'b1101111, 3'b???}:   RegWrite = 1'b1;
            default: RegWrite = 1'b0;
        endcase

    //ALUctrl
    always_comb
        case ({instr[6:0],instr[14:12]})
            {7'b0010011, 3'b000}:   ALUctrl = 3'b000;
            {7'b1100111, 3'b000}:   ALUctrl = 3'b000; //jalr
            {7'b0010011, 3'b110}:   ALUctrl = 3'b011; //or
            {7'b0010011, 3'b010}:   ALUctrl = 3'b101; //slt
            {7'b0010011, 3'b111}:   ALUctrl = 3'b010; //and
            {7'b0000011, 3'b010}:   ALUctrl = 3'b000; //lw
            {7'b0100011, 3'b010}:   ALUctrl = 3'b000; //sw
            {7'b1100011, 3'b000}:   ALUctrl = 3'b000; //branch =
            {7'b1100011, 3'b001}:   ALUctrl = 3'b001; //branch !=
            {7'b1100011, 3'b100}:   ALUctrl = 3'b010; //branch <
            {7'b1100011, 3'b101}:   ALUctrl = 3'b011; //branch >=
            {7'b1100011, 3'b110}:   ALUctrl = 3'b010; //branch <
            {7'b1100011, 3'b111}:   ALUctrl = 3'b011; //branch >=
            default: ALUctrl = 3'b111;
        endcase

    //ALUsrc
    always_comb
        casez ({instr[6:0],instr[14:12]})
            {7'b0010011, 3'b???}:   ALUsrc = 1'b1;
            {7'b0000011, 3'b???}:   ALUsrc = 1'b1;
            {7'b1100111, 3'b000}:   ALUsrc = 1'b1;
            default: ALUsrc = 1'b0;
        endcase

    //ImmSrc
    always_comb
        case ({instr[6:0]})
            {7'b0000011}:   ImmSrc = 2'b00;
            {7'b0010011}:   ImmSrc = 2'b00;
            {7'b1100011}:   ImmSrc = 2'b10;
            {7'b1101111}:   ImmSrc = 2'b11;
            default:        ImmSrc = 2'b00;
        endcase

    //Branch
    always_comb
        case ({instr[6:0]})
            {7'b1100011}:   Branch = 1'b1;
            default         Branch = 1'b0;
        endcase
    
    //Jump
    always_comb
        case ({instr[6:0]})
            {7'b1101111}:   Jump = 1'b1;
            default         Jump = 1'b0;
        endcase

    //Jump2
    always_comb
        case ({instr[6:0],instr[14:12]})
            {7'b1100111, 3'b000}:   Jump2 = 1'b1;
            default:                Jump2 = 1'b0;
        endcase

    //MEMWrite
    always_comb
        case ({instr[6:0],instr[14:12]})
            {7'b0100011, 3'b010}:   MemWrite = 1'b1;
            default:                MemWrite = 1'b0;
        endcase

    //ResultSrc
    always_comb 
        casez ({instr[6:0],instr[14:12]})
            {7'b0000011, 3'b010}:   ResultSrc = 2'b01;
            {7'b1101111, 3'b???}:   ResultSrc = 2'b10;
            default:                ResultSrc = 2'b00;
        endcase

            

 
endmodule