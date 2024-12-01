from setuptools import setup, Extension
import pybind11
from distutils.sysconfig import get_python_inc
import shutil
from pathlib import Path
import os
import time

# Get the include path from pybind11
include_dirs = [
    pybind11.get_include(),        # Main include path for pybind11
    pybind11.get_include(user=True),  # User-specific include path for pybind11
    get_python_inc()  # Python include path
]

ext_modules = [
    Extension(
        'sprintz_encoder',
        ['string.cpp'],
        include_dirs=include_dirs,
        language='c++',
        extra_compile_args=['-std=c++11', '-static-libstdc++'],
    ),
]

# Function to remove previous .so files
def remove_previous_so_files():
    base_path = Path(__file__).resolve().parent
    shared_dir = base_path / '../Demo_CE/Topics/shared'
    
    # Remove .so files in /Demo_CS
    for so_file in base_path.glob('*.so'):
        try:
            os.remove(so_file)
            print(f"Removed {so_file}")
        except OSError as e:
            print(f"Error removing {so_file}: {e}")

    # Remove .so files in /Demo_CE/Topics/shared
    for so_file in shared_dir.glob('*.so'):
        try:
            os.remove(so_file)
            print(f"Removed {so_file}")
        except OSError as e:
            print(f"Error removing {so_file}: {e}")

# Function to copy the .so file to the shared directory
def copy_so_file():
    base_path = Path(__file__).resolve().parent
    shared_dir = base_path / '../Demo_CE/Topics/shared'
    shared_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        so_file = next(base_path.glob('*.so'))
        shutil.copy(so_file, shared_dir / so_file.name)
        print(f"Copied {so_file} to {shared_dir / so_file.name}")
    except StopIteration:
        print("No .so file found to copy.")

# Remove previous .so files before building
remove_previous_so_files()

# Wait for 5 seconds before proceeding
# time.sleep(5)

setup(
    name='sprintz_encoder',
    version='0.0.1',
    author='Your Name',
    author_email='your.email@example.com',
    description='Sprintz encoding module',
    ext_modules=ext_modules,
)

# Post-build step to copy the .so file to the shared directory
copy_so_file()