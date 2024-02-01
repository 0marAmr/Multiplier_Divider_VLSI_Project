/*Structural Modeling for Multiplier*/
module multiplier_divider #(
    parameter   DEVIDENT_LENGTH = 6,
                DIVISOR_LENGTH  = 3
)(
    input wire  [DEVIDENT_LENGTH-1:0]  OperA,
    input wire  [DIVISOR_LENGTH-1:0]   OperB,
    input wire  [DIVISOR_LENGTH-1:0]   OperD,
    input wire                         Div_nMul,
    output wire [DEVIDENT_LENGTH-1:0]  Result,
    output wire [DIVISOR_LENGTH-1:0]   Remainder
);

    genvar i, j;
    wire [DIVISOR_LENGTH-1:0] Ri [DEVIDENT_LENGTH-1:0]; /*Result of array Cells (Generic Cell1 & Cell2)*/
    wire [DIVISOR_LENGTH-1:0] Ci [DEVIDENT_LENGTH-1:0]; /*Carry out of array Cells (Generic Cell1 & Cell2)*/
    wire [DEVIDENT_LENGTH-1:0]  Quotient;               /*quotient result of the divider*/
    wire [DEVIDENT_LENGTH-1:0]  Mul_result;             /*Output result of the multiplier*/
    wire [DIVISOR_LENGTH-1:0]  Wi;                      /*Carry out for Cell1 used to calculate Remainder (Divider)*/
    wire [DEVIDENT_LENGTH-3:DIVISOR_LENGTH]  Mi;        /*Carry out for Full Adders (Multiplier) */
    generate
        for (i = DEVIDENT_LENGTH-1; i >= 0; i = i - 1) begin /*Array Generation Loop*/
            /*first row*/
            if (i == DEVIDENT_LENGTH-1) begin
                for (j = 0; j < DIVISOR_LENGTH; j = j + 1) begin
                    /*Right most cell*/
                    if(j == 0) begin
                        cell2 U0 (
                            .A(OperA[i]),
                            .B(OperB[i-DIVISOR_LENGTH]),
                            .D(OperD[0]),
                            .S(1'b1),
                            .Cin(Div_nMul),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][0]),
                            .Cout(Ci[i][0])
                        );
                    end
                    /*rest of the cells*/
                    else begin
                        cell1 U1 (
                            .A(1'b0),
                            .B(OperB[i-DIVISOR_LENGTH]),
                            .D(OperD[j]),
                            .S(1'b1),
                            .Cin(Ci[i][j-1]),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            /*rest of the rows*/
            else if (i >= DEVIDENT_LENGTH - DIVISOR_LENGTH) begin
                for (j = 0; j < DIVISOR_LENGTH; j = j + 1) begin
                    /*Right most cell*/
                    if(j == 0) begin
                        cell2 U2 (
                            .A(OperA[i]),
                            .B(OperB[i-DIVISOR_LENGTH]),
                            .D(OperD[0]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][0]),
                            .Cout(Ci[i][0])
                        );
                    end
                    /*rest of the cells*/
                    else begin
                        cell1 U3 (
                            .A(Ri[i+1][j-1]),
                            .B(OperB[i-DIVISOR_LENGTH]),
                            .D(OperD[j]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i][j-1]),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            else begin
                for (j = 0; j < DIVISOR_LENGTH; j = j + 1) begin
                    /*Right most cell*/
                    if(j == 0) begin
                        cell2 U2 (
                            .A(OperA[i]),
                            .B(1'b0),
                            .D(OperD[0]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][0]),
                            .Cout(Ci[i][0])
                        );
                    end
                    /*rest of the cells*/
                    else begin
                        cell1 U3 (
                            .A(Ri[i+1][j-1]),
                            .B(1'b0),
                            .D(OperD[j]),
                            .S(Ci[i+1][DIVISOR_LENGTH-1]),
                            .Cin(Ci[i][j-1]),
                            .Div_nMul(Div_nMul),
                            .R(Ri[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            /*assign the Quotient output*/
            assign  Quotient[i] = Ci[i][DIVISOR_LENGTH-1];
        end /*End of Array Generation Loop*/

        /*Full Adders*/
        for (i = DEVIDENT_LENGTH -2; i >= DIVISOR_LENGTH; i = i - 1) begin
            if(i ==  DEVIDENT_LENGTH-2) begin
                full_adder FA1 (
                    .A(Ri[i+1][DIVISOR_LENGTH-1]),
                    .B(Ci[i][DIVISOR_LENGTH-1]),
                    .Cin(Mi[i-1]),
                    .P(Mul_result[DEVIDENT_LENGTH-2]),
                    .Cout(Mul_result[DEVIDENT_LENGTH-1])
                );
            end
            else begin
                full_adder FA2 ( /*half adder*/
                    .A(Ri[i+1][DIVISOR_LENGTH-1]),
                    .B(Ci[i][DIVISOR_LENGTH-1]),
                    .Cin(Mi[i-1]),
                    .P(Mul_result[i]),
                    .Cout(Mi[i])
                );           
            end
        end

        /*assign outputs rest of the outputs*/
        for (i = DIVISOR_LENGTH; i > 0; i = i - 1) begin
           assign  Mul_result[i-1] = Ri[i][DIVISOR_LENGTH-1];
        end
        for (i = DEVIDENT_LENGTH-1; i >= 0; i = i - 1) begin
           assign  Result[i] = Div_nMul ? Quotient[i] : Mul_result[i];
        end
        /*remainder calculation*/ /*By: Reem Mohamed <3 <3*/
        for (i = 0; i < DIVISOR_LENGTH; i = i + 1) begin
           /*M*/
           if(i==0) begin
                cell3 MC1 ( 
                    .Pin(Ri[0][i]),
                    .X(Ri[0][DIVISOR_LENGTH-1]),
                    .Y(OperD[i]),
                    .Cin(1'b0),
                    .Pout(Remainder[i]),
                    .Cout(Wi[i])
                );
           end
           else begin
                cell3 MC2 (
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
