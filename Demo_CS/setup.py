from setuptools import setup, Extension
import pybind11
from distutils.sysconfig import get_python_inc
import shutil
from pathlib import Path

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

setup(
    name='sprintz_encoder',
    version='0.0.1',
    author='Your Name',
    author_email='your.email@example.com',
    description='Sprintz encoding module',
    ext_modules=ext_modules,
)

# Post-build step to copy the .so file to the shared directory
def copy_so_file():
    base_path = Path(__file__).resolve().parent
    so_file = next(base_path.glob('*.so'))
    shared_dir = base_path / '../Demo_CE/Topics/shared'
    shared_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy(so_file, shared_dir / so_file.name)

copy_so_file()