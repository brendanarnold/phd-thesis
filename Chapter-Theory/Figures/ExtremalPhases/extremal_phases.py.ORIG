

RES = 1000

SCALES = [1, 10, 100]
TICKS = iter([(0, 5, 10), (0, 20, 40), (0, 150, 300), (0, 300)])
YLIMS = iter([(0, 10), (0, 40), (0, 330), (-200, 400)])

# Wavelength has nothing to do with the scale
LAMBDA = 1

from pylab import *

rc('font', family='serif')
rc('figure', facecolor='white');

x = linspace(0, 5*pi, RES)

for scale in SCALES:

    main = figure(figsize=(6,4))
    ax = axes()

    inset = figure(figsize=(3.3,2))
    ax_inset = axes()
    ax_inset.yaxis.set_ticks(next(TICKS))
    ax_inset.set_ylim(next(YLIMS))

    # Endpoints matter for the linear terms, have a range of endpoints up to
    # 2pi
    lims = linspace(0, 2*pi, 9)

    for lim in lims:
        phis = linspace(0, scale*pi + lim, RES)
        s = zeros(RES)
        for p in phis:
            s = s + cos(x/LAMBDA + p)
        s = s * 1e-3
        ax.plot(x/pi, s, label='%.2f pi' % (lim/pi), linestyle='-', color='k')
        ax_inset.plot(x/pi, phis, linestyle='-', color='k')

    phis1 = (scale+2)*pi*linspace(-1, 1, RES)**2
    s = zeros(RES)
    for p in phis1:
        s = s + cos(x/LAMBDA + p)
    s2 = s * 1e-3
    ax.plot(x/pi, s2, label='Turning point', linestyle='--', color='k')
    ax_inset.plot(x/pi, phis1, linestyle='--', color='k')
    ax_inset.xaxis.set_ticklabels([])
    # Save the figures
    main.savefig('main_SCALE=%.1f.png' % scale, format='png', transparent=True)
    inset.savefig('inset_SCALE=%.1f.png' % scale, format='png', transparent=True)
    # show()

main = figure(figsize=(6,4))
ax = axes()

inset = figure(figsize=(3.3,2))
ax_inset = axes()
ax_inset.yaxis.set_ticks(next(TICKS))
ax_inset.set_ylim(next(YLIMS))
ax_inset.xaxis.set_ticklabels([])

ax.plot(x/pi, s2, linestyle='--', color='k')
ax_inset.plot(x/pi, phis1, linestyle='--', color='k')

# phis2 = 0.25*(scale+1)*linspace(-1, 1, RES) + 0.25*(scale+1)*linspace(-1, 1, RES)**3
phis2 = 0.5*(scale+2)*pi*linspace(-1, 1, RES)**3
s = zeros(RES)
for p in phis2:
    s = s + cos(x/LAMBDA + p)
s1 = s * 1e-3
ax.plot(x/pi, s1, label='x^3 + x', linestyle=':', color='k')
ax_inset.plot(x/pi, phis2, linestyle=':', color='k')

main.savefig('main_order3_SCALE=%.1f.png' % scale, format='png', transparent=True)
inset.savefig('inset_order3_SCALE=%.1f.png' % scale, format='png', transparent=True)

# legend()
show()
