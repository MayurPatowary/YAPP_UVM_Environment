class router_mcsequencer extends uvm_sequencer;

    `uvm_component_utils(router_mcsequencer)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    yapp_tx_sequencer yapp_seqr;
    hbus_master_sequencer hbus_seqr;

    /*
    The Channel UVCs continuously execute a single response sequence, so they do not need
    to be controlled by the multichannel sequencer.

    The Clock and Reset UVC could be controlled by the multichannel sequencer if, for
    example, we wanted to initiate reset during packet transmission. However, for simplicity
    we’ll leave Clock and Reset out of the multichannel sequencer.
    */

endclass : router_mcsequencer