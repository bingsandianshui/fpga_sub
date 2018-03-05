transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {ADC_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+E:/Document/quartus\ 2/LTC1746_FST3253_T04_NEW_EP4CE6E_02/prj/../testbench {E:/Document/quartus 2/LTC1746_FST3253_T04_NEW_EP4CE6E_02/prj/../testbench/LTC1744_T01_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  LTC1744_T01_tb

add wave *
view structure
view signals
run -all
