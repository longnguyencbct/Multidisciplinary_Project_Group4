#!/bin/bash

# Run the setup.py script
echo "Running setup.py..."
cd /app/Demo_CS
python setup.py build_ext --inplace
echo "setup.py completed."