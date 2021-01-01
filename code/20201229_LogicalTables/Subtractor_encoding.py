# RA, 2020-12-31

"""
Hex representation of a 3-input binary function.
"""

import numpy as np
import pandas as pd
from itertools import permutations

hex = (lambda x: "0x" + F"{x:02x}".upper())

f = pd.DataFrame(
    {
        'c1': [0, 0, 0, 0, 1, 1, 1, 1],
        'r1': [0, 0, 1, 1, 0, 0, 1, 1],
        's1': [0, 1, 0, 1, 0, 1, 0, 1],
    }
).astype(bool)

inputs = list(f.columns)

f = f.assign(d1=(f.c1 == (f.s1 == f.r1)))
f = f.assign(c2=((f.r1 & ~f.s1) | (f.c1 & ~f.s1) | (f.r1 & f.c1)))

f = f.sort_values(by=inputs, ascending=False, ignore_index=True).astype(int)


def p(c, negate=False):
    if negate:
        print(F"not {c}:", list(reversed(1 - f[c])), hex(np.dot((1 - f[c]), 2 ** f.index)))
    else:
        print(F"    {c}:", list(reversed(f[c])), hex(np.dot(f[c], 2 ** f.index)))


for ii in permutations(inputs):
    f = f.sort_values(by=list(ii), ascending=False, ignore_index=True)
    print("Output:")
    p("d1")
    p("d1", negate=True)
    p("c2")
    p("c2", negate=True)
    print("Input:")
    for i in reversed(ii):
        p(i)
    print()
    print()
