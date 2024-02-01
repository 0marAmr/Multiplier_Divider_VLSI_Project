/*Structural Modeling for Multiplier*/
module divider #(
    parameter   DEVIDENT_LENGTH = 6,
                DIVISOR_LENGTH  = 3
)(
    input wire  [DEVIDENT_LENGTH-1:0]  OperA,
    input wire  [DIVISOR_LENGTH-1:0]   OperD,
    output wire [DEVIDENT_LENGTH-1:0] Quotient,
    output wire [DIVISOR_LENGTH-1:0]  Remainder  
);

    genvar i, j;
    wire [DIVISOR_LENGTH-1:0] Ri [DEVIDENT_LENGTH-1:0] ;
    wire [DIVISOR_LENGTH-1:0] Ci [DEVIDENT_LENGTH-1:0] ;
    wire [DIVISOR_LENGTH-1:0]  Wi;
    generate
        for (i = DEVIDENT_LENGTH-1; i >= 0; i = i - 1) begin
            /*first row*/
            if (i == DEVIDENT_LENGTH-1) begin
                for (j = 0; j < DIVISOR_LENGTH; j = j + 1) begin
                    /*Right most cell*/
                    if(j == 0) begin
                        divider_cell U0 (
                            .A(OperA[i]),
                            .D(OperD[0]),
                            .S(1'b1),
                            .Cin(1'b1),
                            .R(Ri[i][0]),
                            .Cout(Ci[i][0])
                        );
                    end
                    /*rest of the cells*/
                    else begin
                        divider_cell U1 (
                            .A(1'b0),
                            .D(OperD[j]),
                            .S(1'b1),
                            .Cin(Ci[i][j-1]),
                            .R(Ri[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            /*rest of the rows*/
            else begin
                for (j = 0; j < DIVISOR_LENGTH; j = j + 1) begin
                    /*Right most cell*/
                    if(j == 0) begin
                        divider_cell U2 (
                            .A(OperA[i]),
                            .D(OperD[0]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i+1][DIVISOR_LENGTH-1]),
                            .R(Ri[i][0]),
                            .Cout(Ci[i][0])
                        );
                    end
                    /*rest of the cells*/
                    else begin
                        divider_cell U3 (
                            .A(Ri[i+1][j-1]),
                            .D(OperD[j]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i][j-1]),
                            .R(Ri[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            /*assign the outputs*/
            assign  Quotient[i] = Ci[i][DIVISOR_LENGTH-1];
        end
        for (i = 0; i < DIVISOR_LENGTH; i = i + 1) begin
           if(i==0) begin
                multiplier_cell MC (
                    .Pin(Ri[0][i]),
                    .X(Ri[0][DIVISOR_LENGTH-1]),
                    .Y(OperD[i]),
                    .Cin(1'b0),
                    .Pout(Remainder[i]),
                    .Cout(Wi[i])
                );
           end
           else begin
                multiplier_cell MC (
                    .Pin(Ri[0][i]),
                    .X(Ri[0][DIVISOR_LENGTH-1]),
                    .Y(OperD[i]),
                    .Cin(Wi[i-1]),
                    .Pout(Remainder[i]),
                    .Cout(Wi[i])
                );
           end
        end
    endgenerate
       
endmodule