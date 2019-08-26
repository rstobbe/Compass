%==================================================
% Linear Interpolation
% - assumes evenly spaced rarr increasing linearly from 0 to 1
% - no checking to boost speed
%==================================================

function Val = lin_interp2(F,r,L)

r0 = floor(r*(L-1)) + 1;
r1 = ceil(r*(L-1)) + 1;

Val = (F(r1) - F(r0))*((r*(L-1)+1)-r0) + F(r0);


