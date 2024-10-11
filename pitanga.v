module exemplo (clk, rst, count);
    input clk, rst;
    output[2:0]count;
        reg sinal;
        always@(posedge clr or posedge rst)begin
            if(rst == 1'b1)begin
                count <= 3'h0; sinal <= 0;
            end else begin
                count <= count + 1'b1;
                if(count == 3'd5)begin
                    sinal <= 1'b1;
                end else begin
                    sinal <= 1'b0;
                end

            end
        end
endmodule