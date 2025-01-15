`include "top_layer.v"

module top_level_neurons_tb;

    reg clk;
    reg rstn;
    reg signed [15:0] bias1, bias2, bias3, bias4, bias5, bias6, bias7, bias8, bias9, bias10;
    wire signed [15:0] relu_out1, relu_out2, relu_out3, relu_out4, relu_out5, relu_out6, relu_out7, relu_out8, relu_out9, relu_out10;
    wire done;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    top_level_neurons uut (
        .clk(clk),
        .rstn(rstn),
        .bias1(bias1),
        .bias2(bias2),
        .bias3(bias3),
        .bias4(bias4),
        .bias5(bias5),
        .bias6(bias6),
        .bias7(bias7),
        .bias8(bias8),
        .bias9(bias9),
        .bias10(bias10),
        .relu_out1(relu_out1),
        .relu_out2(relu_out2),
        .relu_out3(relu_out3),
        .relu_out4(relu_out4),
        .relu_out5(relu_out5),
        .relu_out6(relu_out6),
        .relu_out7(relu_out7),
        .relu_out8(relu_out8),
        .relu_out9(relu_out9),
        .relu_out10(relu_out10),
        .done(done)
    );

    initial begin
        $dumpfile("top_layer_tb.vcd");
        $dumpvars(0, top_level_neurons_tb);

        rstn = 0;

        // Initializing biases
        bias1 = 16'd5;
        bias2 = 16'd100;
        bias3 = -16'd300;
        bias4 = 16'd800;
        bias5 = 16'd7;
        bias6 = 16'd450;
        bias7 = -16'd270;
        bias8 = 16'd0;
        bias9 = 16'd100;
        bias10 = -16'd60;

        
        #10 rstn = 1;
        #10;

        wait(done);
        #10;

        $display("Simulation complete.");
        $display("Neuron 1 ReLU Output: %d", relu_out1);
        $display("Neuron 2 ReLU Output: %d", relu_out2);
        $display("Neuron 3 ReLU Output: %d", relu_out3);
        $display("Neuron 4 ReLU Output: %d", relu_out4);
        $display("Neuron 5 ReLU Output: %d", relu_out5);
        $display("Neuron 6 ReLU Output: %d", relu_out6);
        $display("Neuron 7 ReLU Output: %d", relu_out7);
        $display("Neuron 8 ReLU Output: %d", relu_out8);
        $display("Neuron 9 ReLU Output: %d", relu_out9);
        $display("Neuron 10 ReLU Output: %d", relu_out10);

        #20;
        $finish;
    end

endmodule
