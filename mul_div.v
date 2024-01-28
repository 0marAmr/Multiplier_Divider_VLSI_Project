/*Structural Modeling for Multiplier/ Divider*/
module mul_div #(
    parameter   DEVIDENT_LENGTH = 3,
                DIVISOR_LENGTH  = 3
)(
    input wire  [DIVISOR_LENGTH-1:0]   OperX,
    input wire  [DEVIDENT_LENGTH-1:0]  OperY,
    output wire [2*DIVISOR_LENGTH-1:0] Result
);

    genvar i, j;
    wire [DIVISOR_LENGTH-1:0] Pi [DIVISOR_LENGTH-1:0] ;
    wire [DIVISOR_LENGTH-1:0] Ci [DIVISOR_LENGTH-1:0] ;
    generate
         
        for (i = DIVISOR_LENGTH-1; i >= 0; i = i - 1) begin
            /*first row*/
            if (i == DIVISOR_LENGTH-1) begin
                for (j = DIVISOR_LENGTH-1; j >= 0; j = j - 1) begin
                    logic_cell U0 (
                        .X(OperX[j]),
                        .Y(OperY[i]),
                        .Pin(1'b0),
                        .Cin(1'b0),
                        .Pout(Pi[i][j]),
                        .Cout(Ci[i][j])
                    );
                end
            end
            /*intermediate rows*/
            else begin
                for (j = DIVISOR_LENGTH-1; j >= 0; j = j - 1) begin
                    if(j == 0) begin
                        logic_cell U1 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(1'b0),
                            .Cin(Ci[i+1][j]),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end
                    else begin
                        logic_cell U2 (
                            .X(OperX[j]),
                            .Y(OperY[i]),
                            .Pin(Pi[i+1][j-1]),
                            .Cin(Ci[i+1][j]),
                            .Pout(Pi[i][j]),
                            .Cout(Ci[i][j])
                        );
                    end  
                end
            end
        assign Result[DIVISOR_LENGTH+i-1] = Pi[i][DIVISOR_LENGTH-1];           
        end
    endgenerate
    // assign Result[DIVISOR_LENGTH-1:0] = {Pi[0][DIVISOR_LENGTH-2:1], Ci[0][0], Pi[0][0]};
    assign Result[2*DIVISOR_LENGTH-1] = Ci[DIVISOR_LENGTH-1][DIVISOR_LENGTH-1];
    assign Result[DIVISOR_LENGTH-2:0] = Pi[0][DIVISOR_LENGTH-2:0];
       
endmodule