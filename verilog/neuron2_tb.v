`include "neuron2.v"

module neuron_tb;
 
    parameter WEIGHTS_FILE = "weights_2.mem"; 
    parameter INPUTS_FILE = "inputs_2.mem"; 

    reg clk;
    reg rstn;
    reg signed [15:0] bias; // Bias input
    wire signed [15:0] relu_out; // ReLU output
    wire signed [15:0] quantized_out; // Quantized output (debug)
    wire signed [31:0] mac_out; // MAC output (debug)
    wire done; // Done signal

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    neuron #(
        .WEIGHTS_FILE(WEIGHTS_FILE),
        .INPUTS_FILE(INPUTS_FILE)
    ) uut (
        .clk(clk),
        .rstn(rstn),
        .bias(bias),
        .relu_out(relu_out),
        .quantized_out(quantized_out),
        .mac_out(mac_out),
        .done(done)
    );

    initial begin
        $dumpfile("neuron_tb.vcd");
        $dumpvars(0, neuron_tb);

        rstn = 0;
        bias = -16'd300; 

        #20;
        rstn = 1; //de-assert reset
        #10;;

        wait(done);
        #20;

        $display("Simulation complete.");
        $display("MAC Output: %d", mac_out);
        $display("Quantized Output: %d", quantized_out);
        $display("ReLU Output: %d", relu_out);


        $finish;
    end

endmodule
