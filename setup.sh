#!/bin/bash

# Remove previous .so files
echo "Removing previous .so files..."
find /app/Demo_CS -name '*.so' -exec rm -f {} \;
find /app/Demo_CE/Topics/shared -name '*.so' -exec rm -f {} \;
echo "Previous .so files removed."

# Run the setup.py script
echo "Running setup.py..."
cd /app/Demo_CS
python setup.py build_ext --inplace
echo "setup.py completed."