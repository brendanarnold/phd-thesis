'''
Remove annoying quotes from titles
Remove unnecessary fields from entries
'''
import os

IN_FN = os.path.join('Bibliography', 'library.bib')
OUT_FN = os.path.join('Bibliography', 'processed-library.bib')
FIELDS = {
    'book': ('author', 'isbn', 'pages', 'publisher', 'title', 'year'),
    'article': ('author', 'journal', 'volume', 'doi', 'pages', 'publisher', 'year', 'eprint'),
    'phdthesis': ('author', 'title', 'school', 'year'),
    'incollection': ('author', 'booktitle', 'isbn', 'pages', 'publisher', 'title', 'year'),
}



in_fh = open(IN_FN, 'r')
out_fh = open(OUT_FN, 'w')
    
# Split into entries
entries = []
entry = ''
in_entry = False
for line in in_fh:
    if line.startswith('@'):
        entry_type = line.split('{')[0][1:]
        if not FIELDS.has_key(entry_type):
            print entry_type
        else:
            out_fh.write(line)
            in_entry = True
    if line.startswith('}'):
        if in_entry:
            out_fh.write(line)
        in_entry = False
        entry = ''
    if in_entry and not line.startswith('@') and line.strip():
        field = line.split('=')[0].strip()
        # Strip out the title extra brackets
        if field == 'title':
            value = '='.join(line.split('=')[1:]).strip().strip(',')
            value = value[1:-1]
            line = '%s = %s,\n' % (field, value)
        if field in FIELDS[entry_type]:
            out_fh.write(line)


in_fh.close()
out_fh.close()
