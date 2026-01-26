import sys
import os
import re

def lint_file(filepath):
    print(f"Checking {filepath}...")
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    errors = []
    
    # 1. Check for &mkp and mouse.h
    if "&mkp" in content and "#include <dt-bindings/zmk/mouse.h>" not in content:
        errors.append("Error: Mouse key behavior (&mkp) detected but <dt-bindings/zmk/mouse.h> is not included.")

    # 2. Check for &zip and processors.dtsi
    if "&zip" in content and "#include <input/processors.dtsi>" not in content:
        errors.append("Error: Input processor (&zip) detected but <input/processors.dtsi> is not included.")

    # 3. Check for zip_xy_scaler missing comma (specific to dtsi)
    if filepath.endswith('.dtsi'):
        # Check zip_x_scaler ... zip_y_scaler without comma
        if re.search(r'&zip_x_scaler\s+\d+\s+\d+\s+&zip_y_scaler', content):
            errors.append("Error: Missing comma between &zip_x_scaler and &zip_y_scaler.")

    if errors:
        for err in errors:
            print(err)
        return False
    
    print("No issues found.")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python lint_zmk.py <file1> <file2> ...")
        sys.exit(1)
    
    all_pass = True
    for arg in sys.argv[1:]:
        if not lint_file(arg):
            all_pass = False
            
    if not all_pass:
        sys.exit(1)
