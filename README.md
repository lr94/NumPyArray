# ReadNumPy

ReadNumPy is a package that allows to read NPY files using Mathematica.
So far it supports only numeric data types, NPY version 1.0 and it does not support arrays stored in Fortran order (i.e. column major order).
However I'm planning to add support for NPY 2.0.

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
