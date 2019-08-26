function dM = bloch_excite_sex_offres(t,M,flag,T1,T2,w)

M0 = 100;
dM = zeros(3,1);				

dM(1) = (-imag(w) * M(3)) - M(1)/T2 ;
dM(2) =  (real(w) * M(3)) - M(2)/T2 ;
dM(3) = -(real(w) * M(2)) + (imag(w) * M(1)) + (M0 - M(3))/T1; 





