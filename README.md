# 8-bit Synchronous FIFO - 130nm ASIC Physical Design

This repository contains the RTL design, synthesis, and physical layout (Place & Route) for an **8-bit Synchronous FIFO**, implemented using the **SkyWater 130nm PDK** via **OpenLane**.

## 🛠️ Toolchain & PDK
* **HDVL:** Verilog RTL
* **ASIC Flow:** OpenLane / OpenROAD
* **PDK:** SkyWater 130nm (`sky130A`)
* **Standard Cell Library:** `sky130_fd_sc_hd`
* **Layout Viewer:** KLayout

## 📐 Physical Design Specifications
* **Die Area:** $200 \times 200\ \mu\text{m}$
* **Target Density:** 80%
* **Clock Period:** 10.0 ns (100 MHz)
* **Setup/Hold Violations:** 0 (Clean Signoff)
* **DRC / LVS:** Passed (0 violations)

## 📁 Repository Structure
* `fifo_sync.v` - Original Verilog RTL implementation
* `config.json` - OpenLane physical design configuration
* `deliverables/fifo_sync.gds` - Final GDSII physical layout
* `deliverables/` - STA reports and manufacturability metrics
