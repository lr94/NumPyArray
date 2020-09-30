# Read NumPy
NumPy is a package that allows to read NPY files using Mathematica.
So far it supports only numeric data types, NPY version 1.0 and it does not support arrays stored in Fortran order (i.e. column major order).
However I'm planning to add support for NPY 2.0.

NumPy is a python library used for working with arrays.
It also has functions for working in domain of linear algebra, fourier transform, and matrices.
NumPy was created in 2005 by Travis Oliphant. It is an open source project and you can use it freely.
NumPy stands for Numerical Python.
In Python we have lists that serve the purpose of arrays, but they are slow to process.
The array object in NumPy is called ndarray, it provides a lot of supporting functions that make working with ndarray very easy.
Arrays are very frequently used in data science, where speed and resources are very important.
NumPy arrays are stored at one continuous place in memory unlike lists, so processes can access and manipulate them very efficiently.
This behavior is called locality of reference in computer science.
This is the main reason why NumPy is faster than lists. Also it is optimized to work with latest CPU architectures.


### Usage

Python:

    >>> import numpy as np
    >>> arr = np.random.random((2, 3, 2))
    >>> np.save('arr.npy', arr)
    >>> arr
    >>> array([[[0.56722277, 0.47052153],
                [0.27949656, 0.02174664],
                [0.01491723, 0.46984945]],

               [[0.18369629, 0.23657315],
                [0.00243881, 0.80721822],
                [0.56594514, 0.94332137]]])

Mathematica:

     In[1]:= << NumPyArray`
     In[2]:= ReadNumPyArray["arr.npy"]
    Out[2]:= {{{0.567223, 0.470522}, {0.279497, 0.0217466}, {0.0149172, 0.469849}}, {{0.183696, 0.236573}, {0.00243881, 0.807218}, {0.565945, 0.943321}}}
