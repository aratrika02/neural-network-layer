# neural-network-layer

## **1. Introduction**
 This project demonstrates the implementation of a layer of a fully connected neural network
 comprising 10 neurons and employs 16 bit quantization. Each neuron is composed of four
 submodules: an SRAMmodule(whichstoresinputs and weights in 16 bit fixed representation), a
 Multiply and Accumulate (MAC)module, a quantization module performing 16 bit quantization and
 a ReLUmodulewhichservesasthe activation function. These submodules are encapsulated within a
 "neuron" module, and 10 such neurons collectively form the top-layer module, emulating a layer of a
 fully connected neural network. The outputs of the neuron are stored in a register should they be
 needed to be connected to a different layer for future work.

 ## **2. Data Description**
 The MAC module of each neuron produces a weighted sum of inputs and then adds a bias value to it.
 The weights and the inputs are in 16 bit fixed point representation where the leftmost bit represents
 the sign of the number, the next 7 bits represent the integer part and the following 8 bits represent the
 fractional part of the number. 
 
 For this format:
 Range=−[127+(255 x 2^−8)] to [127+(255 x 2^-8)]
 Precision of 1/(2^8)=0.00390625
 
 16-bit fixed-point representation provides a good balance between precision and hardware resource
 usage. Fixed-point operations consume significantly fewer hardware resources compared to floating-point operations.Furthermore, they are faster than floating-point operations because they do not require complex floating-point units. However, in pursuit of efficient resource utilization, the
 precision and accuracy take a hit but in the application explored in this project, high accuracy is not
 extremely critical. Therefore, the benefit of efficient resource usage and reduced memory and
 computation cost surpasses the small con of the slight dip in precision.
 Python has been used for the purpose of randomly generating inputs and weights as .mem files. 10
 input files and 10 weight files are generated.

 ## **3. Method Description**
 **Neuron Module**: The goal of the project is to create a layer of a fully connected neural network
 consisting of 10 neurons. Each neuron is composed of four interconnected submodules: SRAM,
 MAC,Quantization and ReLU to implement the different operations performed inside a neuron.
 Details of their design and implementation is mentioned under Model Description. These
 submodules are interconnected within the neuron to facilitate a seamless flow of data from the SRAM
 to the ReLUmodule.


 **Top-level Layer Design**: The layer module consists of 10 neurons, each configured with unique
 biases. The neurons operate in parallel, and their outputs are synchronized. Each neuron’s ReLU
 output represents the final processed value for its respective inputs.


**Dataflow**: Each neuron takes 8 inputs. In a neuron, the inputs and the weights are fetched from the
 input SRAM and weight SRAM respectively and fed into the MAC module. It performs
 multiply-accumulate operation and calculates the weighted sum of inputs and finally adds a bias value
 to it. The 32 bit MAC output is then quantized to 16 bits and fed into the ReLU module which
 outputs the value given to it as input if it is greater than 0, or outputs 0 otherwise. The ReLU output
 represents the final output of a neuron.

 The biases are applied individually to each neuron. The outputs of all 10 neurons are collected in
 parallel and provided as the final outputs of the layer. They are also stored in a 2D register should they
 be needed in the future to facilitate a potential connection to a different layer of the neural network.


**Control Logic**: Each neuron generates a done signal to signify completion of its calculations. The
 layer’s done signal ensures that all neurons have completed their calculations before presenting the
 final outputs.


**Simulation and Testing**: The hardware implementation is done in Verilog. Each submodule is
 designed and tested individually before integration into the neuron module. The final layer is
 constructed by instantiating 10 neuron modules and connecting them to shared control and input
 signals.The use of parameters allows flexibility in testing the submodules with different values by
 simply updating the weight and input files.

 
 Testbenches are developed to simulate and test each of the submodules. Intermediate signals like
 mac_out (output of the MAC module before quantization) and quantized_out (quantized output)
 are used to validate the correct functioning of the MAC and quantization modules during testing.
 GTKWave is used to view waveforms and debug the design.

 ## **4. Description**

Each neuron is composed of the following submodules:


**1. SRAM**: This module is a synchronous implementation of a  static random-access memory (SRAM) that supports read and write operations controlled by specific enable signals (chip select, write enable, output enable). It includes configurable parameters for data width, address width and memory initialization using an external file (INIT_FILE). 
For the purpose of this project, we use DATA_WIDTH=16 and ADDRESS_WIDTH=3 so that ADDRESS_DEPTH=2^3=8, since we store 8 values, each of 16 bits in a SRAM. An 8 word memory of 16 bits is modeled using a 2D register array which operates synchronously with the clock signal.

Write operations occur when the chip is selected (chip_sel = 1) and write enable (write_en = 1) signals are asserted, storing the input data (data_in) at the specified address.

 Read operations occur when chip_sel = 1, write_en = 0, and output enable (out_en = 1) signals are active, retrieving data from the memory at the given address and assigning it to the output (data_out).
 
Two instances of the SRAM module are used: one to store weights and one to store inputs. The .mem files are used to initialize the two SRAMs with the input and weight values.

The inputs SRAM is initialized with the input values from the .mem files because by preloading the SRAM with input values, it becomes easier to validate the neuron module and layer functionality which aids in debugging and comparing results for different inputs. It also reduces the need for dynamic data loading logic during runtime, simplifying the hardware design. This separation allows the computational modules to focus solely on their primary computational tasks without being burdened by input setup overhead. This subsequently  eliminates the need for fetching data dynamically during execution, thus minimizing latency in computation. Furthermore, multiple neurons can fetch their respective data simultaneously, which  enhances parallelism in the layer computation. This design choice has also been made as it enhances modularity and supports reusability.


  
**2. MAC module**: This module implements a Multiply-Accumulate (MAC) unit which computes the weighted sum of inputs with an additional bias term. It performs the following operation:
output= wixi + bias
(where  wi and xi  are the i th weight and input) 

It is implemented in the form of a Finite State Machine, with the states IDLE, CALCULATE and DONE. 
In the IDLE state, the module resets internal variables, including the accumulator (c), index counter (index), and sets the next_state to CALCULATE.
The CALCULATE state performs the core MAC operation, multiplying the weight data (data_out_a) with the input data (data_out_b) to produce a 32-bit product, which is added to the accumulated value (c). The DONE state adds the bias term (bias) to the accumulated result and asserts the completion signal (done).The output of the MAC module is a 32 bit product with an added bias term which is to be quantized.


**3. Quantization module**: This module performs 16 bit quantization of the MAC module’s 32 bit output by employing the arithmetic right shift operator (>>>) to preserve the sign of the input.  By shifting right, some fractional bits of the number are removed, thus scaling the number to fit within the intended 16-bit range.

A saturation logic is employed for overflow and underflow handling. For a 16 bit signed number, maximum possible positive value=2^15 - 1=32767 and minimum possible negative value= -2^15= -32768. The saturation logic checks if the quantized output (intermediate_output)  is within this range. If the intermediate_output exceeds 32767, it is clamped to this maximum possible value. If the intermediate_output is below -32768, it is clamped to this minimum possible value.  The final output of the quantization module is quantized_output.



**4. ReLU (Rectified Linear Unit) module:** This module serves as the activation function and performs the following operation:
f(a)=max(0,a) where a is the input to the module
This module takes a signed 16 bit input (a) and outputs a signed 16-bit value (y) that is either the input itself (if a> 0) or 0 (if a<= 0). This is achieved by using two submodules: a comparator and a 2x1 multiplexer.
The comparator takes 2 inputs, a and b(0). It outputs 1 if a>0, or 0 otherwise. 

The output of the comparator (greater) is connected to the select line of the 2x1 mux which takes 2 inputs: a and b(=0) (same as the comparator). If select signal=1, the mux outputs y=a. If select signal=0, it outputs y=0. This is how ReLU behaviour is achieved in this module using the comparator and mux submodules.


## **5. Experimental Procedure**

There are two testbenches for  checking the functionality of the neural network layer implemented. One is the **neuron_tb** module which is the testbench for the neuron module and the operation of each of the ten neurons can be demonstrated using this testbench. The other is **top_level_neurons_tb** module which is the testbench for the top level layer connecting all the neurons and is used to simulate the functioning of a layer of a neural network layer.
The register outputs have been displayed only to illustrate the neuron outputs have been successfully stored in the 2D register.


**Results:** The done signal is asserted after 9 clock cycles. Let us say it takes 10 clock cycles to generate the ReLU output (to keep some leeway in calculations). Therefore for a 1MHz clock, the number of outputs generated per second = 10^6/10 = 100,000.

Should the number of inputs and weights be increased from 8 to 50, the number of clock cycles required to generate output=10+(50-8)=52. In this case, the number of outputs generated per second = 10^6/52 = 19230
For a neural network layer with say, 10,000 neurons, the processing time required=19230/10,000=1.92 ~ 2 seconds (approximately)



## **6. Conclusion**
In this project, a hardware implementation of a neural network layer of 10 neurons has been designed and validated using Verilog. Its flexibility, scalability, and ease of integration into more extensive neural network architectures is owed to the modular approach taken. Each neuron, comprising SRAM for storage, a MAC unit for weighted summation, a quantization module, and a ReLU activation function, was developed and tested to ensure correct functionality.


 
