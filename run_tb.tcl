set tb_files [glob -directory "tb" -- "*.vhd"]

foreach f $tb_files {
	set tb_name [string trimleft [string trimright $f ".vhd"] "tb/"]
	
	set fp [open tb_out/$tb_name.txt w]

	vcom -2008 -work work $f
	vsim work.$tb_name -wlf waves/$tb_name.wlf

	add wave /$tb_name/*
	run -all
	puts $fp "NAME: $tb_name"
	puts $fp "[coverage report -assert -detail]"
	quit -sim

	close $fp

	wlf2vcd -o waves/$tb_name.vcd waves/$tb_name.wlf
}

exit -force