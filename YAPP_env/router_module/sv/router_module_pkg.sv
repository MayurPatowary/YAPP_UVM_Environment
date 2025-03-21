package router_module_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import yapp_pkg::*; // for visibility of yapp packet
    import channel_pkg::*; // for visibility of channel packet
    import hbus_pkg::*; // for visibility of hbus packet

    `include "router_reference.sv"
    `include "router_scoreboard.sv"
    `include "router_module_env.sv"

endpackage : router_module_pkg