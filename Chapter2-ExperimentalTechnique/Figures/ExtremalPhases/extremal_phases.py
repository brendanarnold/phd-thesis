

RES = 2000

# SCALE = 2
# SCALE = 20
SCALE = 200
# SCALE = 2000

# Wavelength has nothing to do with the scale
LAMBDA = 1



from pylab import *

x = linspace(0, 5*pi, RES)

for lim in [0, pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4, 2*pi]:
    phis = linspace(0, SCALE*pi + lim, RES)
    s = zeros(RES)
    for p in phis:
        s = s + cos(x/LAMBDA + p)
    plot(x/pi, s, label='%.2f pi' % (lim/pi))

phis = (SCALE+1)*(linspace(0, 2, RES) - 1)**2
s = zeros(RES)
for p in phis:
    s = s + cos(x/LAMBDA + p)
plot(x/pi, s, label='Turning point')
legend()
show()
