typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_t;

class yapp_packet extends uvm_sequence_item;

  // Packet fields
  rand bit [1:0] addr;
  rand bit [5:0] length;
  rand bit [7:0] payload [];
  bit [7:0] parity;

  // Constructor
  function new (string name = "yapp_packet");
    super.new(name);
  endfunction : new
  
  // Control fields
  rand int packet_delay;
  rand parity_t parity_type;

  // Enable automation of the packet's fields
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(addr, UVM_ALL_ON);
    `uvm_field_int(length, UVM_ALL_ON);
    `uvm_field_array_int(payload, UVM_ALL_ON);
    `uvm_field_int(parity, UVM_ALL_ON);
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON);
    `uvm_field_int(packet_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE);
  `uvm_object_utils_end

  // Default packet constraints
  constraint c1 {length == payload.size();}
  constraint c2 {length > 0; length < 64;}
  constraint c3 {packet_delay > 0; packet_delay < 20;}
  constraint c4 {addr != 3;}
  constraint c5 {parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 5};} // distribution of 5:1 in favor of good parity

  // Parity calculation
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    foreach (payload[i])
      calc_parity = calc_parity ^ payload[i];
  endfunction : calc_parity

  // Control parity
  function void set_parity();
    parity = calc_parity();
    if (parity_type == BAD_PARITY)
      parity++;
  endfunction : set_parity

  // Post-randomize
  function void post_randomize();
    set_parity();
  endfunction: post_randomize

endclass: yapp_packet

class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  function new (string name = "short_yapp_packet");
    super.new(name);
  endfunction : new

  constraint sc1 {length < 15;}
  // constraint sc2 {addr != 2;}

endclass : short_yapp_packet
