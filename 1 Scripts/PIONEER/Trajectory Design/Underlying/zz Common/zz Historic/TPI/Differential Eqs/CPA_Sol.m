%=================================
% Constant Polar Angle Solution
%=================================

function dy = CPA_Sol(t,y,flag,F,PH) 

dy = zeros(2,1);

dy(1) = 1/(y(1)^2*F(y(1)));
dy(2) = sqrt((1 - dy(1)^2)/(y(1)^2 * (sin(PH))^2));







