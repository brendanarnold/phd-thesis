'''
Reads in peak values copied from the FFT program and performs a least
squares fit on them using an averaged 1/B field.

Then permutes the temperature values using a standard normal
distribution (i.e. mean=0 and stdev=1) * estimated error + t value
'''
import os
import re
from pylab import *
from scipy.optimize import leastsq

BASE_DIR = r'12deg'
SKIP_RUNS = []

## BASE_DIR = r'28deg'
## SKIP_RUNS = []

## BASE_DIR = r'46deg'
## SKIP_RUNS = [31, 32, 33, 34, 35]

INPUT_FILESTEM = r'Peak_(\d+)_B=([\d,]+)-([\d,]+)T\.dat'
FILE_DIR = r'Analysis\QuickFits'
OUT_FILE = r'quick_fit_angle_data.dat'
P0 = [1e-2, 1.4]
SAMPLES = 1000
T_ERR = 0.06

def lk(p, t, mean_b):
    return p[0] * (14.693 * p[1] * t / mean_b) / np.sinh(14.693 * p[1] * t / mean_b)

def err_fn(p, t, famp, mean_b):
    return famp - lk(p, t, mean_b)

def main():
    angle = int(BASE_DIR[:2])
    angle_data = []
    for filename in os.listdir(BASE_DIR):
        result = re.match(INPUT_FILESTEM, filename)
        if result:
            freq = int(result.group(1))
            min_b = float(result.group(2).replace(',', '.'))
            max_b = float(result.group(3).replace(',', '.'))
            mean_b = 2 / (1 / min_b + 1 / max_b)
    ##         mean_b = (min_b + max_b) / 2.0
            # File columns: Run, Freq, Amp, Truox, Tcx
            data = np.loadtxt(os.path.join(BASE_DIR, filename), delimiter='\t', skiprows=1)
            # Mask out zero temperature values
            data = data[data[:,3] != 0.0,:]
            # Mask out runs that are to be skipped
            data = data[~np.in1d(data[:,0], SKIP_RUNS),:]
            truox = data[:,3]
            famps = data[:,2]
            # Fit data to LK
            p, success = leastsq(err_fn, P0[:], args=(truox, famps, mean_b))
            fit_t = np.linspace(1e-3, 2, 100)
            fit_famps = lk(p, fit_t, mean_b)
            m1 = p[0]
            mfit = p[1]
            print 'Mass: %.4f' % p[1]
            # Randomly adjust temperature data within stdev and find the
            # variance in the result
            # For the moment assume uniform error in temperature
            std_truox = np.ones_like(truox) * T_ERR
            avg_t_data = np.random.standard_normal(size=(SAMPLES, len(truox))) * std_truox + truox
            m2_vals = []
            for t_vals in avg_t_data:
                p, success = leastsq(err_fn, P0[:], args=(t_vals, famps, mean_b))
                m2_vals.append(p[1])
            m2_vals = np.abs(m2_vals)
            m2_std = m2_vals.std()
            # Plot result
            figure()
            text(0.5, fit_famps.max(), 'y = m1*(14.693*m2*x/%.3f) / sinh(14.693*m2*x/%.3f)\n  m1 = %.3f\n  m2 = %.3f (%.4f)' % (mean_b, mean_b, m1, mfit, m2_std), va='top')
            title(filename)
            scatter(data[:,3], data[:,2])
            plot(fit_t, fit_famps, c='red')
            savefig(os.path.join(BASE_DIR, FILE_DIR, filename[:-3] + 'png'))
            angle_data.append([angle, min_b, max_b, mean_b, mfit, m2_std, freq])
    fh = open(os.path.join(BASE_DIR, FILE_DIR, OUT_FILE), 'w')
    fh.write('Angle\tBmin\tBmax\tBmean\tm* fit\terr m* fit\tFreq\n')
    np.savetxt(fh, angle_data, delimiter='\t')
    fh.close()
    show()

if __name__ == '__main__':
    main()    
