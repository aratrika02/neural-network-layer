`include "sram.v"
`include "mac.v" 
`include "quantization.v"
`include "relu.v"

module neuron #(
    parameter WEIGHTS_FILE = "weights_0.mem", // Default weights file
    parameter INPUTS_FILE = "inputs_0.mem"   // Default inputs file
) (
    input clk,
    input rstn,
    input signed [15:0] bias, // Bias for the neuron
    output signed [15:0] relu_out, // Final output
    output signed [15:0] quantized_out, // Debug: Quantized output
    output signed [31:0] mac_out, // Debug: MAC output
    output done // Done signal indicating completion
);

    // Internal signals
    wire signed [15:0] weight_out, input_out; 
    wire mac_done; 

    // Weights SRAM 
    sram #(
        .DATA_WIDTH(16),
        .ADDRESS_WIDTH(3),
        .INIT_FILE(WEIGHTS_FILE)
    ) weights_sram (
        .clk(clk),
        .address(mac_unit.index),
        .chip_sel(1'b1),
        .write_en(1'b0),
        .out_en(1'b1),
        .data_in(16'b0),
        .data_out(weight_out)
    );

    //Inputs SRAM 
    sram #(
        .DATA_WIDTH(16),
        .ADDRESS_WIDTH(3),
        .INIT_FILE(INPUTS_FILE)
    ) inputs_sram (
        .clk(clk),
        .address(mac_unit.index),
        .chip_sel(1'b1),
        .write_en(1'b0),
        .out_en(1'b1),
        .data_in(16'b0),
        .data_out(input_out)
    );

    // MAC module
    mac_compute mac_unit (
        .clk(clk),
        .rstn(rstn),
        .bias(bias),
        .data_out_a(weight_out),
        .data_out_b(input_out),
        .c(mac_out),
        .done(mac_done)
    );

    // Quantization module
    quantization quantizer (
        .mac_output(mac_out),
        .quantized_output(quantized_out)
    );

    // ReLU module
    relu relu_unit (
        .a(quantized_out),
        .y(relu_out)
    );

    assign done = mac_done;

endmodule
