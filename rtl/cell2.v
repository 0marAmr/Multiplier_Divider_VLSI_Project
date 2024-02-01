module cell2 (
    input wire A, B, D, S, Cin, Div_nMul,
    output wire R, Cout
);
        
    wire product, XOR_OP, MUX_OP, IP_GAITNG, Cin_GATING;
    and(product, D, B);
    and(IP_GAITNG, A, Div_nMul);
    and(Cin_GATING, Cin, Div_nMul);
    xor(XOR_OP, S, D);

    assign MUX_OP = Div_nMul? XOR_OP : product;

    full_adder FA (
        .A(IP_GAITNG),
        .B(MUX_OP),
        .Cin(Cin_GATING),
        .P(R),
        .Cout(Cout)
    );



endmodule