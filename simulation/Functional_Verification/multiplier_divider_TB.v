module multiplier_divider_TB;

    localparam  DEVIDENT_LENGTH = 10;
    localparam  DIVISOR_LENGTH  = 5;

    reg [DEVIDENT_LENGTH-1:0]       OperA;
    reg [DIVISOR_LENGTH-1:0]        OperB;
    reg [DIVISOR_LENGTH-1:0]        OperD;
    reg                             Div_nMul;
    wire [DEVIDENT_LENGTH-1:0]      Result;
    wire [DIVISOR_LENGTH-1:0]       Remainder;

    multiplier_divider #(
        .DEVIDENT_LENGTH(DEVIDENT_LENGTH),
        .DIVISOR_LENGTH(DIVISOR_LENGTH)
    ) DUT (
        .OperA(OperA),
        .OperD(OperD),
        .OperB(OperB),
        .Div_nMul(Div_nMul),
        .Result(Result),
        .Remainder(Remainder)
    );
    

    initial begin
        /*Divider Operations*/
        OperA = 1;
        OperB = 0;
        OperD = 1;
        Div_nMul = 1;
        #10;
        OperA = 1;
        OperD = 15;
        #10;
        OperA = 1023;
        OperD = 1;
        #10;
        OperA = 1;
        OperD = 1;
        #10;
        OperA = 21;
        OperD = 7;
        #10;
        OperA = 28;
        OperD = 7;
        #10;
        OperA = 14;
        OperD = 2;
        #10;
        OperA = 12;
        OperD = 3;
        #10;
        OperA = 25;
        OperD = 7;
        #10;
        OperA = 1023;
        OperD = 15;
        #10;
        /*Multiplier Operations*/
        Div_nMul = 0;
        OperB = 0;
        OperD = 0;
        #10;
        OperB = 31;
        OperD = 31;
        #10;
        OperB = 31;
        OperD = 0;
        #10;
        OperB = 0;
        OperD = 31;
        #10;
        OperB = 4;
        OperD = 3;
        #10;
        OperB = 15;
        OperD = 15;
        #10;
        OperB = 12;
        OperD = 15;
        #10;
        OperB = 31;
        OperD = 31;
        #10;
        #10;
        OperB = 16;
        OperD = 16;
        #10;
        OperB = 20;
        OperD = 20;
        #10;
        OperB = 20;
        OperD = 25;
        #10;
        OperB = 31;
        OperD = 0;
        #10;
        OperB = 31;
        OperD = 1;
        #10;
        $finish;
    end
endmodule