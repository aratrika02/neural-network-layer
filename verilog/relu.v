// Comparator module
module comparator (
    input signed [15:0] a, // 16-bit signed input
    input signed [15:0] b, // 16-bit signed input
    output reg greater      // Output indicates if a > b
);

always @(*) begin
    greater = (a > b) ? 1'b1 : 1'b0;
end

endmodule

// 2x1 Multiplexer module
module mux2x1 (
    input signed [15:0] a,  // Input a
    input signed [15:0] b,  // Input b (set to 0 for ReLU)
    input sel,              // Select line
    output reg signed [15:0] y // Output y
);

always @(*) begin
    y = (sel) ? a : b;
end

endmodule

// ReLU module
module relu (
    input signed [15:0] a,   // Input value
    output signed [15:0] y   // Output value
);

// Internal wire to connect comparator and mux
wire greater;

// Instantiating comparator
comparator comp (
    .a(a),
    .b(16'sd0),   // Zero value for comparison
    .greater(greater)
);

// Instantiating 2x1 mux
mux2x1 mux (
    .a(a),
    .b(16'sd0),  // Zero value for mux
    .sel(greater),
    .y(y)
);

endmodule
