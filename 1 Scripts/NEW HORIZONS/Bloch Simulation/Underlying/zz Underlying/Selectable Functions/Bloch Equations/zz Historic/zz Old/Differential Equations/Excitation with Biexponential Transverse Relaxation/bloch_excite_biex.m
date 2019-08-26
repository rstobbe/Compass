function dM = bloch_excite_biex(t,M,flag,T1,T2S,T2F,w)

M0 = 100;
dM = zeros(3,1);				

dM(1) = (-w * (M(2) + M(3))) + (M0 - M(1))/T1;
dM(2) = (0.4 * w * M(1)) - M(2)/T2S;
dM(3) = (0.6 * w * M(1)) - M(3)/T2F;









