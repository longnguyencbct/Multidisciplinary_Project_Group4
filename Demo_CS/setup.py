from setuptools import setup, Extension
import pybind11
from distutils.sysconfig import get_python_inc

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
        extra_compile_args=['-std=c++11'],
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
