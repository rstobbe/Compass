function dM = bloch_excite_sex_offres(t,M,flag,T1,T2,w1,wd)

% w1 & wd = rad/msec

M0 = 100;
dM = zeros(3,1);				

dM(1) = (-w1 * M(3)) + (M0 - M(1))/T1;                  % M(1) = z
dM(2) = (wd * M(3)) - M(2)/T2;                          % M(2) = x
dM(3) = (-wd * M(2)) + (w1 * M(1)) - M(3)/T2;           % M(3) = y



