module multiplier_cell (
    input wire X, Y, Pin, Cin,
    output wire Pout, Cout
);
    
    wire product;
    and(product, X, Y);
    

    full_adder FA (
        .A(product),
        .B(Pin),
        .Cin(Cin),
        .P(Pout),
        .Cout(Cout)
    );



endmodule