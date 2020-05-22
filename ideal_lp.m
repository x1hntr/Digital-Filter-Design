function hd = ideal_lp(wc,M);
alpha = (M-1)/2; n = [0:1:(M-1)];
m=n- alpha; fc = wc/pi; hd = fc*sinc(fc*m);