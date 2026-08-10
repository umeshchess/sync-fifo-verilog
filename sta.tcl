# sta.tcl
# 1. Load the physical gate timing delays
read_liberty NangateOpenCellLibrary_typical.lib

# 2. Load the synthesized gate-level netlist (from Yosys)
read_verilog fifo_synth.v

# 3. Link the design
link_design fifo_sync

# 4. Load the timing constraints (100 MHz clock)
read_sdc fifo.sdc

# 5. Check Setup Time (Max Delay) - Ensures data isn't too slow
puts "\n===================================================="
puts "                SETUP TIMING REPORT                   "
puts "===================================================="
report_checks -path_delay max -format full

# 6. Check Hold Time (Min Delay) - Ensures data isn't too fast
puts "\n===================================================="
puts "                HOLD TIMING REPORT                    "
puts "===================================================="
report_checks -path_delay min -format full