# Create library
vlib work

# Compile Package
vlog -sv +incdir+../ENV +incdir+../TEST ../TEST/ethernet_mac_test_pkg.sv

# Compile Interfaces
vlog -sv ../TOP/mac_interface.sv
vlog -sv ../TOP/wishbone_master_interface.sv
vlog -sv ../TOP/wishbone_slave_interface.sv
vlog -sv ../TOP/phy_tx_interface.sv
vlog -sv ../TOP/phy_rx_interface.sv
vlog -sv ../TOP/miim_interface.sv

# Compile Top
vlog -sv +incdir+../ENV +incdir+../TEST ../TOP/top.sv

# Run Simulation
vsim -c -do "run -all; quit" top

