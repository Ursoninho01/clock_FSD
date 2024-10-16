module cronometer 
    (
    clock,
    advanceState,
    incrementBtn,
    reset,
    countS,
    dp70,
    dp71,
    dp72,
    dp73,
    debugState,
    dot
    );
// Sinais de Controle
    input clock;           // relógio do sistema (clock)
    input advanceState;    // botão para avançar estado
    input incrementBtn;    // botão para incrementar contador
    input reset;
// Sinais de Dados 
    reg [4:0] countH;    // contador do primeiro digito das horas
    reg [5:0] countM;    // contador do primeiro digito dos minutos
    output reg [5:0] countS;    // contador dos segundos
    output     [6:0] dp70;      // saída para display de 7 segmentos
    output     [6:0] dp71;
    output     [6:0] dp72;
    output     [6:0] dp73;

    wire [3:0] unitsHours;
    wire [3:0] tensHours;
    wire [3:0] unitsMinute;
    wire [3:0] tensMinute;

    output reg [1:0] debugState;   //Verificar em qual estado o relogio esta


    output dot;                    //Ligar o ponto do segd2
    assign dot = 1'b1;

    parameter running = 2'o0;
    parameter adjustMinutes = 2'o1;
    parameter adjustHours = 2'o2;

    reg [1:0] state;
    reg [1:0] nextState;

    always@(posedge clock or posedge reset) begin
        if(!reset) begin
        state <= nextState;
        debugState <= state;

        case (state)
        running: begin
        countS = countS + 1;
        if(countS > 59) begin
            countS <= 6'b0000000;
            countM <= countM + 1;
        end if(countM == 59 && countS == 59) begin
            countS <= 6'b000000;
            countM <= 6'b000000;            
            countH <= countH + 1;
        end if(countH == 23 && countM == 59 && countS == 59) begin
            countH <= 4'b0000;
            countM <= 6'b000000;
            countS  <= 6'b000000;
        end
        if(advanceState) begin
            nextState <= adjustMinutes;
            end
        end

        adjustMinutes: begin
            if(incrementBtn) begin
               countM = countM + 1;
                if(countM > 59) begin
                    countM <= 6'b000000;
                end
            end

            if(advanceState) begin
                nextState <= adjustHours;
            end
        end

        adjustHours: begin
            //nextState <= state;
            if(incrementBtn) begin
                countH = countH + 1;
                if(countH > 23) begin
                    countH <= 5'b00000;
                end
            end

            if(advanceState) begin
                nextState <= running;
            end
        end

        endcase
    end else begin
        countH = 0;
        countM = 0;
        countS = 0;
    end

    end


assign unitsMinute = countM % 10;
assign tensMinute = countM /10;
assign unitsHours = countH % 10;
assign tensHours = countH / 10;
//Display 7seg
    dec7seg min2(
        .A(unitsMinute),
        .Y(dp70));

    dec7seg min1(
        .A(tensMinute),
        .Y(dp71));

    dec7seg h2(
        .A(unitsHours),
        .Y(dp72));

    dec7seg h1(
        .A(tensHours),
        .Y(dp73));
endmodule

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