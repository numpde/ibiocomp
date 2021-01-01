# RA, 2020-12-27

"""
What are the subtractor gates?
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
)

inputs = list(f.columns)

f = f.assign(d1=(f.c1 == (f.s1 == f.r1)))
f = f.assign(c2=((f.r1 & ~f.s1) | (f.c1 & ~f.s1) | (f.r1 & f.c1)))
f = f.assign(C3=[0, 0, 0, 0, 1, 1, 1, 0])  # player

f = f.sort_values(by=['c1', 'r1', 's1'], ascending=False, ignore_index=True).astype(int)
assert (hex(np.dot(f.C3, 2 ** f.index)) == "0x0E")

f = f.assign(not_c1=(1 - f.c1))
f = f.assign(not_r1=(1 - f.r1))
f = f.assign(not_s1=(1 - f.s1))

f = f.assign(not_d1=(1 - f.d1))
f = f.assign(not_c2=(1 - f.c2))

for ii in permutations(['c1', 'r1', 's1']):
    f = f.sort_values(by=list(ii), ascending=False, ignore_index=True)
    print("    d1:", list(reversed(f.d1)), hex(np.dot(f.d1, 2 ** f.index)))
    print("not_d1:", list(reversed(f.not_d1)), hex(np.dot(f.not_d1, 2 ** f.index)))
    print("    c2:", list(reversed(f.c2)), hex(np.dot(f.c2, 2 ** f.index)))
    print("not_c2:", list(reversed(f.not_c2)), hex(np.dot(f.not_c2, 2 ** f.index)))
    # e.g. not_c2: [1, 1, 1, 0, 1, 0, 0, 0] 0xE8
    print()
