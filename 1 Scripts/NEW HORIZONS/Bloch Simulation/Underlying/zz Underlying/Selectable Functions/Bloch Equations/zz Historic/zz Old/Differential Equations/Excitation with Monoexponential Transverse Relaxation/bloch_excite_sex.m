function dM = bloch_excite_sex(t,M,flag,T1,T2,w)

M0 = 100;
dM = zeros(2,1);				% a column vector

dM(1) = (-w * M(2)) + (M0 - M(1))/T1;
dM(2) = (w * M(1)) - M(2)/T2;









