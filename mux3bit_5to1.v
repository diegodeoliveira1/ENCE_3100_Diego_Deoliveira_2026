module mux3bit_5to1 (
    input  [2:0] S,
    input  [2:0] U,
    input  [2:0] V,
    input  [2:0] W,
    input  [2:0] X,
    input  [2:0] Y,
    output [2:0] M
);

    mux5to1 b0 (
	 .u(U[0]), 
	 .v(V[0]), 
	 .w(W[0]), 
	 .x(X[0]), 
	 .y(Y[0]), 
	 .s(S), 
	 .m(M[0])
	 );
	 
    mux5to1 b1 (
	 .u(U[1]), 
	 .v(V[1]), 
	 .w(W[1]), 
	 .x(X[1]), 
	 .y(Y[1]), 
	 .s(S), 
	 .m(M[1])
	 );
	 
    mux5to1 b2 (
	 .u(U[2]), 
	 .v(V[2]), 
	 .w(W[2]), 
	 .x(X[2]), 
	 .y(Y[2]), 
	 .s(S), 
	 .m(M[2])
	 );
	 
endmodule