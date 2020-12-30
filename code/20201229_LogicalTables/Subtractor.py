# RA, 2020-12-29


import numpy as np
import pandas as pd

from numpy import logical_xor as XOR
from numpy import logical_and as AND
from numpy import logical_or as OR

### BIT 0

f = pd.DataFrame(
    {
        's0': [0, 0, 1, 1],
        'r0': [0, 1, 0, 1],
    }
)

inputs = list(f.columns)

# d0 = (r0 && not(s0)) || (not(r0) && s0)
f = f.assign(d0=XOR(f.r0, ~f.s0))
# c1 = (r0 && not(s0))
f = f.assign(c1=AND(f.r0, ~f.s0))

f = f.sort_values(by=inputs, ascending=True, ignore_index=True).astype(int)

f.columns = [F"\\cee{{{c[0]}_{c[1]}}}" for c in f.columns]

print(f.to_latex(column_format="cc|cc", index=False, escape=False))

### BIT 1

f = pd.DataFrame(
    {
        's1': [0, 0, 0, 0, 1, 1, 1, 1],
        'r1': [0, 0, 1, 1, 0, 0, 1, 1],
        'c1': [0, 1, 0, 1, 0, 1, 0, 1],
    }
)

inputs = list(f.columns)

# d1 = (r1 && not(s1) && not(c1)) || (not(r1) && s1 && not(c1)) || (r1 && s1 && c1) || (not(r1) && not(s1) && c1)
f = f.assign(d1=((f.r1 & ~f.s1 & ~f.c1) | (~f.r1 & f.s1 & ~f.c1) | (f.r1 & f.s1 & f.c1) | (~f.r1 & ~f.s1 & f.c1)))
# c2 = (r1 && not(s1)) || (c1 && not(s1)) || (r1 && c1)
f = f.assign(c2=((f.r1 & ~f.s1) | (f.c1 & ~f.s1) | (f.r1 & f.c1)))

f = f.sort_values(by=inputs, ascending=True, ignore_index=True).astype(int)

f.columns = [F"\\cee{{{c[0]}_{c[1]}}}" for c in f.columns]

print(f.to_latex(column_format="ccc|cc", index=False, escape=False))

### BIT 2

f = pd.DataFrame(
    {
        's2': [0, 0, 1, 1],
        'c2': [0, 1, 0, 1],
    }
)

inputs = list(f.columns)

# d2 = (c2 && not(s2)) || (not(c2) && s2)
f = f.assign(d2=XOR(f.c2, ~f.s2))
# c3 = (c2 && not(s2))
f = f.assign(c3=AND(f.c2, ~f.s2))

f = f.sort_values(by=inputs, ascending=True, ignore_index=True).astype(int)

f.columns = [F"\\cee{{{c[0]}_{c[1]}}}" for c in f.columns]

print(f.to_latex(column_format="cc|cc", index=False, escape=False))
