module char_7seg (
    input  [2:0] SW,      
    output [6:0] HEX0     
);

    wire c2 = SW[2];
    wire c1 = SW[1];
    wire c0 = SW[0];

    assign HEX0[0] = c2 | ~c0;           
    assign HEX0[1] = c2 | (c1 ^ c0);     
    assign HEX0[2] = c2 | (c1 ^ c0);     
    assign HEX0[3] = c2 | (~c1 & ~c0);   
    assign HEX0[4] = c2;                 
    assign HEX0[5] = c2;                 
    assign HEX0[6] = c2 | c1;            

endmodule