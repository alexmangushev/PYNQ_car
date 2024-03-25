## Clock signal
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports CLK_50]
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 5} [get_ports CLK_50]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets design_top_i/dvi2rgb_0/U0/TMDS_ClockingX/CLK_IN_hdmi_clk]

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports LED_1]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports LED_2]
#set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports LED_3]

set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports KEY_1]


set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports UARTl_0_rxd]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports UARTl_0_txd]


#set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports KEY_2]
#set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports KEY_3]
#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports KEY_4]
#set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports KEY_5]

#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports GPIO[0]]
#set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports GPIO[1]]
#set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports GPIO[2]]
#set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports GPIO[3]]
#set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports GPIO[4]]
#set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports GPIO[5]]
#set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports GPIO[6]]
#set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports GPIO[7]]
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports GPIO[8]]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports GPIO[9]]
#set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports GPIO[10]]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports GPIO[11]]

# HDMI Signals

# 720p
create_clock -period 13.468 -waveform {0.000 5.000} [get_ports hdmi_in_clk_p]
#1080p
#create_clock -period 6.734 -waveform {0.000 3.000} [get_ports hdmi_in_clk_p]

set_property -dict {PACKAGE_PIN F20 IOSTANDARD TMDS_33} [get_ports hdmi_in_clk_n]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD TMDS_33} [get_ports hdmi_in_clk_p]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[0]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[1]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[1]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[2]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[2]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {hdmi_in_hpd[0]}];
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports hdmi_in_ddc_scl_io];
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports hdmi_in_ddc_sda_io];



#create_clock -period 13.468 -waveform {0.000 5.000} [get_ports hdmi_in_clk_p]
#set_property -dict {PACKAGE_PIN F20 IOSTANDARD TMDS_33} [get_ports hdmi_in_clk_n]
#set_property -dict {PACKAGE_PIN F19 IOSTANDARD TMDS_33} [get_ports hdmi_in_clk_p]
#set_property -dict {PACKAGE_PIN D20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[0]}]
#set_property -dict {PACKAGE_PIN D19 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[0]}]
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[1]}]
#set_property -dict {PACKAGE_PIN C20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[1]}]
#set_property -dict {PACKAGE_PIN A20 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_n[2]}]
#set_property -dict {PACKAGE_PIN B19 IOSTANDARD TMDS_33} [get_ports {hdmi_in_data_p[2]}]
#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {hdmi_in_hpd}]
#set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports ddc_iic_scl_io]
#set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports ddc_iic_sda_io]

##
## @file        ebaz4205.xdc
## @brief       Xilinx Design Constraints for EBAZ4205
## @author      Keitetsu
## @date        2021/03/21
## @copyright   Copyright (c) 2021 Keitetsu
## @par         License
##              This software is released under the MIT License.
##

# Clock for Ethernet Transceiver
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports FCLK_CLK3_0]

# Ethernet Transceiver
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_RX_CLK_0]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_TX_CLK_0]

set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[3]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[2]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[1]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[0]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {ENET0_GMII_TX_EN_0[0]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[3]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[2]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[1]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[0]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_RX_DV_0]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports MDIO_ETHERNET_0_0_mdc]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports MDIO_ETHERNET_0_0_mdio_io]
