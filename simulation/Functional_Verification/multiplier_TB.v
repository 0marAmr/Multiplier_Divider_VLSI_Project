module multiplier_TB;

    localparam  OPER2_LENGTH = 3;
    localparam  OPER1_LENGTH  = 3;

    reg [OPER1_LENGTH-1:0]       OperX;
    reg [OPER1_LENGTH-1:0]       OperY;
    wire [2*OPER1_LENGTH-1:0]    Result;

    multiplier #(
        .OPER2_LENGTH(OPER1_LENGTH),
        .OPER1_LENGTH(OPER1_LENGTH)
    ) DUT (
        .OperX(OperX),
        .OperY(OperY),
        .Result(Result)
    );
    

    initial begin
        OperX = 1;
        OperY = 1;
        #10;
        OperX = 2;
        OperY = 5;
        #10;
        OperX = 5;
        OperY = 5;
        #10;
        OperX = 15;
        OperY = 15;
        #10;
        OperX = 10;
        OperY = 10;
        #10;
        $finish;
    end
endmodule