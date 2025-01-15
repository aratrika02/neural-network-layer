module quantization (
    input signed [31:0] mac_output,  // Input from MAC module
    output reg signed [15:0] quantized_output 
);
    
    // Internal variables
    reg signed [15:0] intermediate_output;

   
    always @(*) begin
        intermediate_output = mac_output >>> 8;

        // saturation logic
        if (intermediate_output > 16'sd32767) begin
            quantized_output = 16'sd32767; // Max positive value for 16-bit
        end else if (intermediate_output < -16'sd32768) begin
            quantized_output = -16'sd32768; // Min negative value for 16-bit
        end else begin
            quantized_output = intermediate_output; 
        end

        /*
        // Debugging
        $display("Quantization Module - Input (32-bit): %d, Quantized Output (16-bit): %d", 
                 mac_output, quantized_output);
        */
    end
endmodule
