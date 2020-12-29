# RA, 2020-12-29


import pandas as pd

hex = (lambda x: "0x" + F"{x:02x}".upper())

f = pd.DataFrame(
    {
        'wA': [0, 0, 0, 0, 1, 1, 1, 1],
        's1': [0, 0, 1, 1, 0, 0, 1, 1],
        's0': [0, 1, 0, 1, 0, 1, 0, 1],
    }
)

inputs = list(f.columns)

f = f.assign(r1=(f.wA & ~(f.s1 ^ f.s0)))
f = f.assign(r0=(f.wA & ~(f.s1 & f.s0)))

f = f.sort_values(by=list(f.columns[0:3]), ascending=True, ignore_index=True).astype(int)

f.columns = [F"\\cee{{{c[0]}_{c[1]}}}" for c in f.columns]

print(f.to_latex(column_format="ccc|cc", index=False, escape=False))
