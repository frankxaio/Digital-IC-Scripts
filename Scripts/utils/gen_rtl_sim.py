#!/home/host/miniconda3/bin/python
import os
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import get_root_path, print_success

def main():
    root_path = get_root_path()

    output_file = os.path.join(root_path, "00_TESTBED", "rtl_sim.f")
    verilog_files = []

    # Define the specific directories to search
    search_dirs = [os.path.join(root_path, "00_TESTBED"), os.path.join(root_path, "01_RTL")]

    for search_dir in search_dirs:
        for dirpath, dirnames, filenames in os.walk(search_dir):
            for filename in filenames:
                if filename.endswith(".v") or filename.endswith(".sv"):
                    full_path = os.path.join(dirpath, filename)
                    relative_path = os.path.relpath(full_path, root_path)
                    verilog_files.append(f"$ROOT_PATH/{relative_path}")

    # Sort for consistency
    verilog_files.sort()

    # Write to file
    with open(output_file, "w") as f:
        for line in verilog_files:
            f.write(line + "\n")

    print_success(f"✅ File list written to: {output_file}")
    
    # Print the contents of the generated file
    print("\n📄 Contents of rtl_sim.f:")
    print("=" * 50)
    with open(output_file, "r") as f:
        for line in f:
            print(line.rstrip())
    print("=" * 50)

if __name__ == "__main__":
    main()
