import os

with open('todo.txt', 'w') as out_fh:    
    for path, dirnames, fns in os.walk('.'):
        for fn in fns:
            if not fn.endswith('.tex'):
                continue
            fpath = os.path.join(path, fn)
            with open(fpath, 'r') as fh:
                file_line = '\n\nFile: ' + fpath + '\n\n'
                line_num = 0
                for line in fh:
                    line_num += 1
                    if 'TODO' not in line:
                        continue
                    if file_line is not None:                        
                        out_fh.write(file_line)
                        file_line = None
                    out_fh.write('Line: %d\n%s\n'  % (line_num, line))
print 'Done'
                    
                
                    
            
    
