#!/home/host/miniconda3/bin/python
"""
Test script to demonstrate rich output functionality.
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import (
    console, print_info, print_warning, print_success, print_error, print_bold
)

def main():
    """Demonstrate rich output capabilities."""
    
    # Test basic colored output
    print_info("This is an info message in blue")
    print_warning("This is a warning message in yellow")
    print_success("This is a success message in green")
    print_error("This is an error message in red")
    print_bold("This is a bold message")
    
    # Test console with custom styling
    console.print("Custom styled text", style="bold blue")
    console.print("Another custom style", style="italic green")
    
    # Test with emojis and symbols
    print_success("✅ Operation completed successfully!")
    print_error("❌ Something went wrong!")
    print_warning("⚠️  Please check your input")
    print_info("ℹ️  Here's some information")

if __name__ == "__main__":
    main() 