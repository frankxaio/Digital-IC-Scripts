
"""
Print colored, nicely-framed Design-Compiler *.area and *.timing reports
while preserving the original report layout.

Usage
-----
    export ROOT_PATH=/absolute/path/to/your/project
    python print_area_report.py [--area] [--timing]

If no flags are given, both report types will be printed.

Prerequisites
-------------
    Ensure 'colorama' is installed in your Conda env:
        conda install colorama
"""

import os
import sys
import glob
import argparse
from typing import Optional

# Optional: add color support
try:
    from colorama import init, Fore, Style
    init(autoreset=True)
except ImportError:
    class Fore:
        CYAN = YELLOW = MAGENTA = RED = ''
    class Style:
        BRIGHT = RESET_ALL = ''

# ---------------------------------------------------------------------
# Resolve ROOT_PATH
# ---------------------------------------------------------------------
ROOT_PATH = os.environ.get('ROOT_PATH')
if not ROOT_PATH:
    sys.exit(Fore.RED + '❌  ROOT_PATH environment variable is not set.' + Style.RESET_ALL)

# ---------------------------------------------------------------------
# Locate report files
# ---------------------------------------------------------------------
report_dir = os.path.join(ROOT_PATH, '02_SYN', 'Report')
area_files   = sorted(glob.glob(os.path.join(report_dir, '*.area')))
timing_files = sorted(glob.glob(os.path.join(report_dir, '*.timing')))

# ---------------------------------------------------------------------
# Helper: extract asterisk block (area reports)
# ---------------------------------------------------------------------
def extract_area_block(text: str) -> Optional[str]:
    lines = text.splitlines()
    try:
        start = next(i for i, ln in enumerate(lines) if ln.startswith('*'))
        end   = next(i for i in range(len(lines)-1, -1, -1) if lines[i].strip() == '1')
        return '\n'.join(lines[start:end+1])
    except StopIteration:
        return None

# ---------------------------------------------------------------------
# Framing utility
# ---------------------------------------------------------------------
FRAME_W = 80

def frame(title: str, block: str) -> None:
    bar = Fore.YELLOW + '=' * FRAME_W + Style.RESET_ALL
    header = Fore.CYAN + Style.BRIGHT + f'📄 {title}' + Style.RESET_ALL
    print(f"\n{header}\n{bar}")
    print(block)
    print(bar)

# ---------------------------------------------------------------------
# Process area reports
# ---------------------------------------------------------------------

def print_area_reports():
    if not area_files:
        print(Fore.RED + f'❌  No .area files found in: {report_dir}' + Style.RESET_ALL)
        return
    for fp in area_files:
        with open(fp, 'r', encoding='utf-8', errors='ignore') as f:
            text = f.read()
        block = extract_area_block(text)
        if block:
            frame(os.path.basename(fp), block)
        else:
            print(Fore.MAGENTA + f"⚠️  Skipped {fp}: no area block found" + Style.RESET_ALL)

# ---------------------------------------------------------------------
# Process timing reports
# ---------------------------------------------------------------------

def print_timing_reports():
    if not timing_files:
        print(Fore.RED + f'❌  No .timing files found in: {report_dir}' + Style.RESET_ALL)
        return
    for fp in timing_files:
        with open(fp, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        frame(os.path.basename(fp), content)

# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Print area and/or timing reports',
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--area',   action='store_true', help='Print *.area reports only')
    parser.add_argument('--timing', action='store_true', help='Print *.timing reports only')
    args = parser.parse_args()

    if not args.area and not args.timing:
        # no flags: do both
        print_area_reports()
        print_timing_reports()
    else:
        if args.area:
            print_area_reports()
        if args.timing:
            print_timing_reports()
