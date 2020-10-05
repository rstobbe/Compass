%==================================================
% Linear Interpolation
% - assumes evenly spaced rarr increasing linearly from 0 to 1
% - no checking to boost speed
% - L must be length F - 1
%==================================================

function Val = lin_interp4(F,r,L)

r0 = floor(r*L);
r1 = ceil(r*L);

Val = (F(r1+1) - F(r0+1)).*((r*L)-r0) + F(r0+1);


