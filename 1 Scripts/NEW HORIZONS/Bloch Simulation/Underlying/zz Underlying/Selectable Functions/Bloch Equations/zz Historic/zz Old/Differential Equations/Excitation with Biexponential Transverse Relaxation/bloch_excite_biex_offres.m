function dM = bloch_excite_biex_offres(t,M,flag,T1,T2S,T2F,w1,wd)

% w1 & wd = rad/msec

M0 = 100;
dM = zeros(5,1);				

dM(1) = (-w1 * (M(4) + M(5))) + (M0 - M(1))/T1;                         % M(1) = z
dM(2) = (0.4 * wd * (M(4) + M(5))) - M(2)/T2S;                          % M(2 & 3) = x
dM(3) = (0.6 * wd * (M(4) + M(5))) - M(3)/T2F;                    
dM(4) = (0.4 * -wd * (M(2) + M(3))) + (0.4 * w1 * M(1)) - M(4)/T2S;     % M(4 & 5) = y				
dM(5) = (0.6 * -wd * (M(2) + M(3))) + (0.6 * w1 * M(1)) - M(5)/T2F;





