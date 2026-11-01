from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy
import os

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

extensions = [
    Extension(
        "wrapper",
        ["wrapper.pyx"],
        include_dirs=[
            "../include/",
            "../src/",
            numpy.get_include()
        ],
        language='c++',
    )
]

setup(
    ext_modules=cythonize(extensions, language_level=3),
    script_args=['build_ext'],
    options={
        'build_ext': {
            'build_lib': os.path.join(PROJECT_DIR, 'bin'),
            'build_temp': os.path.join(PROJECT_DIR, 'cython/cython_build')
        }
    }
)
