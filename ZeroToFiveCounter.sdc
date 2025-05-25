# Hızlı başlangıç için:
set_input_delay -clock [get_clocks clk] -max 5 [get_pins *]
set_output_delay -clock [get_clocks clk] -max 5 [get_pins *]

# Daha spesifik yaklaşım:
# create_clock -name clk -period 10 [get_ports clk]
# set_input_delay 2 -clock clk [get_ports rst]
# set_output_delay 2 -clock clk [get_ports count[*]]
