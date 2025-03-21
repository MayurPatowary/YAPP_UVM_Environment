/* Copyright Cadence Design Systems (c) 2015  */
// clock and reset (active high) interface

interface clock_and_reset_if  (
    input  bit          clock,
    output bit          reset,
           bit          run_clock = 0, 
           logic [31:0] clock_period = 10 );

  // input bit clock: This means clock is an input signal to the interface. The module that instantiates this interface 
  // will provide the clock signal, and the interface will receive it.

  // output bit reset: This means reset is an output signal from the interface. The interface will 
  // drive the reset signal, and the module using this interface will receive it.

  // run_clock and clock_period are also output signals/ports from this interface.

  // clock_and_reset_if doesn't generate clk signal directly but supplies control signals (run_clock and clock_period) to the clkgen instance. The clkgen 
  // generates the clk and the clk is passed back into clock_and_reset_if to synchronize the reset generation.
  // So the clock and reset interface has a clock input port but reset, run clock, and clock period output ports.

  int reset_delay;

  int clock_cycles_to_count;
  bit clock_cycle_count_reached=0;

  `ifdef IXCOM_UXE
    initial $ixc_ctrl("tb_export","start_clock");
    initial $ixc_ctrl("tb_export","count_clocks");
    initial $ixc_ctrl("tb_export","get_current_cycle_count");
    initial $export_event(clock_and_reset_if.clock_cycle_count_reached);
  `endif

  ///////////////////////////////////////
  // Manage clock and reset generation //
  ///////////////////////////////////////

  task start_clock(
    input int input_clock_period, input_reset_delay,
    input bit input_run_clock
  );
    run_clock    = input_run_clock;
    clock_period = input_clock_period;
    reset_delay  = input_reset_delay;
  endtask


  always @(posedge clock) begin
    if (reset_delay > 0) begin
      reset <= 1'b1;  // active
      reset_delay--;
    end
    else begin
      reset <= 1'b0;  // inactive
    end
  end

  /////////////////////////////////////////////////
  // Manage counting clock cycles (for timeouts) //
  // waiting for data to flush etc.              //
  /////////////////////////////////////////////////
  task count_clocks(input int new_count);
    // will fire the event at 1 and leave 0 for the idle state
    clock_cycles_to_count = new_count + 1;
  endtask 


  task get_current_cycle_count(output int cycles_counted);
    if (clock_cycles_to_count != 0) begin
      cycles_counted = clock_cycles_to_count - 1;
    end
    else begin
      cycles_counted = 0;
    end
  endtask 


  always @(posedge clock) begin
    if (clock_cycles_to_count != 0) begin
      clock_cycles_to_count--;
    end
    if (clock_cycles_to_count == 1) begin
        clock_cycle_count_reached = ~clock_cycle_count_reached;
    end
  end


endinterface
