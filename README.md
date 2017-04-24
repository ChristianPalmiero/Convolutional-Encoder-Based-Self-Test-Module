# Convolutional-Encoder-Based-Self-Test-Module
A self-test module with an infotainment core (Convolutional encoder) able to perform a selfcheck of its operation at the power-up of the system.

# Presentation
Detailed transparencies [here](SSDS_Presentation.pdf).

# Internal components
Infotainment ECU: the main control unit of the entire infotainment digital system self-test module.
Test RAM: the RAM memory block storing the results of the test.
Golden ROM: the ROM memory block storing the input patterns and the expected “golden” (i.e., right) results.
Infotainment Core: the Xilinx Convolutional Encoder v8.0.

![Top entity](/Top_entity.png)
