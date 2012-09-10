
from pylab import *

# All below in angstroms
H_BAR = 1.045457e-14
EL_CHARGE = 1.602176e-19
A_CONV = H_BAR / (2 * pi * EL_CHARGE)

# 0.03 at 5T 0.025, 0.1 at 15T 0.025, 0.07 at 20T 0.05
# RES = 50000
# PLOT_PTS = 5000

RES = 25000
PLOT_PTS = 5000

SCALES = [0.005, 0.0075, 0.01, 0.025, 0.05]
TICKS = iter([(0, 0.005), (0, 0.0075), (0, 0.01), (0, 0.025), (0, 0.05)])
YLIMS = iter([(0, 0.005), (0, 0.0075), (0, 0.01), (0, 0.025), (0, 0.05)])
# MAIN_TICKS = iter([(0, 0.005), (0, 0.0075), (0, 0.01), (0, 0.025), (0, 0.05)])
# MAIN_YLIMS = iter([(0, 0.005), (0, 0.0075), (0, 0.01), (0, 0.025), (0, 0.05)])

LAMBDA = 1

PLOT_RECIP = False

MAX_FIELD = 25

rc('font', family='serif')
rc('figure', facecolor='white');

if PLOT_RECIP:
    b = linspace(1e3, 1.0/MAX_FIELD, PLOT_PTS)
    b = 1.0 / b
else:
    b = linspace(1e-3, MAX_FIELD, PLOT_PTS)
    # b = linspace(1000, 1030, PLOT_PTS)


for scale in SCALES:

    main = figure(figsize=(6,4))
    ax = axes()
    # ax.yaxis.set_ticks(next(MAIN_TICKS))
    # ax.set_ylim(next(MAIN_YLIMS))

    inset = figure(figsize=(3.3,2))
    ax_inset = axes()
    ax_inset.yaxis.set_ticks(next(TICKS))
    ax_inset.set_ylim(next(YLIMS))

    # Endpoints matter for the linear terms, have a range of endpoints up to
    # 2pi
    lims = linspace(0, 2*pi, 1)

    for lim in lims:
        # phis = 0.7+linspace(0, 0, RES)
        phis = linspace(0, scale + lim, RES)
        s = zeros(PLOT_PTS)
        for r in phis:
            F = A_CONV * pi * r * r
            s = s + cos(2 * pi * F / (b * LAMBDA))
        s = s / float(RES)
        if PLOT_RECIP:
            ax.plot(1.0/b, s, label='%.2f pi' % (lim/pi), linestyle='--', color='k')
        else:
            ax.plot(b, s, label='%.2f pi' % (lim/pi), linestyle='--', color='k')
        ax_inset.plot(arange(0, RES), phis, linestyle='--', color='k')

    phis1 = scale - scale * linspace(-1, 1, RES)**2
    s = zeros(PLOT_PTS)
    for r in phis1:
        F = A_CONV * pi * r * r
        s = s + cos(2 * pi * F / (b * LAMBDA))
    s2 = s / float(RES)
    if PLOT_RECIP:
        ax.plot(1.0/b, s2, label='Turning point', linestyle='-', color='k')
    else:
        ax.plot(b, s2, label='Turning point', linestyle='-', color='k')
    ax_inset.plot(arange(0, RES), phis1, linestyle='-', color='k')
    ax_inset.xaxis.set_ticklabels([])
    ax_inset.yaxis.set_ticklabels([])
    # Save the figures
    main.savefig('main_SCALE=%.4f.png' % scale, format='png', transparent=True)
    inset.savefig('inset_SCALE=%.4f.png' % scale, format='png', transparent=True)
    ## show()

# main = figure(figsize=(6,4))
# ax = axes()
# 
# inset = figure(figsize=(3.3,2))
# ax_inset = axes()
# ax_inset.yaxis.set_ticks(next(TICKS))
# ax_inset.set_ylim(next(YLIMS))
# ax_inset.xaxis.set_ticklabels([])
# 
# ax.plot(b/pi, s2, linestyle='-', color='k')
# ax_inset.plot(b/pi, phis1, linestyle='-', color='k')

## phis2 = 0.25*(scale+1)*linspace(-1, 1, RES) + 0.25*(scale+1)*linspace(-1, 1, RES)**3
# phis2 = 0.5*(scale+2)*pi*linspace(-1, 1, RES)**3
# s = zeros(RES)
# for p in phis2:
#     s = s + cos(b/LAMBDA + p)
# s1 = s * 1e-3
# ax.plot(b/pi, s1, label='b^3 + b', linestyle=':', color='k')
# ax_inset.plot(b/pi, phis2, linestyle=':', color='k')
# 
# main.savefig('main_order3_SCALE=%.1f.png' % scale, format='png', transparent=True)
# inset.savefig('inset_order3_SCALE=%.1f.png' % scale, format='png', transparent=True)

# legend()
show()
