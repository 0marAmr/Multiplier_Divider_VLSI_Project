module cell1 (
    input wire A, B, D, S, Cin, Div_nMul,
    output wire R, Cout
);
        
    wire product, XOR_OP, MUX_OP;
    and(product, D, B);
    xor(XOR_OP, S, D);

    assign MUX_OP = Div_nMul? XOR_OP : product;

    full_adder FA (
        .A(A),
        .B(MUX_OP),
        .Cin(Cin),
        .P(R),
        .Cout(Cout)
    );



endmodule