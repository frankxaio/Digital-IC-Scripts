#!/usr/bin/env python3
import os

def main():
    root_path = os.environ.get("ROOT_PATH")
    if not root_path:
        print("❌ Error: ROOT_PATH environment variable not set.")
        return

    output_file = os.path.join(root_path, "00_TESTBED", "rtl_sim.f")
    verilog_files = []

    for dirpath, dirnames, filenames in os.walk(root_path):
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

    print(f"✅ File list written to: {output_file}")

if __name__ == "__main__":
    main()
