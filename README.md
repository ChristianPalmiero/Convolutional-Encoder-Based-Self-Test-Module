# Convolutional-Encoder-Based-Self-Test-Module
A self-test module with an infotainment core (Convolutional encoder) able to perform a selfcheck of its operation at the power-up of the system.

# Presentation
Detailed presentation [here](SSDS_Presentation.pdf).

# Internal components<br \>
Infotainment ECU: the main control unit of the entire infotainment digital system self-test module.<br \>
Test RAM: the RAM memory block storing the results of the test.<br \>
Golden ROM: the ROM memory block storing the input patterns and the expected “golden” (i.e., right) results.<br \>
Infotainment Core: the Xilinx Convolutional Encoder v8.0.<br \>

![Top entity](/Top_entity.png)
