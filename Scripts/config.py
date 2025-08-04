#!/home/host/miniconda3/bin/python
"""
Common configuration and utility functions for synthesis scripts.
This module centralizes shared functionality used across multiple Python scripts.
"""

import os
import sys
from pathlib import Path
from rich.console import Console
from rich.theme import Theme

# =============================================================================
# Rich Console Setup
# =============================================================================

# Create a custom theme with colors that match the original ANSI codes
custom_theme = Theme({
    "info": "blue",
    "warning": "yellow", 
    "success": "green",
    "error": "red",
    "bold": "bold",
    "dim": "dim"
})

# Create console instance with custom theme
console = Console(theme=custom_theme)

# Convenience functions for colored output
def print_info(text: str) -> None:
    """Print text in blue color."""
    console.print(text, style="info")

def print_warning(text: str) -> None:
    """Print text in yellow color."""
    console.print(text, style="warning")

def print_success(text: str) -> None:
    """Print text in green color."""
    console.print(text, style="success")

def print_error(text: str) -> None:
    """Print text in red color."""
    console.print(text, style="error")

def print_bold(text: str) -> None:
    """Print text in bold."""
    console.print(text, style="bold")

# =============================================================================
# Environment and Path Management
# =============================================================================

def get_root_path() -> str:
    """
    Get the ROOT_PATH environment variable.
    
    Returns:
        str: The ROOT_PATH value
        
    Raises:
        SystemExit: If ROOT_PATH is not set
    """
    root_path = os.environ.get("ROOT_PATH")
    if not root_path:
        print_error("❌ Error: ROOT_PATH environment variable not set.")
        sys.exit(1)
    return root_path

def get_root_path_pathlib() -> Path:
    """
    Get the ROOT_PATH environment variable as a Path object.
    
    Returns:
        Path: The ROOT_PATH as a Path object
        
    Raises:
        SystemExit: If ROOT_PATH is not set
    """
    root_path_str = os.environ.get("ROOT_PATH")
    if not root_path_str:
        console.print("Error: ROOT_PATH environment variable is not set.", style="error", file=sys.stderr)
        sys.exit(1)
    return Path(root_path_str)

 