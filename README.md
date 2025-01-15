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
 
