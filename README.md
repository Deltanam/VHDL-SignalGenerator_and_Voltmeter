# VHDL-SignalGenerator_and_Voltmeter
This is the VHDL Code for the DE10-Lite FPGA Board. The DE10-Lite uses the Intel Altera MAX 10 FPGA.

When the board pins are connected to a voltage divider and low-pass filter (consisting of a resistor and capacitor of choice), an oscilloscope will be able to display a clean set of waveforms.
These waveforms may be chosen by selecting a bunch of switches. They waveforms are: sawtooth, square, and triangular waves.

Through the use of buttons, the frequency and amplitude of each of these waves may be increased or decreased.

A buzzer can also be attached to the FPGA, and sound produced from it. It is linked to the square-wave module, and a change in the square wave's modulation will change the buzzer frequency.

Completed as the 4th practical lab for ENEL 453 - Digital Systems Design
