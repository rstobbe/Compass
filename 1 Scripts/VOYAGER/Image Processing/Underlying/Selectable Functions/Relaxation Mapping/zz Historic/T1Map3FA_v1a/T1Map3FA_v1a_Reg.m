%==================================
% T1Map3FA_v1a
%==================================

function F = T1Map3FA_v1a_Reg(P,flip,INPUT) 

tr = INPUT.tr;
top = sin(flip).*(1 - exp(-tr/P(2)));
bot = 1 - cos(flip)*exp(-tr/P(2));

F = P(1) * top./bot;
