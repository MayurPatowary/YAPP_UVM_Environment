/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import yapp_pkg::*;
    import channel_pkg::*;
    import hbus_pkg::*;
    import clock_and_reset_pkg::*;
    import router_module_pkg::*;

    `include "router_mcsequencer.sv"
    `include "router_mcseqs_lib.sv"
    
    `include "router_tb.sv"
    `include "router_test_lib.sv"

    initial begin
        yapp_vif_config::set(null, "uvm_test_top.tb.yapp_uvc.tx_agent.*", "vif", hw_top.in0);
        
        channel_vif_config::set(null, "uvm_test_top.tb.chan0_uvc.*", "vif", hw_top.ch0);
        channel_vif_config::set(null, "uvm_test_top.tb.chan1_uvc.*", "vif", hw_top.ch1);
        channel_vif_config::set(null, "uvm_test_top.tb.chan2_uvc.*", "vif", hw_top.ch2);
        
        hbus_vif_config::set(null, "uvm_test_top.tb.hbus_uvc.*", "vif", hw_top.hb0);

        clock_and_reset_vif_config::set(null, "uvm_test_top.tb.clK_rst_uvc.*", "vif", hw_top.cr0);
        
        run_test("base_test");
    end   

endmodule : tb_top