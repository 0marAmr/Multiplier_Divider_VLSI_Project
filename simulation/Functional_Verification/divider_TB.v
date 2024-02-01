module divider_TB;

    localparam  DEVIDENT_LENGTH = 10;
    localparam  DIVISOR_LENGTH  = 5;

    reg [DEVIDENT_LENGTH-1:0]       OperA;
    reg [DIVISOR_LENGTH-1:0]        OperD;
    wire [DEVIDENT_LENGTH-1:0]    Quotient;
    wire [DIVISOR_LENGTH-1:0] Remainder;

    divider #(
        .DEVIDENT_LENGTH(DEVIDENT_LENGTH),
        .DIVISOR_LENGTH(DIVISOR_LENGTH)
    ) DUT (
        .OperA(OperA),
        .OperD(OperD),
        .Quotient(Quotient),
        .Remainder(Remainder)
    );
    

    initial begin
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
        $finish;
    end
endmodule