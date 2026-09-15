module mux5to1 (
    input  u,
    input  v,
    input  w,
    input  x,
    input  y,
    input  [2:0] s,
    output m
);

    wire uv, wx, uvwx;

    mux2to1 m0 (
	 .x(u),    
	 .y(v), 
	 .s(s[0]), 
	 .m(uv)
	 );
	 
    mux2to1 m1 (
	 .x(w),    
	 .y(x), 
	 .s(s[0]), 
	 .m(wx)
	 );

    mux2to1 m2 (
	 .x(uv),   
	 .y(wx), 
	 .s(s[1]), 
	 .m(uvwx)
	 );

    mux2to1 m3 (
	 .x(uvwx), 
	 .y(y),  
	 .s(s[2]), 
	 .m(m)
	 );

endmodule