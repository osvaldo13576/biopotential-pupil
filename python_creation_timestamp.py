import time
import os
import numpy as np
from numpy import savetxt
path = r"C:\Users\HP\Documents\c3 data\SANTIAGO_ID_0000009\eeg_tarea\0000009.eeg"
ti_m = os.path.getctime(path)
factor_correccion = 0.21
ti_m = ti_m - factor_correccion
os.chdir(r"C:\Users\HP\Documents\c3 data\SANTIAGO_ID_0000009\eeg_tarea")
print(ti_m)
savetxt('eeg_timestamp.txt',np.array([ti_m]),fmt='%1.7f')