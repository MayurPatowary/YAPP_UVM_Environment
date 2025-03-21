// UVM library
-uvmhome $UVMHOME 

-timescale 1ns/1ns

// Test run options
+UVM_VERBOSITY=UVM_HIGH
+UVM_TESTNAME=test_final
// +SVSEED=random

// Include directories
-incdir ../yapp/sv
-incdir ../channel/sv
-incdir ../hbus/sv
-incdir ../clock_and_reset/sv
-incdir ../router_module/sv


// Compile files
../yapp/sv/yapp_pkg.sv
../yapp/sv/yapp_if.sv

../channel/sv/channel_pkg.sv
../channel/sv/channel_if.sv

../hbus/sv/hbus_pkg.sv
../hbus/sv/hbus_if.sv

../clock_and_reset/sv/clock_and_reset_pkg.sv
../clock_and_reset/sv/clock_and_reset_if.sv

../router_module/sv/router_module_pkg.sv

../../router_rtl/yapp_router.sv

clkgen.sv
hw_top.sv
tb_top.sv