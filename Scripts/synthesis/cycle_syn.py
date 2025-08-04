#!/home/host/miniconda3/bin/python
import os
import re
import sys
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import console, print_info, print_warning, print_success, print_error

def print_matches(path, pattern, style):
    """Print lines matching the pattern with line numbers, highlighted."""
    rx = re.compile(pattern, re.IGNORECASE)  # Case-insensitive regex
    with open(path) as f:
        for idx, line in enumerate(f, 1):
            if rx.search(line):
                console.print(f"{idx:>4}: {line.rstrip()}", style=style)

def get_current_cycle(path):
    """Return the first cycle value found in the file, or None."""
    rx = re.compile(r'set cycle\s+([0-9]+\.?[0-9]*)', re.IGNORECASE)  # Case-insensitive regex
    with open(path) as f:
        for line in f:
            m = rx.search(line)
            if m:
                return m.group(1)
    return None

def update_cycle(path, new_cycle):
    """Replace all occurrences of 'set cycle' with the new value. Return count."""
    # Ensure new_cycle is formatted as a float (e.g., 5 -> 5.0)
    new_cycle = f"{float(new_cycle):.1f}"
    pattern = re.compile(r'(set cycle\s+)([0-9]+\.?[0-9]*)', re.IGNORECASE)  # Updated regex
    with open(path) as f:
        text = f.read()
    # Use \g<1> for group reference
    new_text, count = pattern.subn(rf'\g<1>{new_cycle}', text)
    if count:
        with open(path, 'w') as f:
            f.write(new_text)
    return count

def main():
    # Ensure the correct number of arguments are provided
    if len(sys.argv) < 4:
        print_error("Error: Missing arguments. Usage: cycle_syn.py <SYN_FILE> <SDC_FILE> <new_cycle>")
        sys.exit(1)

    syn_file = sys.argv[1]
    sdc_file = sys.argv[2]
    new_cycle = sys.argv[3]

    # Validate the provided files
    if not os.path.isfile(syn_file):
        print_error(f"Error: SYN_FILE does not exist: {syn_file}")
        sys.exit(1)

    if not os.path.isfile(sdc_file):
        print_warning(f"Warning: SDC_FILE does not exist: {sdc_file}. Only SYN_FILE will be used.")

    # Display the current cycle values if no new_cycle is provided
    print_info(f"Synthesis File: {syn_file}")
    print_matches(syn_file, r'set cycle [0-9]+\.?[0-9]*', "info")
    if os.path.isfile(sdc_file):
        print_info(f"SDC File: {sdc_file}")
        print_matches(sdc_file, r'set cycle [0-9]+\.?[0-9]*', "info")

    # Check the current cycle in SYN_FILE
    current = get_current_cycle(syn_file)
    if not current and os.path.isfile(sdc_file):
        print_warning("No cycle found in SYN_FILE. Checking SDC_FILE...")
        current = get_current_cycle(sdc_file)

    if current == f"{float(new_cycle):.1f}":
        print_warning(f"Cycle time is already {new_cycle}. No change needed.")
        sys.exit(0)

    # Show old cycle in red
    if current:
        print_matches(syn_file, r'set cycle [0-9]+\.?[0-9]*', "error")
        if os.path.isfile(sdc_file):
            print_matches(sdc_file, r'set cycle [0-9]+\.?[0-9]*', "error")

    # Update SYN_FILE first
    changed = update_cycle(syn_file, new_cycle)
    if not changed and os.path.isfile(sdc_file):
        print_warning("No 'set cycle' line found in SYN_FILE. Updating SDC_FILE...")
        changed = update_cycle(sdc_file, new_cycle)

    if changed:
        # Show new cycle in green
        print_matches(syn_file, r'set cycle [0-9]+\.?[0-9]*', "success")
        if os.path.isfile(sdc_file):
            print_matches(sdc_file, r'set cycle [0-9]+\.?[0-9]*', "success")
        print_success(f"Changed cycle time to {float(new_cycle):.1f}.")
    else:
        print_warning("No 'set cycle' line found or modified in either file.")

if __name__ == '__main__':
    main()