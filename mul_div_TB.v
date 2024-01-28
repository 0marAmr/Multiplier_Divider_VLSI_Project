module mul_div_TB;

    localparam  DEVIDENT_LENGTH = 5;
    localparam  DIVISOR_LENGTH  = 5;

    reg [DEVIDENT_LENGTH-1:0]       OperX;
    reg [DIVISOR_LENGTH-1:0]        OperY;
    wire [2*DEVIDENT_LENGTH-1:0]    Result;

    mul_div #(
        .DEVIDENT_LENGTH(DEVIDENT_LENGTH),
        .DIVISOR_LENGTH(DIVISOR_LENGTH)
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
        $finish;
    end
endmodule