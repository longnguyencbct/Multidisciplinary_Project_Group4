#!/bin/sh

# Compile the .so file
python setup.py build_ext --inplace

# Copy the .so file to the shared directory
cp sprintz_encoder*.so /shared/