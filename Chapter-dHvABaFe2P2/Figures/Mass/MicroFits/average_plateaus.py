# -*- coding: utf-8 -*-
"""
Created on Wed Jul 13 12:26:31 2011

@author: ba1224
"""

from pylab import *
import os
import re

FILESTEM = r'Peak_f=(\d+)_(\d+)deg_([^_]+)_lkfits.dat'
OUT_FILENAME = r'AverageMicroFits.dat'
LIMITS = {}
LIMITS['alpha1'] = {
    '12' : (11, 17),
    '28' : (11, 17),
    '46' : (9, 17) 
}
LIMITS['alpha2'] = {
    '12' : (8, 17),
    '28' : (8, 17),
    '46' : (10.5, 16.8)
}
LIMITS['alpha3'] = {
    '28' : (9.5, 17),
    '46' : (10.7, 17)
}
LIMITS['beta1'] = {
    '12' : (8, 17),
}
LIMITS['beta2'] = {
    '12' : (9, 17),
    '28' : (8.5, 17),
    '46' : (10, 17.3) # Two peaks share same limit
}
LIMITS['beta3'] = {
    '28' : (8, 17),
    '46' : (8.5, 17)
}
LIMITS['delta'] = {
    '12' : (12, 17),
    '46' :  (10.5, 17)
}
LIMITS['gamma1'] = {
    '28' : (11.3, 16.8),
    '46' : (11.3, 16.8)
}
LIMITS['gamma2'] = {
    '46' : (12.2 , 16.8)
}


out_fh = open(OUT_FILENAME, 'w')
out_fh.write('Angle\tFreq\tSheet\tUpper\tLower\tAverage\tStdev\n')
for fn in os.listdir('.'):
    result = re.match(FILESTEM, fn)
    if not result:
        continue
    freq = result.group(1)
    angle = result.group(2)
    sheet = result.group(3)
    upper_limit = max(LIMITS[sheet][angle])
    lower_limit = min(LIMITS[sheet][angle])
    B, m_star, amp = np.loadtxt(fn, skiprows=1, delimiter='\t', unpack=True)
    mask = (B > lower_limit) & (B < upper_limit)
    m_star = m_star[mask]
    B = B[mask]
    out_fh.write('\t'.join([angle, freq, sheet, str(upper_limit), str(lower_limit), str(m_star.mean()), str(m_star.std())]) + '\n')
print 'Written to ' + OUT_FILENAME
out_fh.close()
    
