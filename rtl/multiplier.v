/*Structural Modeling for Multiplier*/
module multiplier #(
    parameter   OPER2_LENGTH = 3,
                OPER1_LENGTH  = 3
)(
    input wire  [OPER1_LENGTH-1:0]   OperX,
    input wire  [OPER2_LENGTH-1:0]  OperY,
    output wire [2*OPER1_LENGTH-1:0] Result
);

    genvar i, j;
    wire [OPER1_LENGTH-1:0] Pi [OPER1_LENGTH-1:0] ;
    wire [OPER1_LENGTH-1:0] Ci [OPER1_LENGTH-1:0] ;
    wire [OPER1_LENGTH-3:0] Wi;
    generate
        for (i = OPER1_LENGTH-1; i >= 0; i = i - 1) begin
            /*first row*/
            if (i == OPER1_LENGTH-1) begin
                for (j = 0; j < OPER1_LENGTH; j = j + 1) begin
                    if(j == 0) begin
                        multiplier_cell U0 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(1'b0),
                            .Cin(1'b0),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                    else begin
                        multiplier_cell U1 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(1'b0),
                            .Cin(Ci[i][j-1]),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
            /*rest of the rows*/
            else begin
                for (j = 0; j < OPER1_LENGTH; j = j + 1) begin
                    if(j == 0) begin
                        multiplier_cell U2 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(1'b0),
                            .Cin(1'b0),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                    else begin
                        multiplier_cell U3 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(Pi[i+1][j-1]),
                            .Cin(Ci[i][j-1]),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                end
            end
        end
    /*Full Adders*/
    for (i = OPER1_LENGTH-2; i >= 0; i = i - 1) begin
        if(i ==  OPER1_LENGTH-2) begin
            full_adder FA1 (
                .A(Pi[i+1][OPER1_LENGTH-1]),
                .B(Ci[i][OPER1_LENGTH-1]),
                .Cin(Wi[i-1]),
                .P(Result[2*OPER1_LENGTH-2]),
                .Cout(Result[2*OPER1_LENGTH-1])
            );
        end
        else begin
            full_adder FA2 ( /*half adder*/
                .A(Pi[i+1][OPER1_LENGTH-1]),
                .B(Ci[i][OPER1_LENGTH-1]),
                .Cin(1'b0),
                .P(Result[OPER1_LENGTH+i]),
                .Cout(Wi[i])
            );           
        end
    end
    /*assign outputs rest of the outputs*/
    for (i = OPER1_LENGTH-1; i >= 0; i = i - 1) begin
       assign  Result[i] = Pi[0][i];
    end
    endgenerate
       
endmodule