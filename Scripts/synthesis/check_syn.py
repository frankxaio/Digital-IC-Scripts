#!/home/host/miniconda3/bin/python
import os
import re
import sys
from pathlib import Path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import (
    console, print_info, print_warning, print_success, print_error, print_bold,
    get_root_path_pathlib
)

# --- Configuration ---
# This script is intended to be run after a synthesis tool, like Design Compiler,
# has generated its log and report files.
# e.g., dcnxt_shell -f syn.tcl | tee syn.log

# --- Helper Functions ---

def get_design_name(tcl_path: Path) -> str:
    """Parses the syn.tcl file to find the design name."""
    try:
        with open(tcl_path, 'r') as f:
            for line in f:
                if line.strip().startswith('set DESIGN'):
                    # Find the value, remove quotes and semicolons
                    match = re.search(r'set\s+DESIGN\s+"?([^"\s;]+)', line)
                    if match:
                        return match.group(1)
    except FileNotFoundError:
        console.print(f"Error: TCL file not found at '{tcl_path}'", style="error", file=sys.stderr)
        sys.exit(1)
    return "UNKNOWN_DESIGN"

def extract_from_report(file_path: Path, pattern: str) -> str:
    """Extracts a numeric value or a full line from a report file."""
    try:
        with open(file_path, 'r') as f:
            for line in f:
                if re.search(pattern, line, re.IGNORECASE):
                    # For power, return the whole line
                    if "Power" in line:
                        return line.strip()
                    # For others, find and return the first floating point number
                    match = re.search(r'[+-]?\d+(\.\d+)?', line)
                    if match:
                        return match.group(0)
    except FileNotFoundError:
        # Don't exit, just return empty so checks can proceed
        console.print(f"Warning: Report file not found: '{file_path}'", style="warning", file=sys.stderr)
    return ""

def check_log_for_pattern(file_path: Path, pattern: str) -> bool:
    """Checks if a pattern exists in a file (case-insensitive)."""
    try:
        with open(file_path, 'r') as f:
            for line in f:
                if re.search(pattern, line, re.IGNORECASE):
                    return True
    except FileNotFoundError:
        console.print(f"Error: Log file not found at '{file_path}'", style="error", file=sys.stderr)
        # If the log doesn't exist, we should probably fail all checks
        return True
    return False

# --- Main Execution ---

def main():
    """Main function to parse reports and print a summary."""
    root_path = get_root_path_pathlib()

    # Get design name from TCL file
    tcl_file = root_path / "02_SYN" / "syn.tcl"
    design = get_design_name(tcl_file)

    # Define paths to log and report files
    syn_log_file = Path("syn.log")
    report_dir = Path("Report")
    qor_file = report_dir / f"{design}.qor"
    area_file = report_dir / f"{design}.area"
    power_file = report_dir / f"{design}.power"
    timing_file = report_dir / f"{design}.timing"

    # Extract data from reports
    cycle = extract_from_report(qor_file, r"Critical Path Clk Period:")
    area = extract_from_report(area_file, r"Total cell area:")
    dynamic = extract_from_report(power_file, r"Total Dynamic Power")
    leakage = extract_from_report(power_file, r"Cell Leakage Power")

    memory_area_line = extract_from_report(area_file, r"Macro/Black Box area")
    # Equivalent to `tr -dc '0-9'`
    memory_area = re.sub(r'\D', '', memory_area_line)

    gate_count = 0
    if area:
        # Gate count calculation (example for U18 library)
        gate_count = float(area) / 9.9792  # U18 gate count
        # gate_count = float(area) / 10     # T18 gate count
        # gate_count = float(area) / 2.8224 # T90 gate count

    # --- Perform Checks ---
    has_failed = False
    console.print("============================", style="warning")

    # Check for Latches
    if check_log_for_pattern(syn_log_file, "Latch"):
        print_error("--> X There is Latch in this design ---")
        has_failed = True
    else:
        print_success("--> V Latch Checked!")

    # Check for Width Mismatch
    if check_log_for_pattern(syn_log_file, "mismatch"):
        print_error("--> X Width Mismatch Error !! ---")
        has_failed = True
    else:
        print_success("--> V Width Mismatch Checked!")

    # Check for other Errors
    if check_log_for_pattern(syn_log_file, "Error"):
        print_error("--> X There is Error in this design !! ---")
        has_failed = True
    else:
        print_success("--> V No Error in syn.log!")

    # Check for Timing Violations
    if check_log_for_pattern(timing_file, "violated"):
        print_error("--> X Timing (violated) ---")
        has_failed = True
    else:
        print_success("--> V Timing (MET) Checked!")

    # Check for Memory usage (replicated from original script)
    # if memory_area == "0000000":
    #     print_error("--> X No use of memory ---")
    #     has_failed = True
    # else:
    #     print_success("--> V Memory Checked!")

    # --- Final Summary ---
    console.print("============================", style="warning")
    if has_failed:
        print_error("--> X 02_SYN Fail !! Please check out log files.")
    else:
        print_success("--> V 02_SYN Success !!")

    # --- Print Report ---
    console.print("============================", style="warning")
    print_bold(f"Design: {design}")
    print_bold(f"Cycle: {cycle}")
    print_bold(f"Area: {area}")
    # print_bold(f"Gate count: {gate_count:,.0f} (U18)")
    # print_bold(f"Gate count: {gate_count:,.0f} (T18)")
    # print_bold(f"Gate count: {gate_count:,.0f} (T90)")
    print_bold(f"Dynamic: {dynamic}")
    print_bold(f"Leakage: {leakage}")


if __name__ == "__main__":
    main()