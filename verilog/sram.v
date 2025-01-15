module sram (
    clk,        //clock
    address,    //address lines
    chip_sel,   //chip select
    write_en,   //for read/write operationsqaz
    out_en,     //output enable
    data_in,
    data_out
);

//defining parameters (sizes of data lines and address lines)
parameter DATA_WIDTH=16;
parameter ADDRESS_WIDTH=3;
parameter INIT_FILE = "";
parameter RAM_DEPTH=1<<ADDRESS_WIDTH; //2^ADDRESS_WIDTH -> 2^3=8



input clk;
input [ADDRESS_WIDTH-1:0] address;
input chip_sel;
input write_en;
input out_en;
input signed [DATA_WIDTH-1:0] data_in;

output reg signed [DATA_WIDTH-1:0] data_out;



//internal variables
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];  
    
initial begin
    if (INIT_FILE != "") begin
            $readmemb(INIT_FILE, mem);
    end
end


//write logic
//chip_sel=1, write_en=1
always @(posedge clk) begin
    if(chip_sel && write_en) begin
        mem[address]=data_in; 
        data_out=data_in;
    end
end

//read logic
//chip_sel=1,out_en=1,write_en=0
always @(posedge clk) begin
    if (chip_sel && !write_en && out_en ) begin
        data_out=mem[address];
    end

end

endmodule 