###################################################################

# Created by write_sdc on Sun Dec 19 13:26:23 2021

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_max_area 0
create_clock -name clk  -period 5.0e+07  -waveform {0 2.5e+07}
set_input_delay -clock clk  0  [get_ports {inp[7]}]
set_input_delay -clock clk  0  [get_ports {inp[6]}]
set_input_delay -clock clk  0  [get_ports {inp[5]}]
set_input_delay -clock clk  0  [get_ports {inp[4]}]
set_input_delay -clock clk  0  [get_ports {inp[3]}]
set_input_delay -clock clk  0  [get_ports {inp[2]}]
set_input_delay -clock clk  0  [get_ports {inp[1]}]
set_input_delay -clock clk  0  [get_ports {inp[0]}]
set_output_delay -clock clk  0  [get_ports out]
