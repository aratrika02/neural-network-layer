module mac_compute (
    input clk,
    input rstn,
    input signed [15:0] bias,       //bias value
    input signed [15:0] data_out_a, // Weight data from SRAM
    input signed [15:0] data_out_b, // Input data from  SRAM
    output reg signed [31:0] c,     // Accumulated output
    output reg done                 // Completion signal
);

// Internal variables
reg [2:0] index;                // Address index
reg signed [31:0] product;      // Product of weight and input
reg [1:0] state, next_state;    

    
parameter [1:0] 
    IDLE       = 2'b00, 
    CALCULATE  = 2'b01, 
    DONE       = 2'b10;

    
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state <= IDLE;
        c <= 32'b0;
        done <= 1'b0;
        index <= 3'b0;
    end else begin
         state <= next_state;
        end
    end


    // next state and output logic
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                c = 32'd0;         
                index = 3'b0;      
                next_state = CALCULATE;
            end

            CALCULATE: begin
                product = data_out_a * data_out_b;  
                c = c + product;                   
                $display("Index: %d, Weight: %d, Input: %d, Product: %d, c: %d", 
                         index, data_out_a, data_out_b, product, c);

                if (index < 7) begin
                    index = index + 1; 
                end else begin
                    next_state = DONE; 
                end
            end

            DONE: begin
                c=c+bias;
                done = 1'b1;         // Indicates completion
                next_state = DONE;   
            end
        endcase
    end

endmodule
