class router_reference extends uvm_component;

    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)
    
    uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in_imp;
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in_imp;
    uvm_analysis_port #(yapp_packet) val_yapp_out_port;

    bit [7:0] max_pkt_size_reg = 63; // set to default (reset) value
    bit [7:0] router_enable_reg = 1;

    int yapp_pkts_in, yapp_in_dropped, yapp_in_forwarded;
    int bad_addr_yapp_pkts, bad_size_yapp_pkts;

    `uvm_component_utils(router_reference)

    function new (string name, uvm_component parent);
        super.new(name, parent);
        yapp_in_imp = new("yapp_in_imp", this);
        hbus_in_imp = new("hbus_in_imp", this);
        val_yapp_out_port = new("val_yapp_out_port", this);
    endfunction

    function void write_hbus(input hbus_transaction h_pkt);
        `uvm_info(get_type_name, $sformatf("Reference Model: HBUS packet received - \n%s", h_pkt.sprint()), UVM_LOW)
        
        // Capture max_size_reg and enable_reg values whenever the HBUS transaction is a write to the max size and enable registers
        if (h_pkt.hwr_rd == HBUS_WRITE) begin
            // Set Packet Size: hbus address 1000, Enable YAPP Router: hbus address 1001
            case(h_pkt.haddr)
                16'h1000 : begin
                        max_pkt_size_reg = h_pkt.hdata;
                        `uvm_info(get_type_name, $sformatf("Reference Model: Max packet size is %0h", max_pkt_size_reg), UVM_LOW)
                        end
                16'h1001 : begin
                        router_enable_reg = h_pkt.hdata;
                        `uvm_info(get_type_name, $sformatf("Reference Model: Enable register value is %0h", router_enable_reg), UVM_LOW)
                        end
            endcase
        end
    endfunction

    function void write_yapp(input yapp_packet pkt);
        `uvm_info(get_type_name, $sformatf("Reference Model: YAPP packet received - \n%s", pkt.sprint()), UVM_LOW)
        yapp_pkts_in++;
        if (pkt.addr == 3) begin
            yapp_in_dropped++;
            bad_addr_yapp_pkts++;
            `uvm_info(get_type_name, $sformatf("Reference Model: YAPP packet dropped due to invalid address - \n%s", pkt.sprint()), UVM_LOW)
        end
        else if (!router_enable_reg) begin
            yapp_in_dropped++;
            `uvm_info(get_type_name, $sformatf("Reference Model: YAPP packet dropped as router is disabled - \n%s", pkt.sprint()), UVM_LOW)
        end
        else if ((router_enable_reg == 1) && (pkt.length > max_pkt_size_reg)) begin
            yapp_in_dropped++;
            bad_size_yapp_pkts++;
            `uvm_info(get_type_name, $sformatf("Reference Model: YAPP packet dropped due to bad packet size - \n%s", pkt.sprint()), UVM_LOW)
        end
        else if ((router_enable_reg == 1) && (pkt.length <= max_pkt_size_reg)) begin
            val_yapp_out_port.write(pkt);
            yapp_in_forwarded++;
            `uvm_info(get_type_name, $sformatf("Reference Model: YAPP packet forwarded to scoreboard - \n%s", pkt.sprint()), UVM_LOW)
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("\n\nReference Model Statistics:\nNumber of YAPP packets received: %0d\nNumber of YAPP packets forwarded: %0d\nTotal Number of YAPP packets dropped: %0d\n  - Number of YAPP packets dropped due to bad address: %0d\n  - Number of YAPP packets dropped due to bad size: %0d\n", yapp_pkts_in, yapp_in_forwarded, yapp_in_dropped, bad_addr_yapp_pkts, bad_size_yapp_pkts), UVM_HIGH)
   endfunction

endclass : router_reference