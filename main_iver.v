module cronometer 
    (
    input clock,           // relógio do sistema (clock)
    input advanceState,    // botão para avançar estado
    input incrementBtn,    // botão para incrementar contador
    output reg [5:0] countS,    // contador dos segundos
    output     [6:0] dp70,      // saída para display de 7 segmentos
    output     [6:0] dp71,
    output     [6:0] dp72,
    output     [6:0] dp73,
    output reg [3:0] m1,  
    output reg [3:0] m2,
    output reg [3:0] ho1,
    output reg [3:0] ho2,
    output reg [1:0] debugState,   //Verificar em qual estado o relogio esta
    output dot,                  //Ligar o ponto do segd2
    input reset
    );
// Sinais de Controle
    

// Sinais de Dados 
    reg [3:0] countH1;    // contador do primeiro digito das horas
    reg [3:0] countH2;    // contador do segundo digito das horas
    reg [3:0] countM1;    // contador do primeiro digito dos minutos
    reg [3:0] countM2;    // contador do segundo digito dos minutos

    
    assign dot = 1'b1;

    parameter running = 2'o0;
    parameter adjustMinutes = 2'o1;
    parameter adjustHours = 2'o2;

    reg [1:0] state;
    reg [1:0] nextState;

    always@(posedge clock) begin
        
        if(!reset) begin
        state <= nextState;
        debugState <= state;

        case (state)
        running: begin
        //nextState <= state;
        countS = countS + 1;
        if(countS > 59) begin
            countS <= 6'b000000;
            countM2 <= countM2 + 1;
        end if(countM2 > 9) begin
            countM2 <= 4'b0000;
            countM1 <= countM1 + 1;
        end if(countM1 > 5) begin
            countM1 <= 4'b0000;
            countM2 <= 4'b0000;            
            countH2 <= countH2 + 1;
        end if(countH1 > 1 && countH2 > 3) begin
            countH1 <= 4'b0000;
            countH2 <= 4'b0000;
            countM1 <= 4'b0000;
            countH2 <= 4'b0000;
            countS  <= 6'b000000;
        end if(countH2 > 9) begin
            countH2 <= 4'b0000;
            countH1 <= countH1 + 1;
        end

        if(advanceState) begin
            nextState <= adjustMinutes;
            end
        end

        adjustMinutes: begin
            //nextState <= state;
            if(incrementBtn) begin
               countM2 = countM2 + 1;
               if(countM2 > 9) begin
                   countM2 <= 4'b0000;
                   countM1 <= countM1 + 1;
               end if(countM1 > 5) begin
                    countM2 <= 4'b0000;
                    countM1 <= 4'b0000;
               end
            end

            if(advanceState) begin
                nextState <= adjustHours;
            end
        end

        adjustHours: begin
            //nextState <= state;
            if(incrementBtn) begin
                countH2 = countH2 + 1;
                if(countH2 > 9) begin
                    countH2 <= 4'b0000;
                    countH1 <= countH1 + 1;
                end if(countH1 > 1 && countH2 > 3) begin
                    countH1 <= 4'b0000;
                    countH2 <= 4'b0000;
                end
            end

            if(advanceState) begin
                nextState <= running;
            end
        end 
        endcase
        m1 <= countM1;
        m2 <= countM2;
        ho1 <= countH1;
        ho2 <= countH2;
        end else begin
            countH1 = 0;
            countH2 = 0;
            countM1 = 0;
            countM2 = 0;
            countS = 0;
        end
    end

//Display 7seg
    dec7seg min2(
        .A(countM2),
        .Y(dp70));

    dec7seg min1(
        .A(countM1),
        .Y(dp71));

    dec7seg h2(
        .A(countH2),
        .Y(dp72));

    dec7seg h1(
        .A(countH1),
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