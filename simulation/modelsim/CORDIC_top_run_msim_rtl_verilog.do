transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/quartus13.01/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/quartus13.01/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/quartus13.01/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/quartus13.01/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/quartus13.01/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneii_ver
vmap cycloneii_ver ./verilog_libs/cycloneii_ver
vlog -vlog01compat -work cycloneii_ver {c:/quartus13.01/quartus/eda/sim_lib/cycloneii_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/CORDIC_top.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Arith_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Input_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Output_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Show_In_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Seg_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/Decoder_block.v}
vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC {D:/Stduy/Project/Quartus_Proj/CORDIC/LCD_block.v}

vlog -vlog01compat -work work +incdir+D:/Stduy/Project/Quartus_Proj/CORDIC/simulation/modelsim {D:/Stduy/Project/Quartus_Proj/CORDIC/simulation/modelsim/CORDIC_top.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  CORDIC_top_vlg_tst

add wave *
view structure
view signals
run -all
