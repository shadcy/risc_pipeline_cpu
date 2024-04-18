transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Academics/Sem 4/project/project/control.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/stage6.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/re_reg.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/mw_reg.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/em.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/dr_reg.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/pipedatapath.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/zeroextender.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/stage5.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/stage3.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/stage2.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/DUT.vhdl}
vcom -93 -work work {D:/Academics/Sem 4/project/project/se9_16.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/se7_16.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/regfile.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/read_mem.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/datamem.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/comparator.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/alu.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/first_stage.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/fd_reg.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/stage_4.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/chooser4.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/double.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/increment2.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/forwarder.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/pickone.vhd}
vcom -93 -work work {D:/Academics/Sem 4/project/project/branch.vhd}

vcom -93 -work work {D:/Academics/Sem 4/project/project/clock_divider_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  clock_divider_tb

add wave *
view structure
view signals
run -all
