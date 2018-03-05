transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/spi_master.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/timer.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/find_start.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/LTC1744_T01_TOP.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/LTC1744_T01.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/pll_200.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/rtl/led_control.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/ip {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/ip/dpram.v}
vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/db {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/db/pll_200_altpll.v}

vlog -vlog01compat -work work +incdir+E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/../testbench {E:/zhengchunhou/LTC1746_FST3253_T04_NEW_EP4CE6E_05/prj/../testbench/LTC1744_T01_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  LTC1744_T01_tb

add wave *
view structure
view signals
run -all
