%=========================================================
% 
%=========================================================

function Mxy = T1_SSconstTRvarFA_v1a_Reg(P,Flip,INPUT) 

TR = INPUT.TR;

top = (1-exp(-TR/P(2)));
top = repmat(top,1,length(Flip));
bot = 1 - cos(pi*Flip/180)*exp(-TR/P(2));
Mz = top./bot;
Mxy = P(1)*sin(pi*Flip/180).*Mz;