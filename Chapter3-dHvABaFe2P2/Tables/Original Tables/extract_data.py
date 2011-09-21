
IN_FILENAME = 'tmp3.dat'
OUT_FILENAME = 'raw3.dat'

all_vals = []
with open(IN_FILENAME, 'r') as fh:
    for line in fh:
        vals = [val.strip().replace('\\', '') for val in line.split('&')]
        all_vals.append(vals)

with open(OUT_FILENAME, 'w') as fh:
    # fh.write('Angle\tFreq\tLabel\tm*\tm*_retro\talpha\tField lim\n')
    # fh.write('Angle\tFreq\tLabel\tField max\tField min\tm*_micro mean\tm*_micro std\tFilt. width\n')
    fh.write('Angle\tFreq\tLabel\tm_b\tm*/m_b\tm*_retro/m_b\tm*_micro/m_b\n')
    for vals in all_vals:
        line = '\t'.join(vals) + '\n'
        fh.write(line)
