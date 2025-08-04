#!/home/host/miniconda3/bin/python
"""
Test script to verify rich output in check_syn functionality.
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import (
    console, print_info, print_warning, print_success, print_error, print_bold
)

def test_check_syn_output():
    """Test the output formatting used in check_syn.py."""
    
    # Test the separator lines
    console.print("============================", style="warning")
    
    # Test check results
    print_error("--> X There is Latch in this design ---")
    print_success("--> V Latch Checked!")
    
    print_error("--> X Width Mismatch Error !! ---")
    print_success("--> V Width Mismatch Checked!")
    
    print_error("--> X There is Error in this design !! ---")
    print_success("--> V No Error in syn.log!")
    
    print_error("--> X Timing (violated) ---")
    print_success("--> V Timing (MET) Checked!")
    
    # Test final summary
    console.print("============================", style="warning")
    print_error("--> X 02_SYN Fail !! Please check out log files.")
    print_success("--> V 02_SYN Success !!")
    
    # Test report section
    console.print("============================", style="warning")
    print_bold("Design: test_design")
    print_bold("Cycle: 10.0")
    print_bold("Area: 1000.0")
    print_bold("Dynamic: 50.0 mW")
    print_bold("Leakage: 5.0 mW")

if __name__ == "__main__":
    test_check_syn_output() 