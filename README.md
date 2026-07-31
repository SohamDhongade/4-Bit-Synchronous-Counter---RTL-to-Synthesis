# 4-Bit-Synchronous-Counter---RTL-to-Synthesis
A complete digital design flow for a 4-bit synchronous up-counter with synchronous reset, from RTL design through functional verification to logic synthesis.

**Repository Structure**  
counter_4bit/  
```
├── counter_4bit.v            # RTL source  
├── counter_4bit_tb.v         # Testbench  
├── counter_4bit_synth.v      # Synthesized gate-level netlist (Yosys output)  
├── counter_4bit.vcd          # GTKWave simulation waveform  
├── counter_schematic.png     # Synthesized gate-level schematic  
└── README.md  
```
**1. Functional Verification**  
Simulated using Icarus Verilog, with waveforms viewed in GTKWave.  

```bash  
iverilog -o counter_4bit.vvp counter_4bit.v tb_counter_4bit.v  
vvp counter_4bit.vvp  
gtkwave counter_4bit.vcd  
```
The testbench applies reset and clock stimulus and confirms the count increments correctly each cycle and resets to 0000 when rst is asserted.  

Waveform  
<img width="958" height="515" alt="image" src="https://github.com/user-attachments/assets/809ee9eb-2d2e-49ca-82ae-5c6f551d338f" />  
The waveform confirms count increments by 1 on each rising edge of clk, wraps from 1111 back to 0000 after reaching 15, and resets immediately to 0000 when rst is asserted.  

**2. Logic Synthesis**  
Synthesized using Yosys (via the OSS CAD Suite), targeting generic technology-independent logic gates (no specific standard-cell library applied at this stage).  
```
yosys> read_verilog counter_4bit.v  
yosys> synth -top counter_4bit  
yosys> show  
yosys> write_verilog counter_4bit_synth.v  
```
**Synthesis Results**  
The design synthesized to 10 cells:  

| Cell Type	| Count	| Function  
| --- | --- | --- |
| $_SDFF_PP0_	|4	 | Positive-edge, sync-reset-to-0 flip-flops (the count register)  
| $_AND_	| 1	| Carry generation  
| $_NAND_	| 1	| Carry generation  
| $_XOR_	| 2	| Sum bits  
| $_XNOR_	| 1	| Sum bit  
| $_NOT_	| 1	| Bit-0 toggle  

The combinational logic implements the count + 1 increment as a minimal ripple-carry-style adder, generated automatically by Yosys's ALU/ABC mapping — rather than being written explicitly at the gate level in the RTL.  

**Schematic**  
See counter_schematic.png for the full gate-level schematic, generated via:  

```bash  
dot -Tpng show.dot -o counter_schematic.png  
```
**Notes**  
1. This synthesis run is technology-independent — no .lib (Liberty) file or clock constraints (SDC) were used, so no timing analysis was performed at this stage. Timing becomes meaningful once mapped to a real standard-cell library (e.g. SkyWater SKY130) in the physical design stage.  
2. Next step planned: Carrying this design through OpenLane/OpenROAD for floorplanning, placement, and routing using the open-source SKY130 PDK.  

**Tools Used**  
Icarus Verilog — simulation  
GTKWave — waveform viewing  
Yosys (via OSS CAD Suite) — synthesis  
Graphviz — schematic rendering  
