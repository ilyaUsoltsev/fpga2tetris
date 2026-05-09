# FPGA Setup Journey

## Hardware

- Olimex iCE40-HX1K-EVB FPGA board
- Olimexino-32U4 used as FPGA programmer
- MacBook (Apple Silicon)

---

# 1. Install Python + Apio

```bash
python --version
```

Install Apio:

```bash
pip install apio
```

Install FPGA toolchain:

```bash
apio install --all
```

---

# 2. Flash Olimexino with `iceprog`

Open Arduino IDE.

Select board:

```text
Arduino Leonardo
```

Open firmware from:

```text
iCE40HX1K-EVB/programmer/olimexino-32u4 firmware/iceprog
```

Fix issues:

- remove broken `.cpp` file containing `../iceprog.ino`
- avoid duplicate definitions

Upload firmware successfully.

---

# 3. Connect Olimexino to FPGA

UEXT wiring:

```text
Olimexino UEXT → FPGA UEXT

3.3V → 3.3V
GND  → GND
MISO → MISO
MOSI → MOSI
SCK  → SCK
CS   → CS
```

Set voltage jumper to:

```text
3.3V
```

Power FPGA board separately.

---

# 4. Generate Example Project

Create example project:

```bash
apio examples -d iCE40-HX1K-EVB/leds
```

Enter project folder:

```bash
cd iCE40-HX1K-EVB/leds
```


---

# 5. Build and Flash Example

Build project:

```bash
apio build
```

Flash FPGA:

```bash
iceprogduino -I/dev/cu.usbmodem1101 hardware.bin
```

Successful output includes:

```text
Manufacturer ID: 0x1C / Device ID: 0x7015
```

---

# 6. Learn Active-Low Buttons

Board buttons are active-low:

```text
not pressed = 1
pressed     = 0
```

So use inversion:

```verilog
~but[0]
```

---

# 7. FPGA Project Structure

Current structure:

```text
leds/
├── apio.ini
├── constraints.pcf
├── leds.v
├── xor.v
└── leds_tb.v
```

---

# 8. Constraints (`constraints.pcf`)

Pin mappings:

```text
set_io but[0] 41
set_io but[1] 42
set_io led[0] 40
set_io led[1] 51
```

Meaning:

```text
signal → physical FPGA pin
```

---

# 9. Create Reusable Modules

Example `xor.v`:

```verilog
module xor_gate(
    input wire a,
    input wire b,
    output wire out
);

assign out = a ^ b;

endmodule
```

Use inside `leds.v`:

```verilog
xor_gate xor1(
    .a(~but[0]),
    .b(~but[1]),
    .out(led[0])
);
```

Learned:

- modules
- instances
- named port connections

---

# 10. Add Simulation Tools to PATH

Add to `~/.zshrc`:

```bash
export PATH="$HOME/.apio/packages/tools-oss-cad-suite/bin:$PATH"
```

Reload:

```bash
source ~/.zshrc
```

Verify:

```bash
which iverilog
which vvp
```

---

# 11. Run Simulations

Compile:

```bash
iverilog -o leds_tb.out xor.v leds.v leds_tb.v
```

Run:

```bash
vvp leds_tb.out
```

Use `$monitor(...)` for debugging:

```verilog
$monitor(
    "but1=%b but0=%b | led1=%b led0=%b",
    but[1], but[0],
    led[1], led[0]
);
```

---

# 12. Simulation vs Synthesis

## Simulation

```bash
iverilog
vvp
```

Tests logic behavior.

## Synthesis

```bash
apio build
```

Creates FPGA hardware image:

```text
hardware.bin
```

---

# 13. Flash FPGA

```bash
iceprogduino -I/dev/cu.usbmodem1101 hardware.bin
```

---

# 14. FPGA Development Workflow

## Simulate

```bash
iverilog -o leds_tb.out xor.v leds.v leds_tb.v
vvp leds_tb.out
```

## Build

```bash
apio build
```

## Flash

```bash
iceprogduino -I/dev/cu.usbmodem1101 hardware.bin
```

---

# 15. Concepts

- FPGA basics
- Verilog modules
- hierarchical hardware design
- simulation
- synthesis
- constraints / pin mapping
- active-low signals
- reusable hardware blocks
- hardware debugging
- nand2tetris-style architecture building

---

# Current Status

Working FPGA workflow with:

- simulation
- synthesis
- flashing
- reusable Verilog modules
- real hardware testing

- flashing
- reusable Verilog modules
- real hardware testing
