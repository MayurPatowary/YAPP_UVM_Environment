class router_scoreboard extends uvm_scoreboard;

    `uvm_analysis_imp_decl(_val_yapp)
    `uvm_analysis_imp_decl(_ch0)
    `uvm_analysis_imp_decl(_ch1)
    `uvm_analysis_imp_decl(_ch2)
    
    uvm_analysis_imp_val_yapp #(yapp_packet, router_scoreboard) yapp_in_imp;
    uvm_analysis_imp_ch0 #(channel_packet, router_scoreboard) ch0_in_imp;
    uvm_analysis_imp_ch1 #(channel_packet, router_scoreboard) ch1_in_imp;
    uvm_analysis_imp_ch2 #(channel_packet, router_scoreboard) ch2_in_imp;

    yapp_packet q0[$];
    yapp_packet q1[$];
    yapp_packet q2[$];

    int yapp_packets_in, yapp_packets_dropped_addr;
    int ch0_packets_in, ch0_packets_unmatch, ch0_packets_match, ch0_packets_dropped;
    int ch1_packets_in, ch1_packets_unmatch, ch1_packets_match, ch1_packets_dropped;
    int ch2_packets_in, ch2_packets_unmatch, ch2_packets_match, ch2_packets_dropped;

    `uvm_component_utils(router_scoreboard)

    function new (string name, uvm_component parent);
        super.new(name, parent);
        yapp_in_imp = new("yapp_in_imp", this);
        ch0_in_imp = new("ch0_in_imp", this);
        ch1_in_imp = new("ch1_in_imp", this);
        ch2_in_imp = new("ch2_in_imp", this);
    endfunction

    function void write_val_yapp(input yapp_packet pkt);
        yapp_packet pkt_clone;
        yapp_packets_in++;
        $cast(pkt_clone, pkt.clone());
        case(pkt_clone.addr)
            0 : begin
                q0.push_back(pkt_clone);
                `uvm_info(get_type_name(), "Pushed YAPP packet to Queue 0", UVM_HIGH)
                end
            1 : begin
                q1.push_back(pkt_clone);
                `uvm_info(get_type_name(), "Pushed YAPP packet to Queue 1", UVM_HIGH)
                end
            2 : begin
                q2.push_back(pkt_clone);
                `uvm_info(get_type_name(), "Pushed YAPP packet to Queue 2", UVM_HIGH)
                end
            default : begin
                      `uvm_info(get_type_name(), $sformatf("Packet dropped (invalid address): \n%s", pkt_clone.sprint()), UVM_HIGH)
                      yapp_packets_dropped_addr++;
                      end
        endcase
    endfunction

    function void write_ch0(input channel_packet ch_pkt);
        yapp_packet y_pkt;
        ch0_packets_in++;

        if (q0.size() == 0) begin
            `uvm_error("Scoreboard Error", $sformatf("Received unexpected channel 0 packet: \n%s", ch_pkt.sprint()))
            ch0_packets_dropped++;
            return;
        end

        y_pkt = q0.pop_front();

        if (comp_equal(y_pkt, ch_pkt)) begin
            `uvm_info("Scoreboard PKT_COMPARE Match", $sformatf("Scoreboard compare match for channel 0 packet: \n%s", ch_pkt.sprint()), UVM_LOW)
            ch0_packets_match++;
        end
        else begin
            `uvm_info("Scoreboard PKT_COMPARE Unmatch", $sformatf("Scoreboard compare unmatch for channel 0 packet:\n%s\nExpected channel 0 packet:\n%s", ch_pkt.sprint(), y_pkt.sprint()), UVM_LOW)
            ch0_packets_unmatch++;
        end
    endfunction

    function void write_ch1(input channel_packet ch_pkt);
        yapp_packet y_pkt;
        ch1_packets_in++;
        
        if (q1.size() == 0) begin
            `uvm_error("Scoreboard Error", $sformatf("Received unexpected channel 1 packet: \n%s", ch_pkt.sprint()))
            ch1_packets_dropped++;
        end
        
        y_pkt = q1.pop_front();

        if (comp_equal(y_pkt, ch_pkt)) begin
            `uvm_info("Scoreboard PKT_COMPARE Match", $sformatf("Scoreboard compare match for channel 1 packet: \n%s", ch_pkt.sprint()), UVM_LOW)
            ch1_packets_match++;
        end
        else begin
            `uvm_info("Scoreboard PKT_COMPARE Unmatch", $sformatf("Scoreboard compare unmatch for channel 1 packet:\n%s\nExpected channel 1 packet:\n%s", ch_pkt.sprint(), y_pkt.sprint()), UVM_LOW)
            ch1_packets_unmatch++;
        end
    endfunction

    function void write_ch2(input channel_packet ch_pkt);
        yapp_packet y_pkt; 
        ch2_packets_in++;
        
        if (q2.size() == 0) begin
            `uvm_error("Scoreboard Error", $sformatf("Received unexpected channel 2 packet: \n%s", ch_pkt.sprint()))
            ch2_packets_dropped++;
        end
        
        y_pkt = q2.pop_front();

        if (comp_equal(y_pkt, ch_pkt)) begin
            `uvm_info("Scoreboard PKT_COMPARE Match", $sformatf("Scoreboard compare match for channel 2 packet: \n%s", ch_pkt.sprint()), UVM_LOW)
            ch2_packets_match++;
        end
        else begin
            `uvm_info("Scoreboard PKT_COMPARE Unmatch", $sformatf("Scoreboard compare unmatch for channel 2 packet:\n%s\nExpected channel 2 packet:\n%s", ch_pkt.sprint(), y_pkt.sprint()), UVM_LOW)
            ch2_packets_unmatch++;
        end
    endfunction

    function bit comp_equal (input yapp_packet yp, input channel_packet cp);
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction

   // Can also put a check_phase here to check if the queues are empty or not. If aint empty, do `uvm_error()

   function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "\n\nScoreboard Statistics:\n", UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("\nNumber of YAPP packets received: %0d\nNumber of YAPP packets dropped due to invalid address: %0d\n\n", yapp_packets_in, yapp_packets_dropped_addr), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("\nNumber of Channel0 packets received: %0d\nNumber of Channel0 Matches: %0d\nNumber of Channel0 Unmatches: %0d\nChannel0 packets dropped: %0d\nPackets left in Queue 0: %0d\n\n", ch0_packets_in, ch0_packets_match, ch0_packets_unmatch, ch0_packets_dropped, q0.size()), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("\nNumber of Channel1 packets received: %0d\nNumber of Channel1 Matches: %0d\nNumber of Channel1 Unmatches: %0d\nChannel1 packets dropped: %0d\nPackets left in Queue 1: %0d\n\n", ch1_packets_in, ch1_packets_match, ch1_packets_unmatch, ch1_packets_dropped, q1.size()), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("\nNumber of Channel2 packets received: %0d\nNumber of Channel2 Matches: %0d\nNumber of Channel2 Unmatches: %0d\nChannel2 packets dropped: %0d\nPackets left in Queue 2: %0d\n\n", ch2_packets_in, ch2_packets_match, ch2_packets_unmatch, ch2_packets_dropped, q2.size()), UVM_HIGH)

        if ((ch0_packets_unmatch + ch0_packets_unmatch + ch0_packets_unmatch) > 0)
            `uvm_error(get_type_name(), "Simulation Status: \n\n Simulation Failed\n")
        else
            `uvm_info(get_type_name(), "Simulation Status: \n\n Simulation Passed\n", UVM_NONE)
   endfunction

endclass : router_scoreboard    