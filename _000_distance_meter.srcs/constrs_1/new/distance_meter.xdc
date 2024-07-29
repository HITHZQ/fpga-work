#clock and reset
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports sys_clk]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports sys_rst_n  ]

#ultrasound
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports echo]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports trig  ]

#beep_out
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports beep_out  ]

#led_out
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports led_out  ]

#nixie
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {nixie_cs[3]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {nixie_cs[2]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {nixie_cs[1]}]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {nixie_cs[0]}]

set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[0]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[1]}]
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[2]}]
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[3]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[4]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[5]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[6]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {nixie_seg[7]}]


