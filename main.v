// module main(
	// Pinout assignment
	// input [9:0] SW,
	// output [9:0] LEDR
//);

   // Part I
	// assign LEDR[9:0] = SW[9:0];
	
	// Part II
	// assign LEDR[0] = (~SW[9] & SW[0]) | (SW[9] & SW[4]);
   // assign LEDR[1] = (~SW[9] & SW[1]) | (SW[9] & SW[5]);
   // assign LEDR[2] = (~SW[9] & SW[2]) | (SW[9] & SW[6]);
   // assign LEDR[3] = (~SW[9] & SW[3]) | (SW[9] & SW[7]);
	
//endmodule

// Part III
//module main(
    //input  [9:0] SW,     
    //output [9:0] LEDR
//);

    //assign LEDR[9:1] = SW[9:1];

    //mux5to1 bit0 (
        //.u(SW[0]),
        //.v(SW[1]),
        //.w(SW[2]),
        //.x(SW[3]),
        //.y(SW[4]),
        //.s(SW[9:7]),
        //.m(LEDR[0])
    //);

//endmodule

// Part IV
//module main (
    //input  [2:0] SW,   
    //output [6:0] HEX0     
//);

    //wire c2 = SW[2];
    //wire c1 = SW[1];
    //wire c0 = SW[0];

    //assign HEX0[0] = c2 | ~c0;           
    //assign HEX0[1] = c2 | (c1 ^ c0);    
    //assign HEX0[2] = c2 | (c1 ^ c0);    
    //assign HEX0[3] = c2 | (~c1 & ~c0);   
    //assign HEX0[4] = c2;                 
    //assign HEX0[5] = c2;                 
    //assign HEX0[6] = c2 | c1;            

//endmodule

//module main (
    //input  [9:0] SW,    
    //output [6:0] HEX0,    
    //output [6:0] HEX1,   
    //output [6:0] HEX2,   
    //output [6:0] HEX3,    
    //output [6:0] HEX4   
//);

    //wire [2:0] U = 3'b000; // 'H'
    //wire [2:0] V = 3'b001; // 'E'
    //wire [2:0] W = 3'b010; // 'L'
    //wire [2:0] X = 3'b010; // 'L'
    //wire [2:0] Y = 3'b011; // 'O'

    //wire [2:0] S = SW[9:7];
    //wire [2:0] M4, M3, M2, M1, M0;

    //mux3bit_5to1 m4 (S, U, V, W, X, Y, M4); 
    //mux3bit_5to1 m3 (S, V, W, X, Y, U, M3); 
    //mux3bit_5to1 m2 (S, W, X, Y, U, V, M2); 
    //mux3bit_5to1 m1 (S, X, Y, U, V, W, M1); 
    //mux3bit_5to1 m0 (S, Y, U, V, W, X, M0); 

    //char_7seg d4 (
	 //.SW(M4), 
	 //.HEX0(HEX4)
	 //);
	 
    //char_7seg d3 (
	 //.SW(M3), 
	 //.HEX0(HEX3)
	 //);
	 
    //char_7seg d2 (
	 //.SW(M2), 
	 //.HEX0(HEX2)
	 //);
	 
    //char_7seg d1 (
	 //.SW(M1), 
	 //.HEX0(HEX1)
	 //);
	 
    //char_7seg d0 (
	 //.SW(M0), 
	 //.HEX0(HEX0)
	 //);
	 
//endmodule

module main (
    input  [9:0] SW,     
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);

    wire [2:0] H = 3'b000;
    wire [2:0] E = 3'b001;
    wire [2:0] L = 3'b010;
    wire [2:0] O = 3'b011;
    wire [2:0] B = 3'b100; 

    wire [2:0] C0 = O;
    wire [2:0] C1 = L;
    wire [2:0] C2 = L;
    wire [2:0] C3 = E;
    wire [2:0] C4 = H;
    wire [2:0] C5 = B;
    wire [2:0] C6 = B;
    wire [2:0] C7 = B;

    wire [2:0] S = SW[9:7];
    wire [2:0] M5, M4, M3, M2, M1, M0;

    mux3bit_8to1 m5 (S, C5, C4, C3, C2, C1, C0, C7, C6, M5);
    mux3bit_8to1 m4 (S, C4, C3, C2, C1, C0, C7, C6, C5, M4);
    mux3bit_8to1 m3 (S, C3, C2, C1, C0, C7, C6, C5, C4, M3);
    mux3bit_8to1 m2 (S, C2, C1, C0, C7, C6, C5, C4, C3, M2);
    mux3bit_8to1 m1 (S, C1, C0, C7, C6, C5, C4, C3, C2, M1);
    mux3bit_8to1 m0 (S, C0, C7, C6, C5, C4, C3, C2, C1, M0);
	 
    char_7seg d5 (.SW(M5), .HEX0(HEX5));
    char_7seg d4 (.SW(M4), .HEX0(HEX4));
    char_7seg d3 (.SW(M3), .HEX0(HEX3));
    char_7seg d2 (.SW(M2), .HEX0(HEX2));
    char_7seg d1 (.SW(M1), .HEX0(HEX1));
    char_7seg d0 (.SW(M0), .HEX0(HEX0));

endmodule