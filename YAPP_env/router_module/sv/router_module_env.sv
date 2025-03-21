class router_module_env extends uvm_env;

    router_reference router_ref;
    router_scoreboard router_sb;

    `uvm_component_utils(router_module_env)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        router_ref = router_reference::type_id::create("router_ref", this);
        router_sb = router_scoreboard::type_id::create("router_sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        router_ref.val_yapp_out_port.connect(router_sb.yapp_in_imp);
    endfunction
    
endclass : router_module_env