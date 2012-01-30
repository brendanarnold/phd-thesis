IN_FILENAME = r'compiled_data.dat'
OUT_FILENAME = r'mass_data.tex'



with open(OUT_FILENAME, 'w') as out_fh:
    with open(IN_FILENAME, 'r') as fh:
        fh.readline()
        for line in fh:    
            tex_line = ''
            for i, val in enumerate([val.strip() for val in line.split('\t')]):
                suffix = '\t& '
                prefix = ''
                if i in [3,7,8,9,10]:
                    prefix = '\\cellcolor[gray]{0.9} '
                if i == 14:
                    suffix = ' \\\\\n'
                tex_line = tex_line + prefix + val + suffix
            out_fh.write(tex_line)            
