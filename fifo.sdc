# fifo.sdc
# Define a 100 MHz clock (2.5 ns period)
create_clock -name clk -period 2.5 [get_ports clk]

# Assume inputs arrive 2ns after the clock edge
set_input_delay 0.5 -clock clk [all_inputs]

# Assume outputs must be stable 2ns before the next clock edge
set_output_delay 0.5 -clock clk [all_outputs]