%============================================
% Non-linear Regression
%============================================

t = []
Dat = [];

Start = [0.8,35];                                   % initial estimate 

[x,r,j] = nlinfit(t,Dat,'TransRelax',Start)         % select regression core 

ni = nlparci(x,r,j)                                 % analyze result
x
plot(t,Dat,'b',t,Dat-r,'r')                              