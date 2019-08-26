

function dM = bloch_biex_rekax(t,M,flag,T2S,T2F)

dM = zeros(2,1);	

dM(1) = - M(1)/T2S;
dM(2) = - M(2)/T2F;



