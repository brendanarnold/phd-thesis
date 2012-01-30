import os
import re
from pylab import *
from scipy.optimize import leastsq

IN_FILESTEM = r'Peak_(\d+)_(\d+)deg_B=([\d,]+)-([\d,]+)T\.dat'
OUT_FILENAME = r'lk_fit_table.tex'
DIRS = ['alpha1', 'diff_fields_alpha1', 'alpha2', 'alpha3', 'beta1', 'beta2', 'diff_fields_beta2', 'beta3', 'gamma1', 'gamma2', 'delta1']
P0 = [1e-2, 1.4]
T_ERR = 0.06
SAMPLES = 1000
LATEX_LABELS = {
    'alpha1' : '$\\alpha_1$',
    'diff_fields_alpha1' : '$\\alpha_1$',
    'alpha2' : '$\\alpha_2$',
    'alpha3' : '$\\alpha_3$',
    'beta1' : '$\\beta_1$',
    'diff_fields_beta2' : '$\\beta_2$',
    'beta2' : '$\\beta_2$',
    'beta3' : '$\\beta_3$',
    'gamma1' : '$\\gamma_1$',
    'gamma2' : '$\\gamma_2$',
    'delta1' : '$\\delta_1$'
}
SKIP_46_RUNS = [31, 32, 33, 34, 35]

def lk(p, t, mean_b):
    return p[0] * (14.693 * p[1] * t / mean_b) / np.sinh(14.693 * p[1] * t / mean_b)

def err_fn(p, t, famp, mean_b):
    return famp - lk(p, t, mean_b)


out_data = []
for d in DIRS:
    for fn in os.listdir(d):
        result = re.match(IN_FILESTEM, fn)
        fn = os.path.join(d, fn)
        if not result:
            continue
            print 'Skipping: ' + fn
        print fn
        angle = result.group(2)
        data = np.loadtxt(fn, delimiter='\t', skiprows=1)
        # Mask out zero temperature values
        data = data[data[:,3] != 0.0,:]
        if angle == '46':
            # Mask out runs that are to be skipped
            data = data[~np.in1d(data[:,0], SKIP_46_RUNS),:]
        x = data[:,3]
        y = data[:,2]
        freq = result.group(1)

        min_b = float(result.group(3).replace(',', '.'))
        max_b = float(result.group(4).replace(',', '.'))
        label = LATEX_LABELS[d]
        mean_b = 2 / (1 / min_b + 1 / max_b)
        print 'Mean B: %.3f' % mean_b
        p, success = leastsq(err_fn, P0[:], args=(x, y, mean_b))
        m_star = abs(p[1])
        m_amp = p[0]
        # Randomly adjust temperature data within stdev and find the
        # variance in the result
        # For the moment assume uniform error in temperature
        avg_t_data = np.random.standard_normal(size=(SAMPLES, len(x))) * T_ERR + x
        m_star_vals = []
        for t_vals in avg_t_data:
            p, success = leastsq(err_fn, P0[:], args=(t_vals, y, mean_b))
            m_star_vals.append(p[1])
        m_star_std = np.abs(m_star_vals).std()
        out_data.append([angle, freq, label, str(m_star), str(m_star_std), str(min_b)])

fh = open(OUT_FILENAME, 'w')
fh.write('Angle\t& dHvA Freq.\t& Label\t& m_star\t & stdv m_star\t & Lower Field Limit\n')
for line in out_data:
    fh.write('\t & '.join(line) + '\\\\\n')
fh.close()
print 'Done.'
        
