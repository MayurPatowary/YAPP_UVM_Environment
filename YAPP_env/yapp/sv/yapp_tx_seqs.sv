class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

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

endclass : yapp_base_seq

class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

class yapp_6_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_6_packets)

  // Constructor
  function new(string name="yapp_6_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_6_packets sequence", UVM_LOW)
     repeat(6)
      `uvm_do(req)
  endtask
  
endclass : yapp_6_packets

//  single packet to address 1
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 1;})
  endtask

endclass : yapp_1_seq

// three packets with incrementing addresses - 0, 1, 2
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 0;})
    `uvm_do_with(req, {req.addr == 1;})
    `uvm_do_with(req, {req.addr == 2;})
  endtask

endclass : yapp_012_seq


// Nested sequence – three packets to address 1
class yapp_111_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_111_seq)

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction

  yapp_1_seq addr1_seq;
  
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat (3)
      `uvm_do(addr1_seq)
  endtask

endclass : yapp_111_seq

// two packets to the same (random) address
class yapp_repeat_addr_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_repeat_addr_seq)

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  rand bit [1:0] rand_addr;
  constraint c1 {rand_addr != 3;}
  
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    repeat(2)
      `uvm_do_with(req, {req.addr == rand_addr;})
    // OR
    // `uvm_do(req)
    // rand_addr = req.addr;
    // `uvm_do_with(req, {req.addr == rand_addr;})
  endtask

endclass : yapp_repeat_addr_seq

// single packet with incrementing payload data
class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction
  
  int ok;

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req)
    ok = req.randomize();
    foreach (req.payload[i])
      req.payload[i] = i;
    req.set_parity();
    `uvm_send(req)
    // OR
    // `uvm_do_with(req, {foreach (req.payload[i]) req.payload[i] == i;})
  endtask

endclass : yapp_incr_payload_seq

// execute all sequences to test
class yapp_exhaustive_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  yapp_1_seq y1seq;
  yapp_012_seq y012seq;
  yapp_111_seq y111_seq;
  yapp_repeat_addr_seq yrd_seq;
  yapp_incr_payload_seq yip_seq;

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    `uvm_do(y1seq)
    `uvm_do(y012seq)
    `uvm_do(y111_seq)
    `uvm_do(yrd_seq)
    `uvm_do(yip_seq)
  endtask

endclass : yapp_exhaustive_seq

// for lab-7
class yapp_4_channels_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_4_channels_seq)

  function new(string name = "yapp_4_channels_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_4_channels_seq sequence", UVM_LOW)

    // // the payload values are not sequentially increasing from 0
    // for (int c = 0; c < 4; c++) begin
    //   for (int ps = 1; ps < 23; ps++) begin
    //     `uvm_do_with(req, {req.addr == c; req.length == ps; parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 4}; req.packet_delay == 1;})
    //   end
    // end

    // the payload values are sequentially increasing from 0
    `uvm_create(req)
    req.packet_delay = 1;
    for (int c = 0; c < 4; c++) begin
      req.addr = c;
      for (int ps = 1; ps < 23; ps++) begin
        req.length = ps;
        req.payload = new[ps];
        for (int i = 0; i < ps; i++)
          req.payload[i] = i;
        randcase
          20 : req.parity_type = BAD_PARITY;
          80 : req.parity_type = GOOD_PARITY;
        endcase
        req.set_parity();
        `uvm_send(req)
      end
    end

  endtask

endclass : yapp_4_channels_seq