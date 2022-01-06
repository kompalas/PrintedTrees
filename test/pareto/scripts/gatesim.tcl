set vcdfile $::env(ENV_VCDFILE)
set tb $::env(ENV_TB_NAME)
set dut $::env(ENV_DUT_NAME)

vcd file -compress ${vcdfile}
vcd add -r /${tb}/${dut}/*
vcd on
run -all
rm -rf simv*
quit

