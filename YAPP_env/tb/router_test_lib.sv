class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    router_tb tb;

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In Base Test Build Phase", UVM_HIGH);
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "recording_detail", 1);
        tb = router_tb::type_id::create("tb", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask : run_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction : check_phase

endclass : base_test

class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In Short Packet Test Build Phase", UVM_HIGH);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_5_packets::get_type()); // tells the sequencer of the YAPP UVC to run "yapp_5_packets" sequence
        super.build_phase(phase);
    endfunction : build_phase


endclass : short_packet_test

class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In Set Config Test Build Phase", UVM_HIGH);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_int::set(this, "tb.yapp_uvc.tx_agent", "is_active", UVM_PASSIVE);
        super.build_phase(phase);
    endfunction : build_phase

endclass : set_config_test

class incr_payload_test extends base_test;

    `uvm_component_utils(incr_payload_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In incr_payload_test Build Phase", UVM_HIGH);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_incr_payload_seq::get_type());
        super.build_phase(phase);
    endfunction : build_phase

endclass : incr_payload_test

class exhaustive_seq_test extends base_test;

    `uvm_component_utils(exhaustive_seq_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In exhaustive_seq_test Build Phase", UVM_HIGH);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_exhaustive_seq::get_type());
        super.build_phase(phase);
    endfunction : build_phase

endclass : exhaustive_seq_test

class yapp_012_seq_test extends base_test;

    `uvm_component_utils(yapp_012_seq_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In yapp_012_seq_test Build Phase", UVM_HIGH);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());
        super.build_phase(phase);
    endfunction : build_phase

endclass : yapp_012_seq_test

class simple_test extends base_test;

    `uvm_component_utils(simple_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In simple_test Build Phase", UVM_HIGH);

        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan?_uvc.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clK_rst_uvc.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
        
        super.build_phase(phase);
    endfunction : build_phase

endclass : simple_test

class test_uvc_integration extends base_test;

    `uvm_component_utils(test_uvc_integration)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In test_uvc_integration Build Phase", UVM_HIGH);

        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        uvm_config_wrapper::set(this, "tb.yapp_uvc.tx_agent.sequencer.run_phase", "default_sequence", yapp_4_channels_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan?_uvc.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clK_rst_uvc.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.hbus_uvc.masters[0].sequencer.run_phase", "default_sequence", hbus_small_packet_seq::get_type());
        
        super.build_phase(phase);
    endfunction : build_phase

endclass : test_uvc_integration

class test_lab08_mc extends base_test;

    `uvm_component_utils(test_lab08_mc)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In test_lab08_mc Build Phase", UVM_HIGH);

        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        uvm_config_wrapper::set(this, "tb.chan?_uvc.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clK_rst_uvc.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.mc_seqr.run_phase", "default_sequence", router_simple_mcseq::get_type());
        
        super.build_phase(phase);
    endfunction : build_phase

endclass : test_lab08_mc

class test_final extends base_test;

    `uvm_component_utils(test_final)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "In test_final Build Phase", UVM_HIGH);

        // set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        uvm_config_wrapper::set(this, "tb.chan?_uvc.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clK_rst_uvc.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.mc_seqr.run_phase", "default_sequence", router_simple_mcseq::get_type());
        
        super.build_phase(phase);
    endfunction : build_phase

endclass : test_final