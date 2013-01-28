
from pylab import *

KF = 1.


def fe1d(q):
    c = q / (2*KF)
    v = KF/(2*q) * log(((c + 1)/(c - 1))**2)
    # -e**2 D
    return v

def fe2d(q):
    # -e**2 D
    q1 = q[q <= 2*KF]
    v1 = q1 * 0.0 + 1.0 
    # -e**2 D
    q2 = q[q > 2*KF]
    # Extra factor 2 in the second term, makes the plot look more
    # correct but not in the function form given by Dressel
    v2 = 1 - 2*KF/q2 * sqrt( (q2/(2*KF))**2 - 1)
    return concatenate((v1, v2))

def fe3d(q):
    v = 0.5 * (1 + (KF/q - q / (4. * KF)) * log(fabs((q + 2*KF) / (q - 2*KF))))
    # -e**2 D 
    return v

q = linspace(1e-5, 4*KF, 2000)

v1d = fe1d(q)
v2d = fe2d(q)
v3d = fe3d(q)

data = column_stack((q, v1d, v2d, v3d))
savetxt("data.dat", data, delimiter="\t")


plot(q, v1d)
plot(q, v2d)
plot(q, v3d)
show()
