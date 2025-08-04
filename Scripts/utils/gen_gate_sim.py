#!/home/host/miniconda3/bin/python
import os
import glob
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import get_root_path, print_success

def main():
    root_path = get_root_path()

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

    print_success(f"✅ File list written to: {output_file}")
    
    # Print the contents of the generated file
    print("\n📄 Contents of gate_sim.f:")
    print("=" * 50)
    with open(output_file, "r") as f:
        for line in f:
            print(line.rstrip())
    print("=" * 50)

if __name__ == "__main__":
    main()