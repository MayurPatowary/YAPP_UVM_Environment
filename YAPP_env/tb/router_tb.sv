class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    yapp_env yapp_uvc;
    channel_env chan0_uvc, chan1_uvc, chan2_uvc;
    hbus_env hbus_uvc;
    clock_and_reset_env clK_rst_uvc;
    router_mcsequencer mc_seqr;
    router_module_env router_module_uvc;

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In Testbench Build Phase", UVM_HIGH)
        super.build_phase(phase);

        // YAPP UVC
        yapp_uvc = yapp_env::type_id::create("yapp_uvc", this);
        
        // Channel UVCs
        uvm_config_int::set(this, "chan0_uvc", "channel_id", 0);
        uvm_config_int::set(this, "chan1_uvc", "channel_id", 1);
        uvm_config_int::set(this, "chan2_uvc", "channel_id", 2);
        chan0_uvc = channel_env::type_id::create("chan0_uvc", this);
        chan1_uvc = channel_env::type_id::create("chan1_uvc", this);
        chan2_uvc = channel_env::type_id::create("chan2_uvc", this);

        // HBUS UVC
        uvm_config_int::set(this, "hbus_uvc", "num_masters", 1);
        uvm_config_int::set(this, "hbus_uvc", "num_slaves", 0);
        hbus_uvc = hbus_env::type_id::create("hbus_uvc", this);

        // Clock and Reset UVC
        clK_rst_uvc = clock_and_reset_env::type_id::create("clK_rst_uvc", this);

        // Multichannel sequencer
        mc_seqr = router_mcsequencer::type_id::create("mc_seqr", this);

        // Router module UVC
        router_module_uvc = router_module_env::type_id::create("router_module_uvc", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);

        // Connections in mutlichannel sequencer
        mc_seqr.hbus_seqr = hbus_uvc.masters[0].sequencer;
        mc_seqr.yapp_seqr = yapp_uvc.tx_agent.sequencer;

        // Connect YAPP and HBUS UVC monitors to Reference Model of the Router Module UVC
        yapp_uvc.tx_agent.monitor.yapp_out_port.connect(router_module_uvc.router_ref.yapp_in_imp);
        hbus_uvc.masters[0].monitor.item_collected_port.connect(router_module_uvc.router_ref.hbus_in_imp);

        // Connect Channel UVC monitors to Scoreboard of the Router Module UVC
        chan0_uvc.rx_agent.monitor.item_collected_port.connect(router_module_uvc.router_sb.ch0_in_imp);
        chan1_uvc.rx_agent.monitor.item_collected_port.connect(router_module_uvc.router_sb.ch1_in_imp);
        chan2_uvc.rx_agent.monitor.item_collected_port.connect(router_module_uvc.router_sb.ch2_in_imp);

    endfunction : connect_phase

endclass : router_tb