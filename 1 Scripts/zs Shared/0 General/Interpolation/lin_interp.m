%==================================================
% Linear Interpolation
% - assumes evenly spaced rarr increasing linearly from 0 to 1
% - no checking to boost speed
%==================================================

function Val = lin_interp(rarr,F,r)

rarr = rarr*(length(rarr)-1);


r0 = floor(r*(length(rarr)-1)) + 1;
r1 = ceil(r*(length(rarr)-1)) + 1;

Val = (F(r1) - F(r0))*((r*(length(rarr)-1)+1)-r0) + F(r0);


