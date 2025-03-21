class router_simple_mcseq extends uvm_sequence;

    `uvm_object_utils(router_simple_mcseq)

    function new (string name = "router_simple_mcseq");
        super.new(name);
    endfunction : new

    `uvm_declare_p_sequencer(router_mcsequencer)

    hbus_small_packet_seq       h_small;
    hbus_read_max_pkt_seq       h_read;
    yapp_012_seq                y_012;
    hbus_set_default_regs_seq   h_large;
    yapp_6_packets              y_6p;
    
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body

    task body();
        `uvm_info(get_type_name(), "Executing router_simple_mcseq sequence", UVM_LOW)
        
        // Set the router to accept small packets (payload length < 21) and enable it
        `uvm_do_on(h_small, p_sequencer.hbus_seqr); 

        // Read the router MAXPKTSIZE register to make sure it has been correctly set
        `uvm_do_on(h_read, p_sequencer.hbus_seqr); 
        `uvm_info(get_type_name(), $sformatf("Router max packet size register read (in decimal): %0d", h_read.max_pkt_reg), UVM_LOW)

        // Send six consecutive YAPP packets to addresses 0, 1, 2
        repeat(2)
            `uvm_do_on(y_012, p_sequencer.yapp_seqr);
        
        // Set the router to accept large packets (payload length < 64)
        `uvm_do_on(h_large, p_sequencer.hbus_seqr);

         // Read the router MAXPKTSIZE register to make sure it has been correctly set
        `uvm_do_on(h_read, p_sequencer.hbus_seqr);
        `uvm_info(get_type_name(), $sformatf("Router max packet size register read (in decimal): %0d", h_read.max_pkt_reg), UVM_LOW)
        
        // Send a random sequence of six YAPP packets
        `uvm_do_on(y_6p, p_sequencer.yapp_seqr);

        // Here, the HBUS and YAPP transactions are serial (first hbus, then yapp, then hbus...). If we want them concurrent, use fork-join.
    endtask

endclass : router_simple_mcseq
