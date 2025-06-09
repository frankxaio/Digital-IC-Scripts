#!/usr/bin/env python3
import os
import glob

def main():
    root_path = os.environ.get("ROOT_PATH")
    if not root_path:
        print("❌ Error: ROOT_PATH environment variable not set.")
        return

    output_file = os.path.join(root_path, "00_TESTBED", "gate_sim.f")
    verilog_files = []

    # Search for Verilog files in $ROOT_PATH/02_SYN/Netlist/*.v
    netlist_path = os.path.join(root_path, "02_SYN", "Netlist", "*.v")
    netlist_files = glob.glob(netlist_path)
    for file in netlist_files:
        relative_path = os.path.relpath(file, root_path)
        verilog_files.append(f"$ROOT_PATH/{relative_path}")

    # Search for Verilog or SystemVerilog files in $ROOT_PATH/00_TESTBED/*.v or *.sv
    testbed_path_v = os.path.join(root_path, "00_TESTBED", "*.v")
    testbed_path_sv = os.path.join(root_path, "00_TESTBED", "*.sv")
    testbed_files = glob.glob(testbed_path_v) + glob.glob(testbed_path_sv)
    for file in testbed_files:
        relative_path = os.path.relpath(file, root_path)
        verilog_files.append(f"$ROOT_PATH/{relative_path}")

    # Sort for consistency
    verilog_files.sort()

    # Write to file
    with open(output_file, "w") as f:
        for line in verilog_files:
            f.write(line + "\n")

    print(f"✅ File list written to: {output_file}")

if __name__ == "__main__":
    main()