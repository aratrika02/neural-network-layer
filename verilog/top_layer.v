`include "neuron2.v"

module top_level_neurons (
    input clk,
    input rstn,
    input signed [15:0] bias1, bias2, bias3, bias4, bias5, bias6, bias7, bias8, bias9, bias10,
    output signed [15:0] relu_out1, relu_out2, relu_out3, relu_out4, relu_out5,
                         relu_out6, relu_out7, relu_out8, relu_out9, relu_out10,
    output done
);

    // Array to store outputs of neurons
    reg signed [15:0] neuron_outputs [0:9]; // Array to store the 10 outputs

    // Internal signals for each neuron
    wire signed [15:0] quantized_out1, quantized_out2, quantized_out3, quantized_out4, quantized_out5, quantized_out6, quantized_out7, quantized_out8, quantized_out9, quantized_out10;
    //wire signed [15:0] quantized_out6, quantized_out7, quantized_out8, quantized_out9, quantized_out10;
    wire signed [31:0] mac_out1, mac_out2, mac_out3, mac_out4, mac_out5, mac_out6, mac_out7, mac_out8, mac_out9, mac_out10;
    //wire signed [31:0] mac_out6, mac_out7, mac_out8, mac_out9, mac_out10;
    wire done1, done2, done3, done4, done5, done6, done7, done8, done9, done10;

    // Instantiate 10 neurons
    neuron #(
        .WEIGHTS_FILE("weights_0.mem"),
        .INPUTS_FILE("inputs_0.mem")
    ) neuron1 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias1),
        .relu_out(relu_out1),
        .quantized_out(quantized_out1),
        .mac_out(mac_out1),
        .done(done1)
    );

    neuron #(
        .WEIGHTS_FILE("weights_1.mem"),
        .INPUTS_FILE("inputs_1.mem")
    ) neuron2 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias2),
        .relu_out(relu_out2),
        .quantized_out(quantized_out2),
        .mac_out(mac_out2),
        .done(done2)
    );

    neuron #(
        .WEIGHTS_FILE("weights_2.mem"),
        .INPUTS_FILE("inputs_2.mem")
    ) neuron3 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias3),
        .relu_out(relu_out3),
        .quantized_out(quantized_out3),
        .mac_out(mac_out3),
        .done(done3)
    );

    neuron #(
        .WEIGHTS_FILE("weights_3.mem"),
        .INPUTS_FILE("inputs_3.mem")
    ) neuron4 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias4),
        .relu_out(relu_out4),
        .quantized_out(quantized_out4),
        .mac_out(mac_out4),
        .done(done4)
    );

    neuron #(
        .WEIGHTS_FILE("weights_4.mem"),
        .INPUTS_FILE("inputs_4.mem")
    ) neuron5 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias5),
        .relu_out(relu_out5),
        .quantized_out(quantized_out5),
        .mac_out(mac_out5),
        .done(done5)
    );

    neuron #(
        .WEIGHTS_FILE("weights_5.mem"),
        .INPUTS_FILE("inputs_5.mem")
    ) neuron6 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias6),
        .relu_out(relu_out6),
        .quantized_out(quantized_out6),
        .mac_out(mac_out6),
        .done(done6)
    );

    neuron #(
        .WEIGHTS_FILE("weights_6.mem"),
        .INPUTS_FILE("inputs_6.mem")
    ) neuron7 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias7),
        .relu_out(relu_out7),
        .quantized_out(quantized_out7),
        .mac_out(mac_out7),
        .done(done7)
    );

    neuron #(
        .WEIGHTS_FILE("weights_7.mem"),
        .INPUTS_FILE("inputs_7.mem")
    ) neuron8 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias8),
        .relu_out(relu_out8),
        .quantized_out(quantized_out8),
        .mac_out(mac_out8),
        .done(done8)
    );

    neuron #(
        .WEIGHTS_FILE("weights_8.mem"),
        .INPUTS_FILE("inputs_8.mem")
    ) neuron9 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias9),
        .relu_out(relu_out9),
        .quantized_out(quantized_out9),
        .mac_out(mac_out9),
        .done(done9)
    );

    neuron #(
        .WEIGHTS_FILE("weights_9.mem"),
        .INPUTS_FILE("inputs_9.mem")
    ) neuron10 (
        .clk(clk),
        .rstn(rstn),
        .bias(bias10),
        .relu_out(relu_out10),
        .quantized_out(quantized_out10),
        .mac_out(mac_out10),
        .done(done10)
    );

    // Combine done signals to indicate when all neurons are finished
    assign done = done1 & done2 & done3 & done4 & done5 & done6 & done7 & done8 & done9 & done10;


integer i; // Declare `i` outside the always block

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset all outputs to 0
        for (i = 0; i < 10; i = i + 1) begin
            neuron_outputs[i] = 16'sd0;
        end
    end else if (done) begin
        // Update outputs with current relu values
        neuron_outputs[0] = relu_out1;
        neuron_outputs[1] = relu_out2;
        neuron_outputs[2] = relu_out3;
        neuron_outputs[3] = relu_out4;
        neuron_outputs[4] = relu_out5;
        neuron_outputs[5] = relu_out6;
        neuron_outputs[6] = relu_out7;
        neuron_outputs[7] = relu_out8;
        neuron_outputs[8] = relu_out9;
        neuron_outputs[9] = relu_out10;

        // Print debug information
        $display ("------------register outputs--------------");
        for (i = 0; i < 10; i = i + 1) begin
            $display("neuron_outputs[%0d]: %d", i, neuron_outputs[i]);
        end
    end
end


endmodule
