module counter2b(clk, rst, set, cen, blk, cnt, dp7);
// Sinais de Controle
    input       clk;        // relógio do sistema (clock)
    input       rst;        // ajusta contador de 2 bits para zero (b00)
    input       set;        // ajusta contador de 2 bits para três (b11)
    input       cen;        // captura de dados (clock enable)   
    output      blk;        // saída de relógio (blink)
 
// Sinais de Dados 
    output reg [1:0] cnt;   // contador de 2 bits
    output     [6:0] dp7;   // saída para display de 7 segmentos
 
// Descrição da arquitetura
    assign blk = clk;       // redireciona entrada clk para a saída blk
    // Bloco de controle do contador de 2 bits
    always@(posedge clk) begin
        if(rst)
            cnt <= 2'b00;   // ajusta todos os bits do contador para '0'
        else if(set)
            cnt <= 2'b11;   // ajusta todos os bits do contador para '1'
        else if (!cen)
            cnt <= cnt+1;   // incrementa contador cnt em um
    end
	// Instancia decodificar de 2 bits para display de 7 segmentos
    dec7seg HNB2DP7(
        .A(cnt),
        .Y(dp7));
endmodule:counter2b

module dec7seg(
    input [3:0]A,    // Entrada A
    output reg [6:0]Y    // Saída
);
    always @(*) begin
        case (A)
            4'h0: begin
                Y <= 7'b1111110;
            end
            4'h1: begin
                Y <= 7'b0110000;
            end
            4'h2: begin
                Y <= 7'b1101101;
            end
            4'h3: begin
                Y <= 7'b1111001;
            end
            4'h4: begin
                Y <= 7'b0110011;
            end
            4'h5: begin
                Y <= 7'b1011011;
            end
            4'h6: begin
                Y <= 7'b1011111;
            end
            4'h7: begin
                Y <= 7'b1110000;
            end
            4'h8: begin
                Y <= 7'b1111111;
            end
            4'h9: begin
                Y <= 7'b1111011;
            end
            4'hA: begin
                Y <= 7'b1110111;
            end
            4'hB: begin
                Y <= 7'b0011111;
            end
            4'hC: begin
                Y <= 7'b1001110;
            end
            4'hD: begin
                Y <= 7'b0111101;
            end
            4'hE: begin
                Y <= 7'b1001111;
            end
            4'hF: begin
                Y <= 7'b1000111;
            end
        endcase
    end
endmodule