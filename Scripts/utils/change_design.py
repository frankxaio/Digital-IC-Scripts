#!/usr/bin/env python3
"""
Design Name Changer Script
Modifies top_design in Makefile and set DESIGN in syn.tcl
"""

import os
import re
import sys
from pathlib import Path

class DesignChanger:
    def __init__(self, root_path="."):
        self.root_path = Path(root_path)
        self.makefile_path = self.root_path / "01_RTL" / "Makefile"
        self.syn_tcl_path = self.root_path / "02_SYN" / "syn.tcl"
        
    def get_current_design(self):
        """Get current design name from both files"""
        current_makefile = None
        current_syn_tcl = None
        
        # Read from Makefile
        if self.makefile_path.exists():
            with open(self.makefile_path, 'r') as f:
                content = f.read()
                match = re.search(r'top_design=(\w+)', content)
                if match:
                    current_makefile = match.group(1)
        
        # Read from syn.tcl
        if self.syn_tcl_path.exists():
            with open(self.syn_tcl_path, 'r') as f:
                content = f.read()
                match = re.search(r'set DESIGN (\w+)', content)
                if match:
                    current_syn_tcl = match.group(1)
        
        return current_makefile, current_syn_tcl
    
    def change_design(self, new_design):
        """Change design name in both files"""
        if not new_design or not new_design.strip():
            print("❌ Error: Design name cannot be empty")
            return False
        
        new_design = new_design.strip()
        
        # Validate design name (alphanumeric and underscore only)
        if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', new_design):
            print("❌ Error: Design name must start with letter or underscore and contain only alphanumeric characters and underscores")
            return False
        
        success = True
        
        # Update Makefile
        if self.makefile_path.exists():
            try:
                with open(self.makefile_path, 'r') as f:
                    content = f.read()
                
                # Replace top_design line
                new_content = re.sub(
                    r'top_design=\w+',
                    f'top_design={new_design}',
                    content
                )
                
                with open(self.makefile_path, 'w') as f:
                    f.write(new_content)
                
                print(f"✅ Updated Makefile: top_design={new_design}")
                
            except Exception as e:
                print(f"❌ Error updating Makefile: {e}")
                success = False
        else:
            print(f"⚠️  Makefile not found: {self.makefile_path}")
        
        # Update syn.tcl
        if self.syn_tcl_path.exists():
            try:
                with open(self.syn_tcl_path, 'r') as f:
                    content = f.read()
                
                # Replace set DESIGN line
                new_content = re.sub(
                    r'set DESIGN \w+',
                    f'set DESIGN {new_design}',
                    content
                )
                
                with open(self.syn_tcl_path, 'w') as f:
                    f.write(new_content)
                
                print(f"✅ Updated syn.tcl: set DESIGN {new_design}")
                
            except Exception as e:
                print(f"❌ Error updating syn.tcl: {e}")
                success = False
        else:
            print(f"⚠️  syn.tcl not found: {self.syn_tcl_path}")
        
        return success
    
    def show_current(self):
        """Show current design names"""
        current_makefile, current_syn_tcl = self.get_current_design()
        
        print("📋 Current Design Configuration:")
        print(f"   Makefile (01_RTL/Makefile): top_design={current_makefile or 'Not found'}")
        print(f"   syn.tcl (02_SYN/syn.tcl): set DESIGN {current_syn_tcl or 'Not found'}")
        
        if current_makefile and current_syn_tcl and current_makefile != current_syn_tcl:
            print("⚠️  Warning: Design names are different between files!")

def main():
    if len(sys.argv) < 2:
        print("🔧 Design Name Changer")
        print("Usage:")
        print("  python change_design.py show                    # Show current design names")
        print("  python change_design.py <new_design_name>       # Change design name")
        print("  python change_design.py --help                  # Show this help")
        return
    
    if sys.argv[1] in ['--help', '-h', 'help']:
        print("🔧 Design Name Changer")
        print("This script modifies the design name in both Makefile and syn.tcl files.")
        print()
        print("Usage:")
        print("  python change_design.py show                    # Show current design names")
        print("  python change_design.py <new_design_name>       # Change design name")
        print("  python change_design.py --help                  # Show this help")
        print()
        print("Examples:")
        print("  python change_design.py show")
        print("  python change_design.py my_design")
        print("  python change_design.py processor_v2")
        return
    
    changer = DesignChanger()
    
    if sys.argv[1] == 'show':
        changer.show_current()
        return
    
    # Change design name
    new_design = sys.argv[1]
    if changer.change_design(new_design):
        print(f"\n🎉 Successfully changed design name to: {new_design}")
        print("\n📋 Updated configuration:")
        changer.show_current()
    else:
        print("\n❌ Failed to change design name")
        sys.exit(1)

if __name__ == "__main__":
    main()
