module divider_cell (
    input wire A, D, S, Cin,
    output wire R, Cout
);
    
    wire XOR_OP;
    xor(XOR_OP,S, D);
    full_adder FA (
        .A(A),
        .B(XOR_OP),
        .Cin(Cin),
        .P(R),
        .Cout(Cout)
    );



endmodule