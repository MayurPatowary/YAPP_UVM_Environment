# YAPP UVM Environment  

## Note

The following directories were provided:  
- `router_rtl`  
- `channel`  
- `clock_and_reset`  
- `hbus`  

The remaining directories—`yapp`, `router_module`, and `tb` (except `tb/clkgen.sv`)—were created from scratch.  

## Overall Environment

![YAPP UVM Environment]("Environment%Diagram.jpg")

## Contributions  

- **Created a YAPP (Yet Another Packet Protocol) packet** using a **UVM sequence item** with constraints for **address, length, and packet delay**. Enabled automation for all packet fields.  
- **Developed the testbench** and **test components** of the environment, incorporating **UVM phasing**.  
- **Implemented driver, sequencer, and monitor components** of the **YAPP UVC**. Created an **agent** to instantiate and manage these components and constructed the agent in the **UVC top level**.  
- **Defined a sequence library** with multiple sequences (**random and directed**) and executed them on the **YAPP sequencer** using **UVM configuration** (setting the sequencer’s default sequence).  
- **Developed the YAPP input interface** and implemented tasks for **packet transmission** (for driver) and **monitoring** (for monitor).  
- **Connected the driver and monitor virtual interfaces** to the **input interface** via **UVM configuration** (using `set` and `get`). Instantiated and connected the **input interface and DUT** in the **hardware top module**.  
- **Integrated and configured the HBUS UVC, Clock and Reset UVC, and three output Channel UVCs** in the **UVM testbench**.  
- **Implemented a multichannel sequencer** and ran a **multichannel sequence** to coordinate the activity of the **YAPP and HBUS UVCs**.  
- **Created and connected a scoreboard** to the **UVM testbench** using **TLM analysis ports**. Added a **reference model** to handle dropped packets in the **DUT**.  
