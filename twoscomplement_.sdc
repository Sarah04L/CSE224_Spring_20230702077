set_units -time ns

create_clock -name fake_clock -period 10 [get_ports in[0]]
